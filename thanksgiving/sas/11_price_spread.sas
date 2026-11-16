%put NOTE: Step 11: price spread, low-price quantiles and variance over the season.;

proc import datafile="&raw/usda_ams_turkey_frozen_by_region_range.csv"
    out=inter.range_raw dbms=csv replace;
    guessingrows=max;
run;

data tk.regional_range;
    set inter.range_raw(rename=(report_begin_date=begin_num));
    report_begin_date = input(put(begin_num, 8.), yymmdd8.);
    report_end_date = report_begin_date + 6;
    year = year(report_begin_date);
    week_mid = report_begin_date + 3;
    dtt = nwkdom(4, 5, 11, year) - week_mid;
    wtt = round((dtt - 2) / 7);
    low_flag = (price_min > wtd_avg_price);
    if low_flag then price_min = .;
    if price_max > 5 then price_max = .;
    lp = log(wtd_avg_price);
    llow = log(price_min);
    depth = 1 - price_min / wtd_avg_price;
    contiguous = (region not in ('AK', 'HI'));
    if 0 <= dtt <= &max_dtt;
    format report_begin_date report_end_date week_mid yymmdd10.;
    label wtd_avg_price = 'Advertised price, store-weighted average ($ per lb)'
          price_min = 'Lowest advertised price ($ per lb)'
          price_max = 'Highest advertised price ($ per lb)'
          depth = 'Lowest price as a discount to the average'
          dtt = 'Days to Thanksgiving (ad-week midpoint)'
          wtt = 'Ad weeks before Thanksgiving week';
    drop begin_num;
run;

proc sql;
    title 'Regional price range file: region-weeks by season';
    select year, count(*) as region_weeks, sum(low_flag) as low_above_average,
           min(report_begin_date) as first format=yymmdd10., max(report_begin_date) as last format=yymmdd10.
    from tk.regional_range group by year;
quit;
title;

data tk.range_model;
    set tk.regional_range;
    where contiguous and stores_with_ads >= 100;
run;

proc sql;
    create table tk.spread_profile as
    select wtt,
           count(*) as region_weeks,
           sum(stores_with_ads) / count(distinct year) as stores_per_season format=comma9.,
           sum(wtd_avg_price * stores_with_ads) / sum(stores_with_ads) as avg_price format=6.2,
           sum(price_min * stores_with_ads * (price_min > .)) / sum(stores_with_ads * (price_min > .)) as avg_low format=6.2,
           min(price_min) as lowest_seen format=6.2,
           sum(price_max * stores_with_ads * (price_max > .)) / sum(stores_with_ads * (price_max > .)) as avg_high format=6.2,
           mean(case when price_min > . then (price_min <= 0.50) end) as share_low_under_50c format=percent8.0,
           mean(depth) as mean_depth format=percent8.0
    from tk.range_model
    group by wtt
    order by wtt desc;

    title 'Season profile of the price range, six contiguous regions, 2015 onward';
    select * from tk.spread_profile;
quit;
title;

proc export data=tk.spread_profile outfile="&out/tables/spread_profile.csv" dbms=csv replace; run;

proc sql noprint;
    select max(dtt), min(dtt) into :dtt_hi trimmed, :dtt_lo trimmed from tk.range_model;
    select distinct region into :regions separated by ' ' from tk.range_model;
quit;

data inter.q_grid;
    length region $2;
    year = &forecast_year;
    grid = 1;
    do i = 1 to countw("&regions");
        region = scan("&regions", i);
        do dtt = &dtt_lo to &dtt_hi;
            output;
        end;
    end;
    drop i;
run;

data inter.q_in;
    set tk.range_model(in=a) inter.q_grid;
    if a then grid = 0;
run;

%macro season_level(in=, out=, y=);
    proc glm data=&in noprint;
        class region;
        model &y = region dtt dtt*dtt dtt*dtt*dtt;
        output out=inter.sl_res r=sl_r;
    run;
    quit;
    proc sql;
        create table inter.sl_year as
        select year, sum(sl_r * stores_with_ads) / sum(stores_with_ads) as &y._yr
        from inter.sl_res where sl_r > . group by year;
        create table &out as
        select a.*, b.&y._yr, a.&y - b.&y._yr as &y._adj,
               a.dtt * a.dtt as dtt2, a.dtt * a.dtt * a.dtt as dtt3,
               (a.region = 'MW') as r_mw, (a.region = 'NE') as r_ne, (a.region = 'NW') as r_nw,
               (a.region = 'SC') as r_sc, (a.region = 'SE') as r_se
        from &in as a left join inter.sl_year as b on a.year = b.year;
    quit;
%mend;

%macro q_fit(in=, y=, out=, ci=none, title=);
    proc quantreg data=&in ci=&ci;
        title "&title";
        class region;
        effect spl = spline(dtt / naturalcubic basis=tpf(noint) knotmethod=equal(4));
        model &y._adj = region spl / quantile=0.1 0.5 0.9 seed=&seed;
        output out=&out p=lq_adj / columnwise;
    run;
    title;
%mend;

%macro n_fit(in=, y=, out=, title=);
    ods output ParameterEstimates=inter.n_parms;
    proc autoreg data=&in;
        title "&title";
        model &y._adj = r_mw r_ne r_nw r_sc r_se dtt dtt2 dtt3 / method=ml;
        hetero dtt dtt2 / link=exp;
        output out=inter.n_fitted p=mu_fit cev=cev_fit r=resid;
    run;
    title;
    data inter.n_last;
        set inter.n_parms;
        length name $16;
        name = cats('b_', variable);
        seq = _n_;
    run;
    proc sort data=inter.n_last; by name seq; run;
    data inter.n_last;
        set inter.n_last;
        by name;
        if last.name;
    run;
    proc transpose data=inter.n_last out=inter.n_wide(drop=_name_);
        id name;
        var estimate;
    run;
    proc sql;
        create table &out as
        select f.*,
               w.b_intercept + w.b_r_mw * f.r_mw + w.b_r_ne * f.r_ne + w.b_r_nw * f.r_nw
               + w.b_r_sc * f.r_sc + w.b_r_se * f.r_se
               + w.b_dtt * f.dtt + w.b_dtt2 * f.dtt2 + w.b_dtt3 * f.dtt3 as mu_adj,
               w.b_het0 ** 2 * exp(w.b_het1 * f.dtt + w.b_het2 * f.dtt2) as cev
        from inter.n_fitted as f, inter.n_wide as w;
    quit;
%mend;

%season_level(in=inter.q_in, out=inter.q_lp, y=lp)
%season_level(in=inter.q_in, out=inter.q_llow, y=llow)

proc sql;
    title 'Season level relative to the pooled seasonal curve (log points)';
    select a.year, a.lp_yr format=7.3 label='Regional average price',
           b.llow_yr format=7.3 label='Lowest advertised price'
    from (select distinct year, lp_yr from inter.q_lp) as a
         inner join (select distinct year, llow_yr from inter.q_llow) as b on a.year = b.year;
quit;
title;

%q_fit(in=inter.q_lp, y=lp, out=inter.q_avg_pred, ci=resampling(nrep=400),
       title=%str(Quantile regression of the season-adjusted log regional average price: 10th, 50th and 90th percentiles))
%q_fit(in=inter.q_llow, y=llow, out=inter.q_low_pred, ci=resampling(nrep=400),
       title=%str(Quantile regression of the season-adjusted log lowest advertised price: 10th, 50th and 90th percentiles))

proc sql;
    create table inter.region_share as
    select region, sum(stores_with_ads) / (select sum(stores_with_ads) from tk.range_model) as share
    from tk.range_model group by region;

    create table inter.q_long as
    select 'Regional average price' as measure length=24, region, dtt, quantile, exp(lq_adj + lp_yr) as price
    from inter.q_avg_pred where grid = 1
    union all
    select 'Lowest advertised price' as measure length=24, region, dtt, quantile, exp(lq_adj + llow_yr) as price
    from inter.q_low_pred where grid = 1;

    create table tk.quantile_regional as
    select measure, region, dtt, &tday - dtt as date format=yymmdd10.,
           max(case when quantile = 0.1 then price end) as p10 format=6.2,
           max(case when quantile = 0.5 then price end) as p50 format=6.2,
           max(case when quantile = 0.9 then price end) as p90 format=6.2
    from inter.q_long
    group by measure, region, dtt
    order by measure, region, dtt desc;

    create table tk.quantile_curves as
    select q.measure, q.dtt, q.date,
           exp(sum(log(q.p10) * s.share)) as p10 format=6.2,
           exp(sum(log(q.p50) * s.share)) as p50 format=6.2,
           exp(sum(log(q.p90) * s.share)) as p90 format=6.2
    from tk.quantile_regional as q inner join inter.region_share as s on q.region = s.region
    group by q.measure, q.dtt, q.date
    order by q.measure, q.dtt desc;

    title "Quantile curves for &forecast_year, store-weighted across six regions, by ad week";
    select measure, dtt, date, p10, p50, p90
    from tk.quantile_curves
    where mod(dtt - 2, 7) = 0
    order by measure, dtt desc;
quit;
title;

proc export data=tk.quantile_curves outfile="&out/tables/quantile_curves.csv" dbms=csv replace; run;
proc export data=tk.quantile_regional outfile="&out/tables/quantile_regional.csv" dbms=csv replace; run;

%n_fit(in=inter.q_lp, y=lp, out=inter.var_out,
       title=%str(Variance model for the season-adjusted log regional average price: error variance exp-linear in days to Thanksgiving))

proc sql;
    create table tk.variance_profile as
    select wtt, count(*) as region_weeks,
           sqrt(mean(cev)) as model_sd format=6.3,
           std(resid) as residual_sd format=6.3,
           std(llow - lp) as sd_log_discount format=6.3,
           mean(log(price_max / price_min)) as mean_log_range format=6.2,
           exp(mean(log(price_max / price_min))) as high_to_low_ratio format=6.1
    from inter.var_out
    where grid = 0
    group by wtt
    order by wtt desc;

    title 'Variance over the season';
    title2 'Between region-weeks: model and residual SD of the log average price. Within a region-week: log high/low range.';
    select * from tk.variance_profile;
quit;
title;

proc export data=tk.variance_profile outfile="&out/tables/variance_profile.csv" dbms=csv replace; run;

%macro q_backtest(first=2019, last=2025, lead=14);
    proc datasets lib=inter nolist nowarn; delete qbt_results; quit;
    %do y = &first %to &last;
        %let origin = %eval(%sysfunc(nwkdom(4, 5, 11, &y)) - &lead);
        data inter.qbt_in;
            set tk.range_model;
            where year <= &y;
            test = (year = &y and report_end_date > &origin);
            lp_obs = lp;
            llow_obs = llow;
            if test then do; lp = .; llow = .; end;
        run;
        %do k = 1 %to 2;
            %if &k = 1 %then %do; %let resp = lp; %let lab = Regional average price; %end;
            %else %do; %let resp = llow; %let lab = Lowest advertised price; %end;
            %season_level(in=inter.qbt_in, out=inter.qbt_adj, y=&resp)
            %q_fit(in=inter.qbt_adj, y=&resp, out=inter.qbt_q)
            proc glm data=inter.qbt_adj noprint;
                class region;
                model &resp._adj = region dtt dtt2 dtt3;
                output out=inter.qbt_n0 p=mu_adj stdi=sdi;
            run;
            quit;
            %n_fit(in=inter.qbt_adj, y=&resp, out=inter.qbt_n1)
            data inter.qbt_n;
                length model $32;
                set inter.qbt_n0(in=a) inter.qbt_n1;
                where test and &resp._obs > . and &resp._yr > .;
                if a then do; model = 'Normal, constant variance'; sd = sdi; end;
                else do; model = 'Normal, variance by date'; sd = sqrt(cev); end;
                do quantile = 0.1, 0.5, 0.9;
                    pred = mu_adj + &resp._yr + probit(quantile) * sd;
                    output;
                end;
            run;
            proc sql;
                create table inter.qbt_one as
                select "&lab" as measure length=24, 'Quantile regression' as model length=32, &y as year,
                       region, dtt, quantile, &resp._obs as actual, lq_adj + &resp._yr as pred
                from inter.qbt_q where test and &resp._obs > . and &resp._yr > .
                union all
                select "&lab", model, &y, region, dtt, quantile, &resp._obs, pred
                from inter.qbt_n;
            quit;
            proc append base=inter.qbt_results data=inter.qbt_one force; run;
        %end;
    %end;
%mend;

ods exclude all;
%q_backtest()
ods exclude none;

data tk.quantile_backtest_detail;
    set inter.qbt_results;
    u = actual - pred;
    pinball = u * (quantile - (u < 0));
    below = (actual < pred);
run;

proc sql;
    create table tk.quantile_backtest as
    select measure, model, quantile, count(*) as region_weeks,
           mean(pinball) as pinball_loss format=7.4,
           mean(below) as share_below format=percent8.1
    from tk.quantile_backtest_detail
    group by measure, model, quantile
    order by measure, quantile, model;

    title 'Quantile backtest, seasons 2019-2025, origin 14 days before Thanksgiving';
    title2 'Pinball loss on the log scale (lower is better); share of outcomes below the predicted quantile (target = the quantile)';
    select * from tk.quantile_backtest;
quit;
title;

proc export data=tk.quantile_backtest outfile="&out/tables/quantile_backtest.csv" dbms=csv replace; run;

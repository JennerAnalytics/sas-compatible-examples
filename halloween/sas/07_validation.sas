%let bt_first = 2016;
%let bt_last = 2025;

%macro bt_split(y=, origin=);
    data inter.bt_in;
        set pk.model_weekly;
        where year <= &y;
        test = (year = &y and report_end_date > &origin);
        lp_obs = lp;
        if test then lp = .;
    run;
%mend;

%macro bt_collect(model=, y=, origin_label=, in=);
    data inter.bt_piece;
        length model $12 origin $8;
        set &in;
        where test = 1;
        model = "&model";
        origin = "&origin_label";
    run;
    proc append base=inter.bt_results data=inter.bt_piece force; run;
%mend;

%macro bt_naive(y=, origin_label=);
    data inter.bt_hist;
        set pk.model_weekly;
        by year;
        where year < &y;
        d = dif(lp);
        if first.year then d = .;
    run;
    proc sql;
        create table inter.bt_naive as
        select t.*, k.lp as mu,
               (t.report_begin_date - k.report_begin_date) / 7 as h,
               s.sd_step * sqrt(calculated h) as se,
               calculated mu - 1.96 * calculated se as lo,
               calculated mu + 1.96 * calculated se as hi
        from inter.bt_in(where=(test = 1)) as t,
             (select lp, report_begin_date from inter.bt_in
              where year = &y and test = 0
              having report_begin_date = max(report_begin_date)) as k,
             (select std(d) as sd_step from inter.bt_hist) as s;
    quit;
    %bt_collect(model=Naive, y=&y, origin_label=&origin_label, in=inter.bt_naive)
%mend;

%macro bt_glm(y=, origin_label=, deg=);
    proc glm data=inter.bt_in noprint;
        class year;
        model lp = year %if &deg >= 1 %then dth; %if &deg >= 2 %then dth*dth; %if &deg >= 3 %then dth*dth*dth;;
        output out=inter.bt_glm p=mu lcl=lo ucl=hi stdi=se;
    run;
    quit;
    %bt_collect(model=A&deg, y=&y, origin_label=&origin_label, in=inter.bt_glm)
%mend;

%macro bt_gam(y=, origin_label=);
    proc gam data=inter.bt_in;
        class year;
        model lp = param(year) spline(dth, df=3);
        output out=inter.bt_gam pred resid std;
    run;
    proc sql;
        create table inter.bt_gam_var as
        select sum(r_lp ** 2) / (count(r_lp) - 19) as s2, count(r_lp) - 19 as df,
               sum(year = &y and not missing(r_lp)) as n_season
        from inter.bt_gam;
    quit;
    data inter.bt_gam;
        set inter.bt_gam;
        if _n_ = 1 then set inter.bt_gam_var;
        mu = p_lp;
        se = sqrt(std_dth ** 2 + s2 / n_season + s2);
        lo = mu - tinv(0.975, df) * se;
        hi = mu + tinv(0.975, df) * se;
    run;
    %bt_collect(model=B1, y=&y, origin_label=&origin_label, in=inter.bt_gam)
%mend;

%macro bt_ucm(y=, origin=, origin_label=);
    %daily_frame(in=inter.bt_known, out=inter.bt_frame, last_date=%sysfunc(mdy(10, 31, &y)))
    proc sql noprint;
        select max(date) format=8., mdy(10, 31, &y) - max(date) into :last_obs trimmed, :lead trimmed
        from inter.bt_frame where not missing(lp);
    quit;
    proc ucm data=inter.bt_frame noprint;
        id date interval=day;
        model lp = dth dth2;
        irregular;
        level;
        estimate;
        forecast lead=&lead outfor=inter.bt_ucmfor;
    run;
    proc sql;
        create table inter.bt_ucm as
        select t.*, f.forecast as mu, f.std as se, f.lcl as lo, f.ucl as hi
        from inter.bt_in(where=(test = 1)) as t
             left join inter.bt_ucmfor as f on t.week_mid = f.date;
    quit;
    %bt_collect(model=C, y=&y, origin_label=&origin_label, in=inter.bt_ucm)
%mend;

%macro backtest(models=Naive A0 A1 A2 A3 B1 C);
    proc datasets lib=inter nolist; delete bt_results; quit;
    %do y = &bt_first %to &bt_last;
        %do o = 1 %to 2;
            %if &o = 1 %then %do; %let origin = %sysfunc(mdy(9, 30, &y)); %let olab = Sep30; %end;
            %else %do; %let origin = %sysfunc(mdy(10, 21, &y)); %let olab = Oct21; %end;
            %bt_split(y=&y, origin=&origin)
            proc sql noprint; select count(*) into :ntest trimmed from inter.bt_in where test; quit;
            %if &ntest > 0 %then %do;
                data inter.bt_known; set inter.bt_in; where not test; run;
                %if %index(&models, Naive) %then %do; %bt_naive(y=&y, origin_label=&olab) %end;
                %if %index(&models, A0) %then %do; %bt_glm(y=&y, origin_label=&olab, deg=0) %end;
                %if %index(&models, A1) %then %do; %bt_glm(y=&y, origin_label=&olab, deg=1) %end;
                %if %index(&models, A2) %then %do; %bt_glm(y=&y, origin_label=&olab, deg=2) %end;
                %if %index(&models, A3) %then %do; %bt_glm(y=&y, origin_label=&olab, deg=3) %end;
                %if %index(&models, B1) %then %do; %bt_gam(y=&y, origin_label=&olab) %end;
                %if %index(&models, C) %then %do; %bt_ucm(y=&y, origin=&origin, origin_label=&olab) %end;
            %end;
        %end;
    %end;
%mend;

%backtest();

data pk.backtest;
    set inter.bt_results;
    actual = exp(lp_obs);
    pred = exp(mu + se ** 2 / 2);
    lo95 = exp(lo);
    hi95 = exp(hi);
    err = pred - actual;
    abs_err = abs(err);
    sq_err = err ** 2;
    ape = abs_err / actual;
    covered = (lo95 <= actual <= hi95);
    width = hi95 - lo95;
    keep model origin year report_begin_date dth stores_with_ads actual pred lo95 hi95
         err abs_err sq_err ape covered width;
run;

proc sort data=pk.backtest; by model origin year pred; run;

data inter.bt_best_pred;
    set pk.backtest;
    by model origin year;
    if first.year;
    keep model origin year report_begin_date actual;
    rename report_begin_date = pred_best_week actual = actual_at_pred_best;
run;

proc sql;
    create table inter.bt_best as
    select p.*, a.actual_min,
           (p.actual_at_pred_best = a.actual_min) as hit_lowest,
           p.actual_at_pred_best - a.actual_min as regret
    from inter.bt_best_pred as p
         inner join (select model, origin, year, min(actual) as actual_min
                     from pk.backtest group by model, origin, year) as a
         on p.model = a.model and p.origin = a.origin and p.year = a.year;

    create table pk.model_comparison as
    select m.model, m.origin, m.n_weeks, m.mae, m.rmse, m.mape, m.coverage, m.mean_width,
           b.lowest_hit_rate, b.mean_regret
    from (select model, origin, count(*) as n_weeks,
                 mean(abs_err) as mae format=6.3,
                 sqrt(mean(sq_err)) as rmse format=6.3,
                 100 * mean(ape) as mape format=5.1,
                 100 * mean(covered) as coverage format=5.1,
                 mean(width) as mean_width format=6.2
          from pk.backtest group by model, origin) as m
         inner join
         (select model, origin, 100 * mean(hit_lowest) as lowest_hit_rate format=5.1,
                 mean(regret) as mean_regret format=6.3
          from inter.bt_best group by model, origin) as b
         on m.model = b.model and m.origin = b.origin
    order by origin, rmse;
quit;

proc print data=pk.model_comparison noobs label;
    label n_weeks = 'Weeks forecast' mae = 'MAE ($)' rmse = 'RMSE ($)' mape = 'MAPE (%)'
          coverage = '95% PI coverage (%)' mean_width = 'Mean PI width ($)'
          lowest_hit_rate = 'Cheapest week identified (%)' mean_regret = 'Mean regret ($)';
    title 'Rolling-origin backtest, seasons 2016-2025';
    title2 'Forecasts use only USDA reports published by each origin date';
run;
title;

proc export data=pk.model_comparison outfile="&out/tables/model_comparison.csv" dbms=csv replace; run;
proc export data=pk.backtest outfile="&out/tables/backtest_detail.csv" dbms=csv replace; run;

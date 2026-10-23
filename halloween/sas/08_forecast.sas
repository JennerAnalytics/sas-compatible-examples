data inter.oct_days;
    do date = mdy(10, 1, &forecast_year) to mdy(10, 31, &forecast_year);
        year = &forecast_year;
        dth = mdy(10, 31, year) - date;
        forecast_row = 1;
        output;
    end;
    format date yymmdd10.;
run;

data inter.profile_days;
    do dth = 55 to 0 by -1;
        year = &forecast_year - 1;
        profile_row = 1;
        output;
    end;
run;

data inter.fc_in;
    set pk.model_weekly(where=(report_end_date <= &cutoff))
        inter.oct_days
        inter.profile_days;
run;

proc glm data=inter.fc_in plots=none;
    class year;
    model lp = year dth dth*dth dth*dth*dth / solution;
    output out=inter.fc_out p=mu stdp=se_mean stdi=se_pred lcl=lo ucl=hi;
    title "Final model (&final_model): log advertised price on season effects and a cubic in days to Halloween";
    title2 "Fit on all national weeks published by &cutoff_txt";
run;
quit;
title;

proc sql;
    create table pk.season_profile as
    select dth, mdy(10, 31, &forecast_year) - dth as date format=yymmdd10.,
           exp(mu) / min(exp(mu)) as relative_price format=6.3
    from inter.fc_out(where=(profile_row = 1))
    order by dth desc;
quit;

proc sql noprint;
    create table inter.fc_mse as
    select sum((lp - mu) ** 2) / (count(lp) - 19) as mse, count(lp) - 19 as df_error
    from inter.fc_out where not missing(lp);
quit;

proc sql;
    create table inter.ad_weeks as
    select report_begin_date, report_end_date, wtd_avg_price, stores_with_ads
    from pk.model_weekly
    where year = &forecast_year and report_end_date <= &cutoff;

    create table inter.fc_daily as
    select f.date, f.dth, f.mu, f.se_mean, f.se_pred, f.lo, f.hi, w.wtd_avg_price as observed_price,
           w.report_begin_date as ad_week_start format=yymmdd10.
    from inter.fc_out(where=(forecast_row = 1)) as f
         left join inter.ad_weeks as w
         on f.date between w.report_begin_date and w.report_end_date
    order by f.date;
quit;

data pk.forecast_daily;
    length region $8 price_type $40 observation_status $9;
    set inter.fc_daily;
    if _n_ = 1 then set inter.fc_mse;
    region = 'National';
    price_type = 'Advertised retail, carving pumpkin, each';
    predicted_price = exp(mu + se_pred ** 2 / 2);
    median_price = exp(mu);
    prediction_lower_95 = exp(lo);
    prediction_upper_95 = exp(hi);
    forecast_cutoff = &cutoff;
    if not missing(observed_price) then observation_status = 'observed';
    else if date <= &cutoff then observation_status = 'inferred';
    else observation_status = 'forecast';
    format forecast_cutoff date yymmdd10. predicted_price median_price prediction_lower_95
           prediction_upper_95 observed_price 6.2;
    drop mse df_error;
run;

proc sql;
    create table pk.best_day as
    select date, predicted_price, prediction_lower_95, prediction_upper_95
    from pk.forecast_daily
    where observation_status = 'forecast'
    having predicted_price = min(predicted_price);

    create table pk.savings as
    select b.date as best_date format=yymmdd10., b.predicted_price as best_price format=6.2,
           f.date as compare_date format=yymmdd10., f.predicted_price as compare_price format=6.2,
           f.predicted_price - b.predicted_price as expected_saving format=6.2
    from pk.best_day as b, pk.forecast_daily as f
    where f.date in (&cutoff + 1, mdy(10, 31, &forecast_year));
quit;

data inter.sim_weeks;
    set pk.forecast_daily(where=(observation_status ne 'observed'));
    ad_week = intnx('week.7', date, 0, 'b');
    format ad_week yymmdd10.;
run;

data pk.sim_cheapest(keep=sim ad_week);
    if _n_ = 1 then set inter.fc_mse;
    call streaminit(&seed);
    array mus[31] _temporary_;
    array wks[31] _temporary_;
    array dts[31] _temporary_;
    array sem[31] _temporary_;
    do n = 1 by 1 until (eof);
        set inter.sim_weeks(where=(observation_status = 'forecast')) end=eof;
        mus[n] = mu; wks[n] = ad_week; dts[n] = date; sem[n] = se_mean;
    end;
    nd = n;
    do sim = 1 to &n_sims;
        level_shift = rand('normal', 0, sem[1]);
        best = constant('big');
        current_week = .;
        do i = 1 to nd;
            if wks[i] ne current_week then do;
                week_shock = rand('normal', 0, sqrt(mse));
                current_week = wks[i];
            end;
            price = exp(mus[i] + level_shift + week_shock);
            if price < best then do;
                best = price;
                ad_week = wks[i];
            end;
        end;
        output;
    end;
    format ad_week yymmdd10.;
    stop;
run;

proc freq data=pk.sim_cheapest;
    tables ad_week / out=pk.prob_cheapest_week nocum;
    title 'Probability that each remaining ad week has the lowest advertised price';
    title2 "Joint simulation, &n_sims paths, seed &seed";
run;

proc print data=pk.best_day noobs label;
    title 'Predicted lowest-price purchase date (among dates after the forecast cutoff)';
run;

proc print data=pk.savings noobs;
    title 'Expected saving at the predicted lowest-price date';
run;

proc print data=pk.forecast_daily noobs;
    var date observation_status observed_price predicted_price prediction_lower_95 prediction_upper_95;
    title 'Daily October forecast, national advertised carving-pumpkin price ($ each)';
run;
title;

data pk.cheapest_week;
    set pk.prob_cheapest_week;
    percent = percent;
    keep ad_week count percent;
run;

proc export data=pk.cheapest_week outfile="&out/tables/cheapest_week.csv" dbms=csv replace; run;

proc export data=pk.season_profile outfile="&out/tables/season_profile.csv" dbms=csv replace; run;

proc export data=pk.forecast_daily(keep=date region price_type observed_price predicted_price
        prediction_lower_95 prediction_upper_95 forecast_cutoff observation_status)
    outfile="&out/forecasts/pumpkin_price_forecast_oct&forecast_year..csv" dbms=csv replace;
run;

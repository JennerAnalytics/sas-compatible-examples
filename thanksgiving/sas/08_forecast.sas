%put NOTE: Step 08: forecast, simulation and exports.;

data inter.season_days;
    do date = &tday - &max_dtt to &tday;
        year = &forecast_year;
        dtt = &tday - date;
        forecast_row = 1;
        output;
    end;
    format date yymmdd10.;
run;

data inter.profile_days;
    do dtt = &max_dtt to 0 by -1;
        year = &forecast_year - 1;
        profile_row = 1;
        output;
    end;
run;

data inter.fc_in;
    set tk.model_weekly(where=(report_end_date <= &cutoff))
        inter.season_days
        inter.profile_days;
run;

proc glm data=inter.fc_in plots=none;
    class year;
    model lp = year dtt dtt*dtt dtt*dtt*dtt / solution;
    output out=inter.fc_out p=mu stdp=se_mean stdi=se_pred lcl=lo ucl=hi;
    title "Final model (&final_model): log advertised price on season effects and a cubic in days to Thanksgiving";
    title2 "Fit on all national weeks published by &cutoff_txt";
run;
quit;
title;

proc sql;
    create table tk.season_profile as
    select dtt, &tday - dtt as date format=yymmdd10.,
           exp(mu) / min(exp(mu)) as relative_price format=6.3
    from inter.fc_out(where=(profile_row = 1))
    order by dtt desc;
quit;

proc sql noprint;
    create table inter.fc_mse as
    select sum((lp - mu) ** 2) / (count(lp) - count(distinct year) - 3) as mse,
           count(lp) - count(distinct year) - 3 as df_error
    from inter.fc_out where not missing(lp);
quit;

proc sql;
    create table inter.ad_weeks as
    select report_begin_date, report_end_date, wtd_avg_price, stores_with_ads
    from tk.model_weekly
    where year = &forecast_year and report_end_date <= &cutoff;

    create table inter.fc_daily as
    select f.date, f.dtt, f.mu, f.se_mean, f.se_pred, f.lo, f.hi, w.wtd_avg_price as observed_price,
           w.report_begin_date as ad_week_start format=yymmdd10.
    from inter.fc_out(where=(forecast_row = 1)) as f
         left join inter.ad_weeks as w
         on f.date between w.report_begin_date and w.report_end_date
    order by f.date;
quit;

data tk.forecast_daily;
    length region $8 price_type $48 observation_status $9;
    set inter.fc_daily;
    region = 'National';
    price_type = 'Advertised retail, frozen whole turkey, per lb';
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
run;

proc sql;
    create table tk.best_day as
    select date, predicted_price, prediction_lower_95, prediction_upper_95
    from tk.forecast_daily
    where observation_status = 'forecast'
    having predicted_price = min(predicted_price);

    create table tk.savings as
    select b.date as best_date format=yymmdd10., b.predicted_price as best_price format=6.3,
           f.date as compare_date format=yymmdd10., f.predicted_price as compare_price format=6.3,
           f.predicted_price - b.predicted_price as expected_saving_per_lb format=6.3,
           16 * (f.predicted_price - b.predicted_price) as saving_16lb_bird format=6.2
    from tk.best_day as b, tk.forecast_daily as f
    where f.date in (&cutoff + 1, &tday - 1);
quit;

data inter.sim_weeks;
    set tk.forecast_daily(where=(observation_status = 'forecast'));
    ad_week = intnx('week.7', date, 0, 'b');
    format ad_week yymmdd10.;
run;

data tk.sim_cheapest(keep=sim ad_week last_week_price first_week_price);
    if _n_ = 1 then set inter.fc_mse;
    call streaminit(&seed);
    array mus[40] _temporary_;
    array wks[40] _temporary_;
    array sem[40] _temporary_;
    do n = 1 by 1 until (eof);
        set inter.sim_weeks end=eof;
        mus[n] = mu; wks[n] = ad_week; sem[n] = se_mean;
    end;
    nd = n;
    do sim = 1 to &n_sims;
        level_shift = rand('normal', 0, sem[1]);
        best = constant('big');
        current_week = .;
        first_week_price = .;
        do i = 1 to nd;
            if wks[i] ne current_week then do;
                week_shock = rand('normal', 0, sqrt(mse));
                current_week = wks[i];
            end;
            price = exp(mus[i] + level_shift + week_shock);
            if i = 1 then first_week_price = price;
            if price < best then do;
                best = price;
                ad_week = wks[i];
            end;
        end;
        last_week_price = price;
        output;
    end;
    format ad_week yymmdd10.;
    stop;
run;

proc freq data=tk.sim_cheapest;
    tables ad_week / out=tk.prob_cheapest_week nocum;
    title 'Probability that each remaining ad week has the lowest advertised price';
    title2 "Joint simulation, &n_sims paths, seed &seed";
run;

proc sql;
    create table tk.wait_odds as
    select mean(first_week_price < last_week_price) as p_now_beats_last_minute format=percent8.1,
           mean(last_week_price - first_week_price) as mean_cost_of_waiting format=6.3
    from tk.sim_cheapest;
quit;

proc print data=tk.wait_odds noobs;
    title 'Buying the day after the cutoff vs the day before Thanksgiving (simulated)';
run;

proc print data=tk.best_day noobs label;
    title 'Predicted lowest-price purchase date (among dates after the forecast cutoff)';
run;

proc print data=tk.savings noobs;
    title 'Expected saving at the predicted lowest-price date';
run;

proc print data=tk.forecast_daily noobs;
    var date observation_status observed_price predicted_price prediction_lower_95 prediction_upper_95;
    title 'Daily forecast, national advertised frozen whole-turkey price ($ per lb)';
run;
title;

data tk.cheapest_week;
    set tk.prob_cheapest_week;
    keep ad_week count percent;
run;

proc export data=tk.cheapest_week outfile="&out/tables/cheapest_week.csv" dbms=csv replace; run;
proc export data=tk.savings outfile="&out/tables/savings.csv" dbms=csv replace; run;
proc export data=tk.wait_odds outfile="&out/tables/wait_odds.csv" dbms=csv replace; run;
proc export data=tk.season_profile outfile="&out/tables/season_profile.csv" dbms=csv replace; run;
proc export data=tk.loss_leader outfile="&out/tables/loss_leader.csv" dbms=csv replace; run;

proc export data=tk.forecast_daily(keep=date region price_type observed_price predicted_price
        prediction_lower_95 prediction_upper_95 forecast_cutoff observation_status)
    outfile="&out/forecasts/turkey_price_forecast_thanksgiving&forecast_year..csv" dbms=csv replace;
run;

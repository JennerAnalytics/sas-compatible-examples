%let ucm_last_day = &tday;

data inter.ucm_known;
    set tk.model_weekly;
    where report_end_date <= &cutoff;
run;

%daily_frame(in=inter.ucm_known, out=inter.daily_frame, last_date=&ucm_last_day);

proc sql noprint;
    select &ucm_last_day - max(date) into :ucm_lead trimmed
    from inter.daily_frame where not missing(lp);
quit;

proc ucm data=inter.daily_frame;
    id date interval=day;
    model lp = dtt dtt2;
    irregular;
    level;
    estimate;
    forecast lead=&ucm_lead outfor=inter.ucm_for;
    title 'Model C: unobserved-components model, daily latent level observed at ad-week midpoints';
run;

data tk.ucm_forecast;
    set inter.ucm_for;
    where year(date) = &forecast_year and month(date) >= 10;
run;

proc print data=tk.ucm_forecast(where=(month(date) = 11)) noobs;
    var date lp forecast std lcl ucl;
    title 'Model C: daily forecasts for November (log scale)';
run;
title;

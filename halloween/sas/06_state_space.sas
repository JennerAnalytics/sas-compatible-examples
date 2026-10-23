

%daily_frame(in=pk.model_weekly, out=inter.daily_frame, last_date=%sysfunc(mdy(10, 31, &forecast_year)));

proc ucm data=inter.daily_frame;
    id date interval=day;
    model lp = dth dth2;
    irregular;
    level;
    estimate;
    forecast lead=18 outfor=inter.ucm_for;
    title 'Model C: unobserved-components model, daily latent level observed at ad-week midpoints';
run;

data pk.ucm_forecast;
    set inter.ucm_for;
    where year(date) = &forecast_year and month(date) >= 9;
run;

proc print data=pk.ucm_forecast(where=(month(date) = 10)) noobs;
    var date lp forecast std lcl ucl;
    title 'Model C: daily forecasts for October (log scale)';
run;
title;

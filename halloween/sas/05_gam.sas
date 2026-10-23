proc gam data=pk.model_weekly;
    class year;
    model lp = param(year) spline(dth, df=3);
    output out=inter.gam_b1 pred resid std;
    title 'Model B1: GAM, year effects + smoothing spline in days-to-Halloween';
run;

proc gam data=pk.model_weekly(where=(not missing(lwh_lag7)));
    class year;
    model lp = param(year lwh_lag7 gt_patch) spline(dth, df=3);
    output out=inter.gam_b2 pred resid std;
    title 'Model B2: GAM + lagged wholesale price and search interest';
run;

proc gam data=pk.model_weekly(where=(not missing(lwh_lag7)));
    class year;
    model lp = param(year) spline(dth, df=3) spline(lwh_lag7, df=3);
    title 'Model B3: GAM with smooth wholesale-price term';
run;

proc glm data=pk.model_weekly(where=(not missing(lwh_lag7))) plots=none;
    class year;
    model lp = year dth dth*dth lwh_lag7 gt_patch / solution ss3;
    title 'Model B2 parametric check (OLS): wholesale pass-through and search interest';
run;
quit;

proc glm data=pk.model_weekly noprint;
    class year;
    model lp = year dth dth*dth;
    lsmeans year / out=inter.year_effects noprint;
run;
quit;

data inter.year_supply;
    merge inter.year_effects(keep=year lsmean) pk.supply(keep=year total_cwt fresh_cwt);
    by year;
    if not missing(lsmean) and not missing(total_cwt);
    log_total = log(total_cwt);
    log_fresh = log(fresh_cwt);
run;

proc reg data=inter.year_supply plots=none;
    model lsmean = log_total;
    title 'Hypothesis 3: season price level vs national pumpkin production (2011-2025)';
run;
quit;

proc reg data=inter.year_supply(where=(not missing(log_fresh))) plots=none;
    model lsmean = log_fresh;
    title 'Hypothesis 3: season price level vs fresh-market production (2016-2025)';
run;
quit;
title;

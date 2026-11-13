%put NOTE: Step 05: GAM and the advertising-stores effect.;

proc gam data=tk.model_weekly;
    class year;
    model lp = param(year) spline(dtt, df=3);
    output out=inter.gam_b1 pred resid std;
    title 'Model B1: GAM, year effects + smoothing spline in days-to-Thanksgiving';
run;

proc glm data=tk.model_weekly plots=none;
    class year;
    model lp = year dtt dtt*dtt lstores / solution ss3;
    title 'Model B2 (OLS): does the number of advertising stores explain price beyond the calendar?';
run;
quit;

proc glm data=tk.model_weekly plots=none;
    class year;
    model lp = year lstores / solution ss3;
    title 'Feature-rate elasticity: log price on log advertising stores, within season';
run;
quit;
title;

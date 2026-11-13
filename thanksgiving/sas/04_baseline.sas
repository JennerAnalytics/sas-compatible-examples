%macro fit_poly(deg=, label=);
    proc glmselect data=tk.model_weekly;
        class year;
        model lp = year
            %if &deg >= 1 %then dtt;
            %if &deg >= 2 %then dtt*dtt;
            %if &deg >= 3 %then dtt*dtt*dtt;
            / selection=none stats=(aic aicc sbc adjrsq);
        ods output FitStatistics=inter.fit_a&deg;
        title "Model A&deg: &label";
    run;
%mend;

%fit_poly(deg=0, label=year effects only (flat season));
%fit_poly(deg=1, label=year effects + linear days-to-Thanksgiving);
%fit_poly(deg=2, label=year effects + quadratic days-to-Thanksgiving);
%fit_poly(deg=3, label=year effects + cubic days-to-Thanksgiving);

proc glm data=tk.model_weekly plots=none;
    class year;
    model lp = year dtt dtt*dtt / solution;
    output out=inter.base_resid r=resid p=pred;
    title 'Model A2 (OLS): parameter estimates';
run;
quit;

proc sort data=inter.base_resid; by report_begin_date; run;

data inter.base_resid;
    set inter.base_resid;
    by year;
    lag_resid = lag(resid);
    if first.year then lag_resid = .;
run;

proc corr data=inter.base_resid nosimple;
    var resid;
    with lag_resid;
    title 'Model A2: first-order residual autocorrelation within season';
run;

proc univariate data=inter.base_resid normal noprint;
    var resid;
    output out=inter.base_norm normaltest=sw probn=p_sw std=sd;
run;

proc print data=inter.base_norm noobs;
    title 'Model A2 residuals: Shapiro-Wilk';
run;
title;

proc sql noprint;
    select date format=8., predicted_price format=6.2
        into :best_date trimmed, :best_price trimmed
    from pk.best_day;
quit;

data inter.plot;
    set pk.forecast_daily;
    if observation_status = 'forecast' or date = &cutoff then do;
        fc_price = predicted_price;
        fc_lo = prediction_lower_95;
        fc_hi = prediction_upper_95;
    end;
    if observation_status ne 'forecast' then fit_price = predicted_price;
    if date = &best_date then do;
        best_price = predicted_price;
        best_label = catx(' ', 'Predicted low:', put(date, monname3.), cats(day(date), ','), cats('$', put(predicted_price, 4.2)));
    end;
run;

proc sql;
    create table inter.plot_obs as
    select report_begin_date, report_end_date, wtd_avg_price as week_price,
           report_begin_date + 3 as week_mid format=yymmdd10.
    from pk.model_weekly
    where year = &forecast_year and report_end_date <= &cutoff
          and report_end_date >= mdy(10, 1, &forecast_year);
quit;

data inter.plot;
    set inter.plot inter.plot_obs;
run;

%macro pumpkin_chart(fmt=);
    ods graphics on / reset=all width=1200px height=720px imagefmt=&fmt
        imagename="pumpkin_forecast_oct&forecast_year" noborder;
    proc sgplot data=inter.plot noautolegend;
        title1 height=16pt bold 'The Economics of Halloween';
        title2 height=12pt 'When Is the Best Day to Buy a Pumpkin?';
        title3 height=9pt color=gray "Daily pumpkin price forecasts for October &forecast_year, with 95% prediction intervals";
        band x=date lower=fc_lo upper=fc_hi / fillattrs=(color=cxF2A65A) transparency=0.65
            legendlabel='95% prediction interval' name='band';
        series x=date y=fit_price / lineattrs=(color=gray pattern=shortdash thickness=1.5)
            legendlabel='Model fit (in-sample)' name='fit';
        series x=date y=fc_price / lineattrs=(color=cxD9661F thickness=2.5)
            legendlabel='Expected advertised price (forecast)' name='fc';
        vector x=report_end_date y=week_price / xorigin=report_begin_date yorigin=week_price
            noarrowheads lineattrs=(color=cx2B3A55 thickness=2) legendlabel='Observed weekly ad price' name='obs';
        scatter x=week_mid y=week_price / markerattrs=(symbol=circlefilled color=cx2B3A55 size=9);
        scatter x=date y=best_price / markerattrs=(symbol=diamondfilled color=cxB22222 size=12)
            datalabel=best_label datalabelattrs=(color=cxB22222 size=10) datalabelpos=bottom;
        refline &cutoff / axis=x lineattrs=(pattern=dash color=gray)
            label='Forecast cutoff' labelloc=inside labelpos=max;
        xaxis type=time interval=day valuesformat=day2. label='October' min="01OCT&forecast_year"d max="31OCT&forecast_year"d
            values=("01OCT&forecast_year"d to "31OCT&forecast_year"d by 5) grid gridattrs=(color=cxEEEEEE);
        yaxis label='Advertised price, US$ per pumpkin' valuesformat=dollar6.2 grid gridattrs=(color=cxEEEEEE);
        keylegend 'obs' 'fit' 'fc' 'band' / location=outside position=bottom noborder;
        footnote1 j=l height=8pt color=gray "Model: OLS of log advertised price on season effects and a cubic in days to Halloween; selected by rolling-origin backtest (2016-2025).";
        footnote2 j=l height=8pt color=gray "Data: USDA AMS Weekly Grocery Store Specialty Crops Feature Activity (national, carving pumpkins, each). Forecast cutoff &cutoff_txt..";
        footnote3 j=l height=8pt color=gray "Prices are weighted-average advertised prices, not transaction prices. Ads run weekly, so day-to-day values are modelled, not observed.";
        footnote4 j=l height=8pt color=gray "The band is a 95% prediction interval for the national average advertised price on each day.";
        footnote5 j=l height=8pt color=gray "Forecast generated using Jenner Analytics, a SAS-compatible statistical computing platform.";
    run;
%mend;

ods listing gpath="&out/figures";
%pumpkin_chart(fmt=svg)
%pumpkin_chart(fmt=png)
title;
footnote;

ods pdf file="&out/figures/pumpkin_forecast_oct&forecast_year..pdf" notoc;
%pumpkin_chart(fmt=png)
ods pdf close;
title;
footnote;

%let chart_name = turkey_forecast_thanksgiving&forecast_year;

proc sql noprint;
    select date format=8., predicted_price format=6.2
        into :best_date trimmed, :best_price trimmed
    from tk.best_day;
quit;

data inter.plot;
    set tk.forecast_daily;
    if observation_status = 'forecast' or date = &cutoff then do;
        fc_price = predicted_price;
        fc_lo = prediction_lower_95;
        fc_hi = prediction_upper_95;
    end;
    if observation_status ne 'forecast' then fit_price = predicted_price;
    if date = &best_date then do;
        best_price = predicted_price;
        best_label = catx(' ', 'Predicted low:', put(date, monname3.), cats(day(date), ','), cats('$', put(predicted_price, 4.2), '/lb'));
    end;
run;

proc sql;
    create table inter.plot_obs as
    select report_begin_date, report_end_date, wtd_avg_price as week_price,
           report_begin_date + 3 as week_mid format=yymmdd10.
    from tk.model_weekly
    where year = &forecast_year and report_end_date <= &cutoff
          ;
quit;

data inter.plot;
    set inter.plot inter.plot_obs;
    seg_start = report_begin_date;
run;

%macro turkey_chart(fmt=);
    ods graphics on / reset=all width=1200px height=720px imagefmt=&fmt
        imagename="&chart_name" noborder;
    proc sgplot data=inter.plot noautolegend;
        title1 height=16pt bold 'The Economics of Thanksgiving';
        title2 height=12pt 'When Is the Best Time to Buy a Turkey?';
        title3 height=9pt color=gray "Daily frozen whole-turkey price forecasts for Thanksgiving &forecast_year, with 95% prediction intervals";
        band x=date lower=fc_lo upper=fc_hi / fillattrs=(color=cxD9A066) transparency=0.65
            legendlabel='95% prediction interval' name='band';
        series x=date y=fit_price / lineattrs=(color=gray pattern=shortdash thickness=1.5)
            legendlabel='Model fit (in-sample)' name='fit';
        series x=date y=fc_price / lineattrs=(color=cx8C4A2F thickness=2.5)
            legendlabel='Expected advertised price (forecast)' name='fc';
        vector x=report_end_date y=week_price / xorigin=seg_start yorigin=week_price
            noarrowheads lineattrs=(color=cx2B3A55 thickness=2) legendlabel='Observed weekly ad price' name='obs';
        scatter x=week_mid y=week_price / markerattrs=(symbol=circlefilled color=cx2B3A55 size=9);
        scatter x=date y=best_price / markerattrs=(symbol=diamondfilled color=cxA4262C size=12)
            datalabel=best_label datalabelattrs=(color=cxA4262C size=10) datalabelpos=bottom;
        refline &cutoff / axis=x lineattrs=(pattern=dash color=gray)
            label='Forecast cutoff' labelloc=inside labelpos=max;
        xaxis type=time interval=day valuesformat=mmddyy5. label='Date (Thanksgiving is November 26)'
            min="10OCT&forecast_year"d max="26NOV&forecast_year"d
            values=("10OCT&forecast_year"d to "26NOV&forecast_year"d by 7) grid gridattrs=(color=cxEEEEEE);
        yaxis label='Advertised price, US$ per lb' valuesformat=dollar6.2 min=0.80 max=1.80 grid gridattrs=(color=cxEEEEEE);
        keylegend 'obs' 'fit' 'fc' 'band' / location=outside position=bottom across=4 noborder;
        footnote1 j=l height=8pt color=gray "Model: OLS of log advertised price on season effects and a cubic in days to Thanksgiving; selected by rolling-origin backtest (2012-2025).";
        footnote2 j=l height=8pt color=gray "Data: USDA AMS Weekly Grocery Store Turkey Feature Activity (national, frozen whole turkeys). Cutoff &cutoff_txt..";
        footnote3 j=l height=8pt color=gray "Prices are store-weighted average advertised prices, not transaction prices. Ads run weekly, so day-to-day values are modelled, not observed.";
        footnote4 j=l height=8pt color=gray "The band is a 95% prediction interval for the national average advertised price on each day.";
        footnote5 j=l height=8pt color=gray "Forecast generated using Jenner Analytics, a SAS-compatible statistical computing platform.";
    run;
%mend;

ods listing gpath="&out/figures";
%turkey_chart(fmt=svg)
%turkey_chart(fmt=png)
title;
footnote;

ods pdf file="&out/figures/&chart_name..pdf" notoc;
%turkey_chart(fmt=png)
ods pdf close;
title;
footnote;

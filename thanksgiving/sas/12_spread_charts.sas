%put NOTE: Step 12: price-spread chart and regional maps.;

%let spread_name = turkey_price_spread_thanksgiving&forecast_year;
%let map_p10_name = turkey_p10_price_map_&forecast_year;
%let map_low_name = turkey_lowest_price_map_&forecast_year;

proc sql noprint;
    select max(report_begin_date) format=8., max(report_end_date) format=8.
        into :map_begin trimmed, :map_end trimmed
    from tk.regional_range where year = &forecast_year;
quit;

data _null_;
    call symputx('map_week_txt', catx(' ', day(&map_begin), put(&map_begin, monname3.), 'to',
                                      day(&map_end), put(&map_end, monname3.), year(&map_end)));
    call symputx('map_dtt', &tday - (&map_begin + 3));
run;

proc sql;
    create table inter.spread_obs as
    select week_mid as date format=yymmdd10.,
           sum(wtd_avg_price * stores_with_ads) / sum(stores_with_ads) as obs_avg,
           sum(price_min * stores_with_ads * (price_min > .)) / sum(stores_with_ads * (price_min > .)) as obs_low
    from tk.range_model
    where year = &forecast_year
    group by week_mid;

    create table inter.spread_plot as
    select a.date, a.p10 as avg_p10, a.p50 as avg_p50, a.p90 as avg_p90,
           l.p10 as low_p10, l.p50 as low_p50, l.p90 as low_p90
    from tk.quantile_curves(where=(measure = 'Regional average price')) as a
         inner join tk.quantile_curves(where=(measure = 'Lowest advertised price')) as l
         on a.date = l.date
    order by a.date;
quit;

data inter.spread_plot;
    set inter.spread_plot inter.spread_obs;
run;

%macro spread_chart(fmt=);
    ods graphics on / reset=all width=1200px height=720px imagefmt=&fmt
        imagename="&spread_name" noborder;
    proc sgplot data=inter.spread_plot;
        title1 height=16pt bold 'The Economics of Thanksgiving';
        title2 height=12pt 'The average barely moves. The cheapest ads fall by two-thirds by mid-November.';
        title3 height=9pt color=gray "Frozen whole turkeys, &forecast_year: 10th to 90th percentile bands across six US regions";
        band x=date lower=avg_p10 upper=avg_p90 / fillattrs=(color=cxD9A066) transparency=0.55
            legendlabel='Regional average price, 10th-90th percentile' name='avgband';
        series x=date y=avg_p50 / lineattrs=(color=cx8C4A2F thickness=2.5)
            legendlabel='Regional average price, median' name='avg';
        band x=date lower=low_p10 upper=low_p90 / fillattrs=(color=cx7FA6C9) transparency=0.55
            legendlabel='Lowest advertised price, 10th-90th percentile' name='lowband';
        series x=date y=low_p50 / lineattrs=(color=cx2B3A55 thickness=2.5)
            legendlabel='Lowest advertised price, median' name='low';
        scatter x=date y=obs_avg / markerattrs=(symbol=circlefilled color=cx8C4A2F size=10)
            legendlabel="Observed &forecast_year" name='obs';
        scatter x=date y=obs_low / markerattrs=(symbol=circlefilled color=cx2B3A55 size=10);
        refline &tday / axis=x lineattrs=(pattern=dash color=gray)
            label='Thanksgiving' labelloc=inside labelpos=max;
        xaxis type=time interval=day valuesformat=mmddyy5. label="Date (Thanksgiving is November %sysfunc(day(&tday)))"
            values=("10OCT&forecast_year"d to "28NOV&forecast_year"d by 7) grid gridattrs=(color=cxEEEEEE);
        yaxis label='Advertised price, US$ per lb' valuesformat=dollar6.2 min=0 max=2
            values=(0 to 2 by 0.25) grid gridattrs=(color=cxEEEEEE);
        keylegend 'avg' 'avgband' 'low' 'lowband' 'obs' / location=outside position=bottom across=3 noborder;
        footnote1 j=l height=8pt color=gray "Model: PROC QUANTREG on season-adjusted log prices, region effects and a natural cubic spline in days to Thanksgiving (2015-&forecast_year).";
        footnote2 j=l height=8pt color=gray "Data: USDA AMS Weekly Grocery Store Turkey Feature Activity, frozen conventional whole turkeys under 16 lb, six contiguous regions.";
        footnote3 j=l height=8pt color=gray "Lowest advertised price = the cheapest ad USDA found in a region that week. Some of these prices require an additional purchase.";
        footnote4 j=l height=8pt color=gray "Generated using Jenner Analytics, a SAS-compatible statistical computing platform.";
    run;
%mend;

ods listing gpath="&out/figures";
%spread_chart(fmt=svg)
%spread_chart(fmt=png)
title;
footnote;

proc format;
    value $usda_region
        'CT', 'DE', 'DC', 'MA', 'MD', 'ME', 'NH', 'NJ', 'NY', 'PA', 'RI', 'VT' = 'NE'
        'AL', 'FL', 'GA', 'MS', 'NC', 'SC', 'TN', 'VA', 'WV' = 'SE'
        'IA', 'IL', 'IN', 'KY', 'MI', 'MN', 'ND', 'NE', 'OH', 'SD', 'WI' = 'MW'
        'AR', 'CO', 'KS', 'LA', 'MO', 'NM', 'OK', 'TX' = 'SC'
        'AZ', 'CA', 'NV', 'UT' = 'SW'
        'ID', 'MT', 'OR', 'WA', 'WY' = 'NW'
        'AK' = 'AK'
        'HI' = 'HI'
        other = ' ';
    value $region_name
        'NE' = 'Northeast' 'SE' = 'Southeast' 'MW' = 'Midwest' 'SC' = 'South Central'
        'SW' = 'Southwest' 'NW' = 'Northwest' 'AK' = 'Alaska' 'HI' = 'Hawaii';
run;

proc sql;
    create table tk.region_map_values as
    select o.region, put(o.region, $region_name.) as region_name length=16,
           o.report_begin_date, o.stores_with_ads,
           o.wtd_avg_price as avg_price format=6.2,
           o.price_min as lowest_price format=6.2,
           o.price_max as highest_price format=6.2,
           q.p10 as avg_price_p10 format=6.2,
           q.p50 as avg_price_p50 format=6.2,
           l.p10 as lowest_price_p10 format=6.2
    from tk.regional_range as o
         left join tk.quantile_regional(where=(measure = 'Regional average price' and dtt = &map_dtt)) as q
         on o.region = q.region
         left join tk.quantile_regional(where=(measure = 'Lowest advertised price' and dtt = &map_dtt)) as l
         on o.region = l.region
    where o.report_begin_date = &map_begin
    order by o.region;

    title "Regional prices, ad week &map_week_txt: observed, and modelled percentiles for that week";
    select region_name, stores_with_ads format=comma8., avg_price, lowest_price, highest_price,
           avg_price_p10, avg_price_p50, lowest_price_p10
    from tk.region_map_values;
quit;
title;

proc export data=tk.region_map_values outfile="&out/tables/region_map_values.csv" dbms=csv replace; run;

data inter.county_map;
    set maps.uscounty;
    fips = state * 1000 + county;
    region = put(fipstate(state), $usda_region.);
    if region ne ' ';
run;

proc sql;
    create table inter.county_resp as
    select distinct c.fips, c.region, v.avg_price_p10, v.lowest_price
    from inter.county_map as c inner join tk.region_map_values as v on c.region = v.region;
quit;

proc sql;
    create table inter.region_labels as
    select c.region, mean(c.x) as lx, mean(c.y) as ly,
           catx(' ', v.region_name, cats('$', put(v.avg_price_p10, 4.2))) as p10_label length=32,
           catx(' ', v.region_name, cats('$', put(v.lowest_price, 4.2))) as low_label length=32,
           v.avg_price_p10, v.lowest_price
    from inter.county_map as c inner join tk.region_map_values as v on c.region = v.region
    group by c.region, v.region_name, v.avg_price_p10, v.lowest_price;
quit;

%macro region_map(var=, label=, name=, fmt=, t2=, t3=, f1=);
    ods graphics on / reset=all width=1200px height=780px imagefmt=&fmt
        imagename="&name" noborder;
    proc sgmap mapdata=inter.county_map maprespdata=inter.county_resp
        plotdata=inter.region_labels(where=(&var > .));
        title1 height=16pt bold 'The Economics of Thanksgiving';
        title2 height=12pt "&t2";
        title3 height=9pt color=gray "&t3";
        choromap &var / mapid=fips colormodel=(cx2B3A55 cx7FA6C9 cxF2D9A6 cxD9A066 cx8C4A2F)
            lineattrs=(thickness=0) name='map';
        text x=lx y=ly text=&label / textattrs=(size=11pt weight=bold color=black)
            backfill fillattrs=(color=white transparency=0.25);
        gradlegend 'map' / title='US$ per lb';
        footnote1 j=l height=8pt color=gray "&f1";
        footnote2 j=l height=8pt color=gray "Data: USDA AMS Weekly Grocery Store Turkey Feature Activity. USDA reports eight regions, so every county in a region has the same value.";
        footnote3 j=l height=8pt color=gray "Generated using Jenner Analytics, a SAS-compatible statistical computing platform.";
    run;
%mend;

%macro both_maps(fmt=);
    %region_map(var=avg_price_p10, label=p10_label, name=&map_p10_name, fmt=&fmt,
        t2=%str(A good week for your region: the 10th-percentile turkey price),
        t3=%str(Frozen whole turkeys, ad week &map_week_txt: 10th percentile of the regional average advertised price),
        f1=%str(10th percentile from PROC QUANTREG on season-adjusted log regional average prices, 2015-&forecast_year.. Alaska and Hawaii are not modelled.))
    %region_map(var=lowest_price, label=low_label, name=&map_low_name, fmt=&fmt,
        t2=%str(The cheapest turkey ad in each region),
        t3=%str(Frozen whole turkeys, ad week &map_week_txt: lowest advertised price found by USDA),
        f1=%str(Lowest advertised price for a conventional frozen whole turkey under 16 lb. Some of these prices require an additional purchase.))
%mend;

%both_maps(fmt=svg)
%both_maps(fmt=png)
title;
footnote;

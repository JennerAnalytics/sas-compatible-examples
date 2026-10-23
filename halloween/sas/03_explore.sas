ods listing gpath="&out/figures";
ods graphics on / reset=all width=900px height=520px imagefmt=png;

proc means data=pk.model_weekly n mean std min max maxdec=2;
    class year;
    var wtd_avg_price stores_with_ads;
    title 'Advertised national carving-pumpkin price by season ($ each)';
run;

data inter.explore;
    set pk.model_weekly;
    by year;
    retain base_lp;
    if first.year then base_lp = .;
run;

proc sql;
    create table inter.explore as
    select *, lp - mean(lp) as lp_dev, lwh_lag7 - mean(lwh_lag7) as lwh_dev,
           gt_patch - mean(gt_patch) as gt_dev
    from pk.model_weekly
    group by year
    order by report_begin_date;
quit;

proc corr data=inter.explore pearson spearman nosimple;
    var lp_dev;
    with dth lwh_dev gt_dev;
    title 'Within-season correlations of log advertised price (deviation from season mean)';
run;

proc sgplot data=inter.explore;
    ods graphics / imagename='explore_seasonal_profiles';
    series x=dth y=wtd_avg_price / group=year lineattrs=(thickness=1) transparency=0.3;
    xaxis reverse label='Days to Halloween (ad-week midpoint)';
    yaxis label='Advertised price ($ each)';
    title 'National advertised carving-pumpkin price by season, 2011-2026';
run;

proc sgplot data=inter.explore;
    ods graphics / imagename='explore_within_season';
    scatter x=dth y=lp_dev / markerattrs=(symbol=circlefilled size=6) transparency=0.4;
    loess x=dth y=lp_dev / nomarkers smooth=0.6;
    xaxis reverse label='Days to Halloween (ad-week midpoint)';
    yaxis label='Log price minus season mean';
    title 'Within-season price pattern';
run;
title;

proc sql;
    title 'Data inventory: retail rows by season (all regions and products)';
    select year, count(*) as rows, count(distinct region) as regions,
           count(distinct catx('|', variety, unit, organic)) as products,
           sum(missing(wtd_avg_price)) as missing_price
    from inter.retail_all group by year;

    title 'Data inventory: wholesale Howden 36-inch bin quotes, Sep 1 - Nov 15';
    select year, count(distinct report_date) as quote_days, mean(n_markets) as mean_markets format=4.1,
           min(wh_price) as min_price format=dollar7.2, max(wh_price) as max_price format=dollar7.2
    from pk.wholesale_daily group by year;

    title 'Data inventory: Google Trends daily series by season';
    select term, count(distinct year(date)) as seasons, count(*) as days, sum(is_partial) as partial_days
    from inter.trends_raw group by term;
quit;
title;

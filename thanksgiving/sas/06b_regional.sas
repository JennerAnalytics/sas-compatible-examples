%put NOTE: Step 06b: regional mixed models.;

proc sql;
    title 'Regional coverage: ad weeks with >= 100 advertising stores, 2015-2025';
    select region, count(*) as weeks, count(distinct year) as seasons,
           sum(wtd_avg_price * stores_with_ads) / sum(stores_with_ads) as mean_price format=6.2
    from tk.retail_regional
    where year < &forecast_year
    group by region
    order by calculated mean_price;
quit;

proc mixed data=tk.retail_regional method=reml;
    class region year;
    model lp = year dtt dtt*dtt / solution ddfm=kr;
    random region region*year;
    title 'Model D: regional mixed model with random region and region-by-season effects';
run;

proc mixed data=tk.retail_regional method=reml;
    class region year;
    model lp = year dtt dtt*dtt region region*dtt / ddfm=kr;
    random region*year;
    lsmeans region;
    title 'Do regions share the price level and the within-season pattern?';
run;
title;

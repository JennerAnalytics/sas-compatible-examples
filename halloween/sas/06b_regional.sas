proc sql;
    title 'Regional coverage: weeks with >= 50 advertising stores';
    select region, count(*) as weeks, count(distinct year) as seasons,
           mean(wtd_avg_price) as mean_price format=6.2
    from pk.retail_regional group by region;
quit;

proc mixed data=pk.retail_regional method=reml;
    class region year;
    model lp = year dth dth*dth / solution ddfm=kr;
    random region region*year;
    title 'Model D: regional mixed model with random region and region-by-season effects';
run;

proc mixed data=pk.retail_regional method=reml;
    class region year;
    model lp = year dth dth*dth region region*dth / ddfm=kr;
    random region*year;
    title 'Hypothesis 5: do regions share the within-season price pattern?';
run;
title;

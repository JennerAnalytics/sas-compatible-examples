%put NOTE: Step 03: explore the season, the loss leader and the fresh premium.;

ods listing gpath="&out/figures";
ods graphics on / reset=all width=900px height=520px imagefmt=png;

proc means data=tk.model_weekly n mean min max maxdec=2;
    class year;
    var wtd_avg_price stores_with_ads;
    title 'Advertised national frozen whole-turkey price by season ($ per lb)';
run;

proc sql;
    create table inter.explore as
    select *, lp - mean(lp) as lp_dev, lstores - mean(lstores) as lstores_dev,
           wtd_avg_price / min(wtd_avg_price) as rel_to_low,
           (wtd_avg_price = min(wtd_avg_price)) as is_low
    from tk.model_weekly
    where year < &forecast_year
    group by year
    order by report_begin_date;
quit;

proc means data=inter.explore n mean median min max maxdec=3;
    class wtt;
    var rel_to_low wtd_avg_price stores_with_ads;
    title 'Typical season by ad weeks before Thanksgiving week (0 = Thanksgiving week), 2005-2025';
    title2 'rel_to_low = price divided by that season''s lowest weekly price';
run;

proc freq data=inter.explore(where=(is_low = 1));
    tables wtt / nocum;
    title 'Which ad week had the season''s lowest advertised price? (2005-2025)';
run;

proc sql;
    create table tk.week_pairs as
    select a.year, a.wtd_avg_price as two_weeks_before format=6.2,
           b.wtd_avg_price as thanksgiving_week format=6.2,
           b.wtd_avg_price / a.wtd_avg_price - 1 as change format=percent8.1,
           (b.wtd_avg_price > a.wtd_avg_price) as higher_in_thanksgiving_week
    from inter.explore(where=(wtt = 2)) as a
         inner join inter.explore(where=(wtt = 0)) as b on a.year = b.year
    order by a.year;

    title 'Thanksgiving week vs two ad weeks earlier, by season';
    select count(*) as seasons, sum(higher_in_thanksgiving_week) as seasons_higher,
           mean(change) as mean_change format=percent8.1,
           median(change) as median_change format=percent8.1
    from tk.week_pairs;
quit;

proc corr data=inter.explore pearson spearman nosimple;
    var lp_dev;
    with dtt lstores_dev;
    title 'Within-season correlations of log advertised price (deviation from season mean)';
run;

proc sql;
    create table tk.loss_leader as
    select year,
           sum(wtd_avg_price * stores_with_ads) / sum(stores_with_ads) as retail_ad_price format=6.2,
           mean(wh_price_lag) as wholesale_price format=6.2,
           calculated retail_ad_price - calculated wholesale_price as margin format=6.2,
           calculated retail_ad_price / calculated wholesale_price - 1 as margin_pct format=percent8.1
    from tk.model_weekly
    where wtt <= 2 and not missing(wh_price_lag)
    group by year;
quit;

proc print data=tk.loss_leader noobs;
    title 'Loss leader check: retail ad price vs wholesale price, three ad weeks through Thanksgiving';
    title2 'Wholesale = frozen whole hens 8-16 lb, FOB, USDA weekly national report, week before the ad week';
run;

data inter.ll_weeks;
    set tk.model_weekly;
    where wtt <= 2 and not missing(lwh_lag);
    log_ratio = lp - lwh_lag;
run;

proc ttest data=inter.ll_weeks h0=0 plots=none;
    var log_ratio;
    title 'Log(retail ad price / wholesale price), ad weeks 0-2 before Thanksgiving, 2022-2026';
run;

proc sql;
    create table tk.fresh_premium as
    select z.year, z.report_begin_date, z.wtt, z.wtd_avg_price as frozen_price format=6.2,
           f.wtd_avg_price as fresh_price format=6.2,
           log(f.wtd_avg_price) - z.lp as log_premium,
           f.wtd_avg_price / z.wtd_avg_price - 1 as premium_pct format=percent8.1
    from tk.model_weekly as z
         inner join tk.fresh_national as f on z.report_begin_date = f.report_begin_date
    where z.wtt in (0, 1)
    order by z.report_begin_date;
quit;

proc means data=tk.fresh_premium n mean min max maxdec=2;
    class year;
    var frozen_price fresh_price premium_pct;
    title 'Fresh vs frozen whole turkey, the two ad weeks through Thanksgiving';
run;

proc ttest data=tk.fresh_premium h0=0 plots=none;
    var log_premium;
    title 'Log(fresh / frozen) advertised price, the two ad weeks through Thanksgiving';
run;

proc sgplot data=inter.explore;
    ods graphics / imagename='explore_seasonal_profiles';
    series x=dtt y=wtd_avg_price / group=year lineattrs=(thickness=1) transparency=0.3;
    xaxis reverse label='Days to Thanksgiving (ad-week midpoint)';
    yaxis label='Advertised price ($ per lb)';
    title 'National advertised frozen whole-turkey price by season, 2005-2025';
run;

proc sgplot data=inter.explore;
    ods graphics / imagename='explore_within_season';
    scatter x=dtt y=lp_dev / markerattrs=(symbol=circlefilled size=6) transparency=0.4;
    loess x=dtt y=lp_dev / nomarkers smooth=0.6;
    xaxis reverse label='Days to Thanksgiving (ad-week midpoint)';
    yaxis label='Log price minus season mean';
    title 'Within-season price pattern';
run;

proc sgplot data=inter.explore;
    ods graphics / imagename='explore_feature_rate';
    vbar wtt / response=stores_with_ads stat=mean fillattrs=(color=cx8C4A2F);
    xaxis reverse label='Ad weeks before Thanksgiving week';
    yaxis label='Mean stores advertising frozen whole turkeys';
    title 'Stores advertising frozen whole turkeys, by ad week';
run;
title;

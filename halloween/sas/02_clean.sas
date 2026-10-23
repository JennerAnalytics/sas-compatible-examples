data inter.retail_all;
    set inter.retail_raw;
    length series $40;
    year = year(report_begin_date);
    week_mid = report_begin_date + 3;
    halloween = mdy(10, 31, year);
    dth = halloween - week_mid;
    price_low  = input(scan(price_range, 1, '-'), ?? best12.);
    price_high = input(scan(price_range, 2, '-'), ?? best12.);
    if missing(price_high) then price_high = price_low;
    if price_low = 0 and price_high = 0 then call missing(price_low, price_high);
    series = catx(' | ', variety, unit, organic);
    format week_mid halloween yymmdd10.;
run;

proc sql;
    title 'Duplicate check: rows per report week, region and product';
    select count(*) as n_keys, sum(n > 1) as n_duplicated_keys
    from (select report_begin_date, region, variety, unit, organic, count(*) as n
          from inter.retail_all
          group by report_begin_date, region, variety, unit, organic);

    title 'Product definitions reported by year (National region)';
    select year, variety, unit, organic, count(*) as weeks
    from inter.retail_all
    where region = 'National'
    group by year, variety, unit, organic
    order by variety, unit, organic, year;
quit;
title;

data pk.retail_national pk.retail_excluded;
    set inter.retail_all;
    where region = 'National' and variety = 'N/A' and unit = 'each'
          and organic = 'No' and 2011 <= year <= &forecast_year;
    length exclusion $40;
    lp = log(wtd_avg_price);
    known_by = published_date;
    if not (-5 <= dth <= 60) then exclusion = 'outside Sep-Oct season window';
    else if stores_with_ads < &min_stores then exclusion = 'fewer than min_stores ads';
    if exclusion = '' then output pk.retail_national;
    else output pk.retail_excluded;
    label wtd_avg_price = 'Advertised price, weighted average ($ each)'
          stores_with_ads = 'Stores with ads'
          dth = 'Days to Halloween (ad-week midpoint)';
run;

data pk.retail_regional;
    set inter.retail_all;
    where region in ('Midwest' 'Northeast' 'Northwest' 'Southcentral' 'Southeast' 'Southwest')
          and variety = 'N/A' and unit = 'each' and organic = 'No'
          and -5 <= dth <= 60 and stores_with_ads >= 50;
    lp = log(wtd_avg_price);
run;

data inter.wholesale_howden;
    set inter.wholesale_raw;
    where variety in ('HOWDEN TYPE' 'HOWDEN') and package = '36 inch bins'
          and organic = 'N' and low_price > 0 and high_price > 0;
    mid = (low_price + high_price) / 2;
    lmid = log(mid);
run;

proc means data=inter.wholesale_howden noprint nway;
    class report_date market;
    var lmid;
    output out=inter.wh_market_day(drop=_type_ _freq_) mean=lmid;
run;

proc means data=inter.wh_market_day noprint nway;
    class report_date;
    var lmid;
    output out=pk.wholesale_daily(drop=_type_) mean=lwh n=n_markets;
run;

data pk.wholesale_daily;
    set pk.wholesale_daily(rename=(_freq_=n_market_days));
    year = year(report_date);
    wh_price = exp(lwh);
    label wh_price = 'Wholesale Howden 36-inch bin, geometric mean of market midpoints ($/bin)';
run;

proc sql;
    create table inter.wh_lag as
    select r.report_begin_date, mean(w.lwh) as lwh_lag7, count(w.lwh) as wh_days
    from pk.retail_national as r
         left join pk.wholesale_daily as w
         on w.report_date between r.report_begin_date - 7 and r.report_begin_date - 1
    group by r.report_begin_date;

    create table inter.trends_week as
    select r.report_begin_date, mean(t.index) as gt_patch
    from pk.retail_national as r
         left join inter.trends_raw(where=(term = 'pumpkin patch')) as t
         on t.date between r.report_begin_date and r.report_begin_date + 6
    group by r.report_begin_date;
quit;

data inter.nass;
    set inter.nass_raw;
    where Period = 'YEAR' and Geo_Level = 'NATIONAL';
    value_num = input(compress(Value, ','), ?? best20.);
run;

proc sql;
    create table pk.supply as
    select Year as year,
           max(case when Data_Item = 'PUMPKINS, FRESH MARKET, UTILIZED - PRODUCTION, MEASURED IN CWT'
                    then value_num end) as fresh_cwt,
           max(case when Data_Item = 'PUMPKINS - PRODUCTION, MEASURED IN CWT'
                    then value_num end) as total_cwt,
           max(case when Data_Item = 'PUMPKINS - ACRES HARVESTED'
                    then value_num end) as acres_harvested
    from inter.nass
    group by Year
    order by Year;
quit;

proc sql;
    create table pk.model_weekly as
    select r.year, r.report_begin_date, r.report_end_date, r.week_mid, r.published_date, r.dth,
           r.wtd_avg_price, r.lp, r.stores_with_ads, r.price_low, r.price_high,
           w.lwh_lag7, w.wh_days, t.gt_patch,
           log(s.total_cwt) as log_prod
    from pk.retail_national as r
         left join inter.wh_lag as w on r.report_begin_date = w.report_begin_date
         left join inter.trends_week as t on r.report_begin_date = t.report_begin_date
         left join pk.supply as s on r.year = s.year
    order by r.report_begin_date;
quit;

proc sql;
    title 'Modeling dataset: weeks by season';
    select year, count(*) as weeks, min(report_begin_date) as first format=yymmdd10.,
           max(report_begin_date) as last format=yymmdd10.,
           sum(missing(lwh_lag7)) as no_wholesale, sum(missing(gt_patch)) as no_trends
    from pk.model_weekly group by year;
    title 'Excluded national weeks';
    select year, report_begin_date format=yymmdd10., stores_with_ads, wtd_avg_price, exclusion
    from pk.retail_excluded order by report_begin_date;
quit;
title;

proc export data=pk.model_weekly outfile="&proc/model_weekly.csv" dbms=csv replace; run;

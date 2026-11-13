%put NOTE: Step 02: clean the data and build the modeling dataset.;

data inter.retail_all;
    set inter.retail_raw;
    year = year(report_begin_date);
    week_mid = report_begin_date + 3;
    tday = nwkdom(4, 5, 11, year);
    dtt = tday - week_mid;
    wtt = round((dtt - 2) / 7);
    stores_with_ads = max(under16_stores, over16_stores);
    wtd_avg_price = sum(under16_price * under16_stores, over16_price * over16_stores)
                    / sum(under16_stores * (under16_price > .), over16_stores * (over16_price > .));
    price_low = min(under16_min, over16_min);
    price_high = max(under16_max, over16_max);
    lp = log(wtd_avg_price);
    lstores = log(stores_with_ads);
    format week_mid tday yymmdd10.;
    label wtd_avg_price = 'Advertised price, store-weighted average ($ per lb)'
          stores_with_ads = 'Stores with ads'
          dtt = 'Days to Thanksgiving (ad-week midpoint)'
          wtt = 'Ad weeks before Thanksgiving week';
run;

proc sql;
    title 'Duplicate check: rows per report week and condition';
    select count(*) as n_keys, sum(n > 1) as n_duplicated_keys
    from (select report_begin_date, condition, count(*) as n
          from inter.retail_all group by report_begin_date, condition);

    title 'Size classes: share of weeks where under-16 lb and over-16 lb prices differ by more than 5 cents';
    select condition, count(*) as weeks,
           mean(abs(under16_price - over16_price) > 0.05) as share_differ format=percent8.1,
           mean(under16_price - over16_price) as mean_gap format=6.3
    from inter.retail_all
    where under16_price > . and over16_price > . and stores_with_ads >= &min_stores
    group by condition;
quit;
title;

data tk.frozen_national tk.frozen_excluded;
    set inter.retail_all;
    where condition = 'Frozen' and year <= &forecast_year;
    length exclusion $40;
    if not (0 <= dtt <= &max_dtt) then exclusion = 'outside pre-Thanksgiving window';
    else if stores_with_ads < &min_stores then exclusion = 'fewer than min_stores ads';
    if exclusion = '' then output tk.frozen_national;
    else if -7 <= dtt <= 60 then output tk.frozen_excluded;
run;

data tk.fresh_national;
    set inter.retail_all;
    where condition = 'Fresh' and 0 <= dtt <= &max_dtt and stores_with_ads >= &min_stores;
run;

data tk.retail_regional;
    set inter.regional_raw(rename=(report_begin_date=begin_num));
    report_begin_date = input(put(begin_num, 8.), yymmdd8.);
    year = year(report_begin_date);
    week_mid = report_begin_date + 3;
    dtt = nwkdom(4, 5, 11, year) - week_mid;
    wtt = round((dtt - 2) / 7);
    lp = log(wtd_avg_price);
    if 0 <= dtt <= 30 and stores_with_ads >= 100;
    format report_begin_date week_mid yymmdd10.;
    drop begin_num;
run;

data inter.wholesale;
    set inter.wholesale_raw(rename=(report_begin_date=begin_num));
    wh_begin = input(put(begin_num, 8.), yymmdd8.);
    w = max(volume, 1);
    format wh_begin yymmdd10.;
run;

proc means data=inter.wholesale noprint nway;
    class wh_begin;
    var wtd_avg_cents_lb;
    weight w;
    output out=tk.wholesale_weekly(drop=_type_ _freq_) mean=wh_cents;
run;

data tk.wholesale_weekly;
    set tk.wholesale_weekly;
    wh_price = wh_cents / 100;
    lwh = log(wh_price);
    label wh_price = 'Wholesale frozen whole hens 8-16 lb, FOB, weighted average ($ per lb)';
run;

proc sql;
    create table inter.wh_lag as
    select r.report_begin_date, mean(w.wh_price) as wh_price_lag, mean(w.lwh) as lwh_lag
    from tk.frozen_national as r
         left join tk.wholesale_weekly as w
         on w.wh_begin between r.report_begin_date - 8 and r.report_begin_date - 2
    group by r.report_begin_date;

    create table tk.model_weekly as
    select r.year, r.report_begin_date, r.report_end_date, r.week_mid, r.published_date, r.tday,
           r.dtt, r.wtt, r.wtd_avg_price, r.lp, r.stores_with_ads, r.lstores,
           r.price_low, r.price_high, w.wh_price_lag, w.lwh_lag
    from tk.frozen_national as r
         left join inter.wh_lag as w on r.report_begin_date = w.report_begin_date
    order by r.report_begin_date;
quit;

proc sql;
    title 'Modeling dataset: weeks by season';
    select year, count(*) as weeks, min(report_begin_date) as first format=yymmdd10.,
           max(report_begin_date) as last format=yymmdd10.,
           min(wtd_avg_price) as low format=6.2, max(wtd_avg_price) as high format=6.2,
           sum(missing(lwh_lag)) as no_wholesale
    from tk.model_weekly group by year;
    title 'Excluded national frozen weeks near the season';
    select year, report_begin_date format=yymmdd10., dtt, stores_with_ads, wtd_avg_price format=6.2, exclusion
    from tk.frozen_excluded order by report_begin_date;
quit;
title;

proc export data=tk.model_weekly outfile="&proc/model_weekly.csv" dbms=csv replace; run;

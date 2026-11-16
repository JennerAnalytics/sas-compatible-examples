%put NOTE: Step 13: social cards for the deal prices.;

%let ink = cx1F2433;
%let muted = cx5B6170;
%let paper = cxFBF7F1;
%let accent = cxA4502A;
%let band = cxE8C39E;
%let navy = cx2B3A55;
%let deal_cut = 0.50;

proc sql;
    create table inter.deal_curve as
    select l.date, l.dtt, l.p10 as deal_p10, l.p50 as deal_p50, l.p90 as deal_p90, a.p50 as avg_p50
    from tk.quantile_curves(where=(measure = 'Lowest advertised price')) as l
         inner join tk.quantile_curves(where=(measure = 'Regional average price')) as a
         on l.date = a.date
    order by l.date;
quit;

proc sql noprint;
    select min(deal_p10) into :deal_floor from inter.deal_curve;
    select min(date) format=8. into :deal_date trimmed
    from inter.deal_curve where deal_p10 <= &deal_floor + 0.005;
    select deal_p10 format=4.2, deal_p50 format=4.2
        into :deal_best trimmed, :deal_typ trimmed
    from inter.deal_curve where date = &deal_date;
    select avg_p50 format=4.2 into :deal_avg trimmed
    from inter.deal_curve having date = max(date);
    select deal_p10 format=4.2, deal_p50 format=4.2, avg_p50 format=4.2
        into :deal_early trimmed, :deal_typ_early trimmed, :deal_avg_early trimmed
    from inter.deal_curve having date = min(date);
    select round(100 * max(share_low_under_50c)) into :deal_share_max trimmed from tk.spread_profile;
quit;

data _null_;
    call symputx('deal_txt', catx(' ', put(&deal_date, monname3.), day(&deal_date)));
    call symputx('deal_days', &tday - &deal_date);
run;

data inter.card_deal;
    set inter.deal_curve;
    length best_label typ_label avg_label $40;
    if date = &deal_date then do;
        best_mark = deal_p10;
        best_label = "Best deals from &deal_txt: $&deal_best/lb";
    end;
    if dtt = 5 then do;
        typ_mark = deal_p50;
        typ_label = cats('Typical cheapest ad: $', put(deal_p50, 4.2));
        avg_mark = avg_p50;
        avg_label = cats('Average price: $', put(avg_p50, 4.2));
    end;
run;

ods listing gpath="&out/social";

ods graphics on / reset=all width=1200px height=627px imagefmt=png
    imagename="turkey_deals_linkedin_1200x627" noborder;
proc sgplot data=inter.card_deal noautolegend pad=28px;
    styleattrs backcolor=&paper wallcolor=&paper;
    title1 j=l height=11pt bold color=&accent 'THE ECONOMICS OF THANKSGIVING';
    title2 j=l height=20pt bold color=&ink "The best turkey deals arrive &deal_days days before Thanksgiving.";
    title3 j=l height=11pt color=&muted "The best cheapest-ad prices fall from $&deal_early/lb in mid-October to $&deal_best/lb by &deal_txt, and stay there.";
    title4 j=l height=11pt color=&muted "The average advertised price only moves from $&deal_avg_early to $&deal_avg..";
    band x=date lower=deal_p10 upper=deal_p90 / fillattrs=(color=&band) transparency=0.45
        legendlabel='Cheapest ad in a region, 10th-90th percentile' name='band';
    series x=date y=avg_p50 / lineattrs=(color=gray pattern=shortdash thickness=2)
        legendlabel='Regional average price' name='avg';
    series x=date y=deal_p50 / lineattrs=(color=&navy thickness=3)
        legendlabel='Typical cheapest ad' name='typ';
    series x=date y=deal_p10 / lineattrs=(color=&accent thickness=4)
        legendlabel='Best deals (10th percentile)' name='best';
    scatter x=date y=best_mark / markerattrs=(symbol=circlefilled color=&accent size=13)
        datalabel=best_label datalabelattrs=(color=&ink size=11 weight=bold) datalabelpos=bottom;
    scatter x=date y=typ_mark / markerattrs=(size=0)
        datalabel=typ_label datalabelattrs=(color=&navy size=10 weight=bold) datalabelpos=topleft;
    scatter x=date y=avg_mark / markerattrs=(size=0)
        datalabel=avg_label datalabelattrs=(color=&muted size=10 weight=bold) datalabelpos=topleft;
    xaxis type=time display=(nolabel) min="12OCT&forecast_year"d max=&tday
        values=("17OCT&forecast_year"d "31OCT&forecast_year"d "14NOV&forecast_year"d &tday)
        valuesformat=mmddyy5. valueattrs=(color=&muted size=10) valueshint;
    yaxis display=(nolabel) valuesformat=dollar6.2 min=0 max=1.50 values=(0 to 1.5 by 0.25)
        grid gridattrs=(color=cxE6E3DD) valueattrs=(color=&muted size=10) valueshint;
    keylegend 'best' 'typ' 'band' 'avg' / location=outside position=bottom across=4 noborder;
    footnote1 j=l height=8pt color=gray "Cheapest ad = lowest advertised price USDA found in a region that week, frozen whole turkeys, per lb. Some require an additional purchase.";
    footnote2 j=l height=8pt color=gray "Percentiles across six US regions and seasons 2015-&forecast_year (PROC QUANTREG). Data: USDA Agricultural Marketing Service.";
    footnote3 j=r height=9pt bold color=&ink "Analysis: Jenner Analytics";
run;
title;
footnote;

data inter.card_share;
    set tk.spread_profile;
    length week $20 share_label $8;
    if wtt = 0 then week = 'Thanksgiving week';
    else if wtt = 1 then week = '1 week before';
    else week = catx(' ', wtt, 'weeks before');
    share = share_low_under_50c;
    share_label = cats(round(100 * share), '%');
    order = -wtt;
    keep wtt order week share share_label avg_low;
run;

proc sort data=inter.card_share; by order; run;

ods graphics on / reset=all width=1080px height=1080px imagefmt=png
    imagename="turkey_deals_by_week_1080x1080" noborder;
proc sgplot data=inter.card_share noautolegend pad=28px;
    styleattrs backcolor=&paper wallcolor=&paper;
    title1 j=l height=13pt bold color=&accent 'WHEN THE DEALS SHOW UP';
    title2 j=l height=25pt bold color=&ink '50-cent-a-pound turkey ads go';
    title3 j=l height=25pt bold color=&ink 'from rare to nearly universal.';
    title4 j=l height=12pt color=&muted 'Share of US regions with a frozen whole turkey advertised';
    title5 j=l height=12pt color=&muted "at $0.50/lb or less, by ad week, 2015-&forecast_year..";
    vbarparm category=week response=share / datalabel=share_label
        datalabelattrs=(size=15 weight=bold color=&ink) fillattrs=(color=&accent) barwidth=0.7 nooutline;
    xaxis display=(nolabel) discreteorder=data valueattrs=(color=&muted size=11) fitpolicy=split;
    yaxis display=(nolabel) valuesformat=percent8.0 min=0 max=1 values=(0 to 1 by 0.25)
        grid gridattrs=(color=cxE6E3DD) valueattrs=(color=&muted size=13);
    footnote1 j=l height=9pt color=gray "A region counts when its lowest advertised price that week is $0.50/lb or less.";
    footnote2 j=l height=9pt color=gray "Some of these prices require an additional purchase. Six contiguous regions.";
    footnote3 j=l height=9pt color=gray "Data: USDA Agricultural Marketing Service, Weekly Grocery Store Turkey Feature Activity.";
    footnote4 j=r height=10pt bold color=&ink "Analysis: Jenner Analytics";
run;
title;
footnote;

ods graphics on / reset=all width=1200px height=627px imagefmt=png
    imagename="turkey_deals_map_1200x627" noborder;
proc sgmap mapdata=inter.county_map maprespdata=inter.county_resp
    plotdata=inter.region_labels;
    title1 j=l height=11pt bold color=&accent 'THE ECONOMICS OF THANKSGIVING';
    title2 j=l height=20pt bold color=&ink 'Where the cheapest turkey ads are this week';
    title3 j=l height=11pt color=&muted "Lowest advertised price for a frozen whole turkey, per lb, ad week &map_week_txt..";
    choromap lowest_price / mapid=fips colormodel=(cx2B3A55 cx7FA6C9 cxF2D9A6 cxD9A066 cx8C4A2F)
        lineattrs=(thickness=0) name='map';
    text x=lx y=ly text=low_label / textattrs=(size=10pt weight=bold color=black)
        backfill fillattrs=(color=white transparency=0.25);
    gradlegend 'map' / title='US$ per lb';
    footnote1 j=l height=8pt color=gray "USDA reports eight regions, so every county in a region has the same value. Some of these prices require an additional purchase.";
    footnote2 j=l height=8pt color=gray "Data: USDA Agricultural Marketing Service, Weekly Grocery Store Turkey Feature Activity. Analysis: Jenner Analytics.";
run;
title;
footnote;

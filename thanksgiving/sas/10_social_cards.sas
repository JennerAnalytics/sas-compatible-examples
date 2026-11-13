%let ink = cx1F2433;
%let muted = cx5B6170;
%let paper = cxFBF7F1;
%let accent = cxA4502A;
%let band = cxE8C39E;
%let navy = cx2B3A55;
%let bird_lb = 16;

proc sql noprint;
    select best_date format=8., compare_date format=8., best_price format=6.2, compare_price format=6.2,
           saving_16lb_bird format=6.2
        into :best_date trimmed, :eve_date trimmed, :best_p trimmed, :eve_p trimmed, :bird_saving trimmed
    from tk.savings
    having compare_date = max(compare_date);
    select round(100 * p_now_beats_last_minute) into :p_now trimmed from tk.wait_odds;
    select wtd_avg_price format=6.2, report_begin_date format=8., report_end_date format=8.
        into :lw_price trimmed, :lw_start trimmed, :lw_end trimmed
    from inter.ad_weeks
    having report_begin_date = max(report_begin_date);
    select year, round(-100 * margin_pct) into :ll_year trimmed, :ll_pct trimmed
    from tk.loss_leader
    where margin_pct < -0.2
    having year = max(year);
    select count(distinct year), strip(put(&n_sims, comma10.))
        into :n_seasons trimmed, :sims_txt trimmed
    from tk.model_weekly;
    select catx(' ', put(best_date, monname3.), day(best_date)),
           catx(' ', put(compare_date, monname3.), day(compare_date)),
           catx(' ', cats(put(best_date, downame.), ','), put(best_date, monname3.), day(best_date)),
           catx(' ', cats(put(compare_date, downame.), ','), put(compare_date, monname3.), day(compare_date))
        into :best_txt trimmed, :eve_txt trimmed, :best_long trimmed, :eve_long trimmed
    from tk.savings
    having compare_date = max(compare_date);
    select catx(' ', put(report_begin_date, monname3.), day(report_begin_date), 'to',
                put(report_end_date, monname3.), day(report_end_date))
        into :lw_txt trimmed
    from inter.ad_weeks
    having report_begin_date = max(report_begin_date);
quit;

ods listing gpath="&out/social";

data inter.card_fc;
    set inter.plot;
    if date = &eve_date then do;
        eve_price = predicted_price;
        eve_label = catx(' ', "&eve_txt:", cats('$', put(predicted_price, 4.2), '/lb'));
    end;
    if date = &best_date then best_label = catx(' ', "&best_txt:", cats('$', put(predicted_price, 4.2), '/lb'));
run;

ods graphics on / reset=all width=1200px height=627px imagefmt=png
    imagename="turkey_linkedin_1200x627" noborder;
proc sgplot data=inter.card_fc noautolegend;
    styleattrs backcolor=&paper wallcolor=&paper;
    title1 j=l height=11pt bold color=&accent 'THE ECONOMICS OF THANKSGIVING';
    title2 j=l height=20pt bold color=&ink "Don't wait for Thanksgiving week to buy your turkey.";
    title3 j=l height=11pt color=&muted "Latest USDA ad week (&lw_txt): $&lw_price/lb for frozen whole turkeys.";
    title4 j=l height=11pt color=&muted "Expected low: $&best_p around &best_txt, then $&eve_p by &eve_txt..";
    band x=date lower=fc_lo upper=fc_hi / fillattrs=(color=&band) transparency=0.45
        legendlabel='95% prediction band' name='band';
    series x=date y=fit_price / lineattrs=(color=gray pattern=shortdash thickness=1.5);
    series x=date y=fc_price / lineattrs=(color=&accent thickness=3.5) legendlabel='Forecast' name='fc';
    vector x=report_end_date y=week_price / xorigin=seg_start yorigin=week_price
        noarrowheads lineattrs=(color=&navy thickness=4) legendlabel='Weekly advertised average (USDA)' name='obs';
    scatter x=date y=best_price / markerattrs=(symbol=circlefilled color=&accent size=13)
        datalabel=best_label datalabelattrs=(color=&ink size=11 weight=bold) datalabelpos=bottom;
    scatter x=date y=eve_price / markerattrs=(symbol=circlefilled color=&accent size=11)
        datalabel=eve_label datalabelattrs=(color=&ink size=11 weight=bold) datalabelpos=topleft;
    refline &cutoff / axis=x lineattrs=(pattern=dash color=gray) label='forecast starts' labelloc=inside labelpos=max;
    xaxis type=time display=(nolabel) values=("17OCT&forecast_year"d "31OCT&forecast_year"d "14NOV&forecast_year"d "26NOV&forecast_year"d)
        valuesdisplay=('Oct 17' 'Oct 31' 'Nov 14' 'Nov 26') valueattrs=(color=&muted size=10);
    yaxis display=(nolabel) valuesformat=dollar6.2 min=0.90 max=1.65 grid gridattrs=(color=cxE6E3DD)
        valueattrs=(color=&muted size=10);
    keylegend 'obs' 'fc' 'band' / location=outside position=bottom across=3 noborder;
    footnote1 j=l height=8pt color=gray "Advertised prices, not checkout prices. Ads run weekly, so daily values are modelled. Data: USDA Agricultural Marketing Service.";
    footnote2 j=r height=9pt bold color=&ink "Forecast: Jenner Analytics";
run;
title;
footnote;

data inter.card_profile;
    do until (eof);
        set tk.season_profile(where=(dtt <= 40)) end=eof;
        if relative_price < prof_low or prof_low = . then do; prof_low = relative_price; low_dtt = dtt; end;
        if dtt > 14 and (relative_price > prof_peak or prof_peak = .) then do; prof_peak = relative_price; peak_dtt = dtt; end;
    end;
    do until (eof2);
        set tk.season_profile(where=(dtt <= 40)) end=eof2;
        length note $40;
        rel = relative_price / prof_low;
        base = 0.97;
        mark = .;
        note = '';
        if dtt = peak_dtt then do; mark = rel; note = cats('Late October: +', put(100 * (rel - 1), 2.), '%'); end;
        if dtt = low_dtt then do; mark = rel; note = 'The low: mid-November'; end;
        if dtt = 0 then do; mark = rel; note = cats('Thanksgiving: +', put(100 * (rel - 1), 2.), '%'); end;
        output;
    end;
    stop;
    keep dtt date rel base mark note;
run;

ods graphics on / reset=all width=1080px height=1080px imagefmt=png
    imagename="turkey_season_curve_1080x1080" noborder;
proc sgplot data=inter.card_profile noautolegend;
    styleattrs backcolor=&paper wallcolor=&paper;
    title1 j=l height=13pt bold color=&accent 'MYTH VS. DATA';
    title2 j=l height=27pt bold color=&ink 'The best turkey deals come';
    title3 j=l height=27pt bold color=&ink 'before Thanksgiving week.';
    title4 j=l height=13pt color=&muted "&n_seasons seasons of USDA supermarket ad prices (2005-&forecast_year):";
    title5 j=l height=13pt color=&muted 'the typical season for frozen whole turkeys, relative to its low.';
    band x=date lower=base upper=rel / fillattrs=(color=&band) transparency=0.5;
    series x=date y=rel / lineattrs=(color=&accent thickness=5);
    scatter x=date y=mark / markerattrs=(symbol=circlefilled color=&accent size=16)
        datalabel=note datalabelattrs=(color=&ink size=15 weight=bold) datalabelpos=top;
    xaxis type=time display=(nolabel) values=("17OCT&forecast_year"d "31OCT&forecast_year"d "14NOV&forecast_year"d "26NOV&forecast_year"d)
        valuesdisplay=('Oct 17' 'Oct 31' 'Nov 14' 'Nov 26') valueattrs=(color=&muted size=13)
        offsetmin=0.04 offsetmax=0.12;
    yaxis display=(nolabel) min=0.97 max=1.16 values=(1 1.05 1.10) valuesdisplay=('low' '+5%' '+10%')
        grid gridattrs=(color=cxE6E3DD) valueattrs=(color=&muted size=13);
    footnote1 j=l height=9pt color=gray "Fitted seasonal pattern; October values rest on fewer ads. Data: USDA Agricultural Marketing Service,";
    footnote2 j=l height=9pt color=gray "national average advertised supermarket price, conventional frozen whole turkeys, per lb.";
    footnote3 j=r height=10pt bold color=&ink "Forecast: Jenner Analytics";
run;
title;
footnote;

data inter.card_ll;
    set tk.loss_leader;
    length series $24;
    length price_label $8;
    series = 'Wholesale (frozen hens)'; price = wholesale_price; price_label = cats('$', put(price, 4.2)); output;
    series = 'Supermarket ad price'; price = retail_ad_price; price_label = cats('$', put(price, 4.2)); output;
    format price dollar6.2;
    keep year series price price_label;
run;

ods graphics on / reset=all width=1080px height=1080px imagefmt=png
    imagename="turkey_loss_leader_1080x1080" noborder;
proc sgplot data=inter.card_ll;
    styleattrs backcolor=&paper wallcolor=&paper datacolors=(&navy &accent);
    title1 j=l height=13pt bold color=&accent 'THE LOSS LEADER';
    title2 j=l height=24pt bold color=&ink "In &ll_year, supermarkets advertised";
    title3 j=l height=24pt bold color=&ink "turkeys &ll_pct% below wholesale.";
    title4 j=l height=12pt color=&muted 'Frozen whole turkey, $ per lb, three ad weeks through Thanksgiving.';
    title5 j=l height=12pt color=&muted 'Wholesale nearly doubled and halved; the ad price barely moved.';
    vbarparm category=year response=price / group=series groupdisplay=cluster datalabel=price_label
        datalabelattrs=(size=13 weight=bold) barwidth=0.7 nooutline;
    xaxis display=(nolabel) valueattrs=(color=&muted size=14);
    yaxis display=(nolabel) valuesformat=dollar6.2 min=0 max=2 grid gridattrs=(color=cxE6E3DD)
        valueattrs=(color=&muted size=13);
    keylegend / location=outside position=bottom noborder title='' valueattrs=(size=13);
    footnote1 j=l height=9pt color=gray "Wholesale: USDA Weekly National Turkey Report, frozen hens 8-16 lb, FOB, week before each ad week.";
    footnote2 j=l height=9pt color=gray "Retail: USDA Weekly Grocery Store Turkey Feature Activity, store-weighted national average.";
    footnote3 j=r height=10pt bold color=&ink "Analysis: Jenner Analytics";
run;
title;
footnote;

data inter.card_wait;
    length big $12 line $90;
    x = 0;
    y = 78; big = "$&bird_saving"; output;
    y = 38; big = "&p_now%"; output;
    big = '';
    y = 63; line = "extra on a &bird_lb-lb frozen turkey, on average: the expected advertised"; output;
    y = 58; line = "price on &eve_long versus &best_long.."; output;
    y = 23; line = "chance that this week's advertised price beats Thanksgiving week's"; output;
    y = 18; line = "(&sims_txt simulated price paths)."; output;
    y = 7; line = 'Ad prices drift down through early November, bottom out about two'; output;
    y = 2; line = 'weeks before the holiday, and rise again in Thanksgiving week.'; output;
run;

ods graphics on / reset=all width=1080px height=1350px imagefmt=png
    imagename="turkey_cost_of_waiting_1080x1350" noborder;
proc sgplot data=inter.card_wait noautolegend noborder;
    styleattrs backcolor=&paper wallcolor=&paper;
    title1 j=l height=13pt bold color=&accent 'WHEN SHOULD YOU BUY A TURKEY?';
    title2 j=l height=26pt bold color=&ink 'Waiting until the last minute';
    title3 j=l height=26pt bold color=&ink 'costs you about';
    text x=x y=y text=big / position=right textattrs=(color=&accent size=90 weight=bold);
    text x=x y=y text=line / position=right textattrs=(color=&ink size=16);
    xaxis display=none min=0 max=100 offsetmin=0.01;
    yaxis display=none min=0 max=90;
    footnote1 j=l height=9pt color=gray "Data: USDA Agricultural Marketing Service; national average advertised supermarket price,";
    footnote2 j=l height=9pt color=gray "conventional frozen whole turkeys, per lb. Forecast cutoff &cutoff_txt..";
    footnote3 j=r height=10pt bold color=&ink "Forecast: Jenner Analytics";
run;
title;
footnote;

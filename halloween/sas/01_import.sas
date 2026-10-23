proc import datafile="&raw/usda_ams_fvwretail_pumpkins_by_region.csv"
    out=inter.retail_raw dbms=csv replace;
    guessingrows=max;
run;

proc import datafile="&raw/usda_ams_terminal_pumpkins_daily.csv"
    out=inter.wholesale_raw dbms=csv replace;
    guessingrows=max;
run;

proc import datafile="&raw/usda_nass_pumpkins_national_annual.csv"
    out=inter.nass_raw dbms=csv replace;
    guessingrows=max;
run;

proc import datafile="&raw/google_trends_pumpkin_daily_by_season.csv"
    out=inter.trends_raw dbms=csv replace;
    guessingrows=max;
run;

proc contents data=inter.retail_raw varnum; run;
proc contents data=inter.wholesale_raw varnum; run;
proc contents data=inter.nass_raw varnum; run;
proc contents data=inter.trends_raw varnum; run;

%put NOTE: Step 01: import the USDA source files.;

proc import datafile="&raw/usda_ams_turkey_whole_national.csv"
    out=inter.retail_raw dbms=csv replace;
    guessingrows=max;
run;

proc import datafile="&raw/usda_ams_turkey_frozen_by_region.csv"
    out=inter.regional_raw dbms=csv replace;
    guessingrows=max;
run;

proc import datafile="&raw/usda_ams_turkey_wholesale_frozen_hens.csv"
    out=inter.wholesale_raw dbms=csv replace;
    guessingrows=max;
run;

proc contents data=inter.retail_raw varnum; run;
proc contents data=inter.regional_raw varnum; run;
proc contents data=inter.wholesale_raw varnum; run;

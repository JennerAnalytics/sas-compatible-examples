%let root = %sysget(TURKEY_ROOT);
%let raw  = &root/data/raw;
%let proc = &root/data/processed;
%let out  = &root/output;

%let forecast_year = 2026;
%let cutoff = '12NOV2026'd;
%let min_stores = 500;
%let max_dtt = 47;
%let seed = 20261126;
%let bt_first = 2012;
%let bt_last = 2025;

libname inter "&root/data/intermediate";
libname tk "&root/data/processed";

%include "&root/sas/macros.sas";

%let final_model = A3;
%let n_sims = 20000;

data _null_;
    call symputx('cutoff_txt', put(&cutoff, worddate18.));
    call symputx('tday', nwkdom(4, 5, 11, &forecast_year));
    call symputx('tday_txt', put(nwkdom(4, 5, 11, &forecast_year), worddate18.));
run;

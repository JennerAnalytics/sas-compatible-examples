%let root = %sysget(PUMPKIN_ROOT);
%let raw  = &root/data/raw;
%let proc = &root/data/processed;
%let out  = &root/output;

%let forecast_year = 2026;
%let cutoff = '23OCT2026'd;
%let min_stores = 100;
%let seed = 20261031;

libname inter "&root/data/intermediate";
libname pk "&root/data/processed";

%include "&root/sas/macros.sas";

%let final_model = A3;
%let n_sims = 20000;

data _null_;
    call symputx('cutoff_txt', put(&cutoff, worddate18.));
run;

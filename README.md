# SAS-Compatible Examples (Jenner)

🌐 [Čeština](translations/cs/README.md) · [Dansk](translations/da/README.md) · [Deutsch](translations/de/README.md) · [Ελληνικά](translations/el/README.md) · [Español](translations/es/README.md) · [Suomi](translations/fi/README.md) · [Français](translations/fr/README.md) · [Italiano](translations/it/README.md) · [日本語](translations/ja/README.md) · [한국어](translations/ko/README.md) · [Nederlands](translations/nl/README.md) · [Polski](translations/pl/README.md) · [Português](translations/pt/README.md) · [Svenska](translations/sv/README.md) · [中文](translations/zh/README.md)

A curated, **validated** collection of analytical example notebooks that run on
[Jenner](https://jenneranalytics.com) — a SAS-compatible DATA step and PROC engine.

Every notebook here has been **content-reviewed for truthfulness**, not merely
checked that it executes:

- It runs cleanly through the Jenner Jupyter kernel, and **the executed outputs
  (tables and plots) are embedded** — read the results directly on GitHub without
  downloading or re-running anything.
- Every number and conclusion in the narrative is **grounded in the notebook's real
  output** — no pre-written or fabricated findings.
- Each generated image has been **visually reviewed**.
- The advertised SAS procedure is the one actually executed.

Notebooks that could not meet this bar were excluded rather than published. This is a
deliberately small, high-trust set; it grows as more examples pass review.

## Layout

- `procs/<proc>/<slug>/notebook.ipynb` — examples organized by SAS procedure.
- `<industry>/<slug>/` — examples organized by domain.

## Running an example

```bash
jenner jupyter install
jupyter lab
```

Select the **Jenner** kernel and Run All. Because outputs are already embedded, you can
also just read each notebook as-is.

## Program languages

Jenner programs can be written in **26 natural languages** — `DATA`, `DONNÉES`,
`データ`, `数据`, and `DATOS` all parse identically, and the engine auto-detects
the language of a script. Translated versions of these notebooks (markdown
narrative *and* code keywords) live under [`translations/`](translations/), one
tree per language, so you can read an analysis end-to-end in your own language.

To convert any program or notebook between languages — in either direction —
use [`tools/translate.py`](tools/README.md).

<!-- BEGIN EXAMPLE INDEX -->

## Example directory

Every example below is a validated, content-reviewed notebook. The 🌐 column links to available translations (markdown narrative + code) under [`translations/`](translations/).

### By SAS procedure (168 examples)

**ACECLUS**

- [Finance Market Regime Identification](procs/aceclus/finance_market_regime_identification/notebook.ipynb) — 🌐 [cs](translations/cs/procs/aceclus/finance_market_regime_identification/notebook.ipynb) · [da](translations/da/procs/aceclus/finance_market_regime_identification/notebook.ipynb) · [de](translations/de/procs/aceclus/finance_market_regime_identification/notebook.ipynb) · [el](translations/el/procs/aceclus/finance_market_regime_identification/notebook.ipynb) · [es](translations/es/procs/aceclus/finance_market_regime_identification/notebook.ipynb) · [fi](translations/fi/procs/aceclus/finance_market_regime_identification/notebook.ipynb) · [fr](translations/fr/procs/aceclus/finance_market_regime_identification/notebook.ipynb) · [it](translations/it/procs/aceclus/finance_market_regime_identification/notebook.ipynb) · [ja](translations/ja/procs/aceclus/finance_market_regime_identification/notebook.ipynb) · [ko](translations/ko/procs/aceclus/finance_market_regime_identification/notebook.ipynb) · [nl](translations/nl/procs/aceclus/finance_market_regime_identification/notebook.ipynb) · [pl](translations/pl/procs/aceclus/finance_market_regime_identification/notebook.ipynb) · [pt](translations/pt/procs/aceclus/finance_market_regime_identification/notebook.ipynb) · [sv](translations/sv/procs/aceclus/finance_market_regime_identification/notebook.ipynb) · [zh](translations/zh/procs/aceclus/finance_market_regime_identification/notebook.ipynb)

**ADAPTIVEREG**

- [Modeling Nonlinear Credit Default Risk with Regression Splines](procs/adaptivereg/nonlinear_credit_risk_splines/notebook.ipynb) — 🌐 [cs](translations/cs/procs/adaptivereg/nonlinear_credit_risk_splines/notebook.ipynb) · [da](translations/da/procs/adaptivereg/nonlinear_credit_risk_splines/notebook.ipynb) · [de](translations/de/procs/adaptivereg/nonlinear_credit_risk_splines/notebook.ipynb) · [el](translations/el/procs/adaptivereg/nonlinear_credit_risk_splines/notebook.ipynb) · [es](translations/es/procs/adaptivereg/nonlinear_credit_risk_splines/notebook.ipynb) · [fi](translations/fi/procs/adaptivereg/nonlinear_credit_risk_splines/notebook.ipynb) · [fr](translations/fr/procs/adaptivereg/nonlinear_credit_risk_splines/notebook.ipynb) · [it](translations/it/procs/adaptivereg/nonlinear_credit_risk_splines/notebook.ipynb) · [ja](translations/ja/procs/adaptivereg/nonlinear_credit_risk_splines/notebook.ipynb) · [ko](translations/ko/procs/adaptivereg/nonlinear_credit_risk_splines/notebook.ipynb) · [nl](translations/nl/procs/adaptivereg/nonlinear_credit_risk_splines/notebook.ipynb) · [pl](translations/pl/procs/adaptivereg/nonlinear_credit_risk_splines/notebook.ipynb) · [pt](translations/pt/procs/adaptivereg/nonlinear_credit_risk_splines/notebook.ipynb) · [sv](translations/sv/procs/adaptivereg/nonlinear_credit_risk_splines/notebook.ipynb) · [zh](translations/zh/procs/adaptivereg/nonlinear_credit_risk_splines/notebook.ipynb)

**ANOM**

- [Education School Test Scores](procs/anom/education_school_test_scores/notebook.ipynb) — 🌐 [cs](translations/cs/procs/anom/education_school_test_scores/notebook.ipynb) · [da](translations/da/procs/anom/education_school_test_scores/notebook.ipynb) · [de](translations/de/procs/anom/education_school_test_scores/notebook.ipynb) · [el](translations/el/procs/anom/education_school_test_scores/notebook.ipynb) · [es](translations/es/procs/anom/education_school_test_scores/notebook.ipynb) · [fi](translations/fi/procs/anom/education_school_test_scores/notebook.ipynb) · [fr](translations/fr/procs/anom/education_school_test_scores/notebook.ipynb) · [it](translations/it/procs/anom/education_school_test_scores/notebook.ipynb) · [ja](translations/ja/procs/anom/education_school_test_scores/notebook.ipynb) · [ko](translations/ko/procs/anom/education_school_test_scores/notebook.ipynb) · [nl](translations/nl/procs/anom/education_school_test_scores/notebook.ipynb) · [pl](translations/pl/procs/anom/education_school_test_scores/notebook.ipynb) · [pt](translations/pt/procs/anom/education_school_test_scores/notebook.ipynb) · [sv](translations/sv/procs/anom/education_school_test_scores/notebook.ipynb) · [zh](translations/zh/procs/anom/education_school_test_scores/notebook.ipynb)

**ANOVA**

- [Retail Packaging Preference Test](procs/anova/retail_packaging_preference_test/notebook.ipynb) — 🌐 [cs](translations/cs/procs/anova/retail_packaging_preference_test/notebook.ipynb) · [da](translations/da/procs/anova/retail_packaging_preference_test/notebook.ipynb) · [de](translations/de/procs/anova/retail_packaging_preference_test/notebook.ipynb) · [el](translations/el/procs/anova/retail_packaging_preference_test/notebook.ipynb) · [es](translations/es/procs/anova/retail_packaging_preference_test/notebook.ipynb) · [fi](translations/fi/procs/anova/retail_packaging_preference_test/notebook.ipynb) · [fr](translations/fr/procs/anova/retail_packaging_preference_test/notebook.ipynb) · [it](translations/it/procs/anova/retail_packaging_preference_test/notebook.ipynb) · [ja](translations/ja/procs/anova/retail_packaging_preference_test/notebook.ipynb) · [ko](translations/ko/procs/anova/retail_packaging_preference_test/notebook.ipynb) · [nl](translations/nl/procs/anova/retail_packaging_preference_test/notebook.ipynb) · [pl](translations/pl/procs/anova/retail_packaging_preference_test/notebook.ipynb) · [pt](translations/pt/procs/anova/retail_packaging_preference_test/notebook.ipynb) · [sv](translations/sv/procs/anova/retail_packaging_preference_test/notebook.ipynb) · [zh](translations/zh/procs/anova/retail_packaging_preference_test/notebook.ipynb)

**ARIMA**

- [Pharma Drug Demand Forecasting](procs/arima/pharma_drug_demand_forecasting/notebook.ipynb) — 🌐 [cs](translations/cs/procs/arima/pharma_drug_demand_forecasting/notebook.ipynb) · [da](translations/da/procs/arima/pharma_drug_demand_forecasting/notebook.ipynb) · [de](translations/de/procs/arima/pharma_drug_demand_forecasting/notebook.ipynb) · [el](translations/el/procs/arima/pharma_drug_demand_forecasting/notebook.ipynb) · [es](translations/es/procs/arima/pharma_drug_demand_forecasting/notebook.ipynb) · [fi](translations/fi/procs/arima/pharma_drug_demand_forecasting/notebook.ipynb) · [fr](translations/fr/procs/arima/pharma_drug_demand_forecasting/notebook.ipynb) · [it](translations/it/procs/arima/pharma_drug_demand_forecasting/notebook.ipynb) · [ja](translations/ja/procs/arima/pharma_drug_demand_forecasting/notebook.ipynb) · [ko](translations/ko/procs/arima/pharma_drug_demand_forecasting/notebook.ipynb) · [nl](translations/nl/procs/arima/pharma_drug_demand_forecasting/notebook.ipynb) · [pl](translations/pl/procs/arima/pharma_drug_demand_forecasting/notebook.ipynb) · [pt](translations/pt/procs/arima/pharma_drug_demand_forecasting/notebook.ipynb) · [sv](translations/sv/procs/arima/pharma_drug_demand_forecasting/notebook.ipynb) · [zh](translations/zh/procs/arima/pharma_drug_demand_forecasting/notebook.ipynb)

**AUTOREG**

- [Pharma Sales Rep Effectiveness](procs/autoreg/pharma_sales_rep_effectiveness/notebook.ipynb) — 🌐 [cs](translations/cs/procs/autoreg/pharma_sales_rep_effectiveness/notebook.ipynb) · [da](translations/da/procs/autoreg/pharma_sales_rep_effectiveness/notebook.ipynb) · [de](translations/de/procs/autoreg/pharma_sales_rep_effectiveness/notebook.ipynb) · [el](translations/el/procs/autoreg/pharma_sales_rep_effectiveness/notebook.ipynb) · [es](translations/es/procs/autoreg/pharma_sales_rep_effectiveness/notebook.ipynb) · [fi](translations/fi/procs/autoreg/pharma_sales_rep_effectiveness/notebook.ipynb) · [fr](translations/fr/procs/autoreg/pharma_sales_rep_effectiveness/notebook.ipynb) · [it](translations/it/procs/autoreg/pharma_sales_rep_effectiveness/notebook.ipynb) · [ja](translations/ja/procs/autoreg/pharma_sales_rep_effectiveness/notebook.ipynb) · [ko](translations/ko/procs/autoreg/pharma_sales_rep_effectiveness/notebook.ipynb) · [nl](translations/nl/procs/autoreg/pharma_sales_rep_effectiveness/notebook.ipynb) · [pl](translations/pl/procs/autoreg/pharma_sales_rep_effectiveness/notebook.ipynb) · [pt](translations/pt/procs/autoreg/pharma_sales_rep_effectiveness/notebook.ipynb) · [sv](translations/sv/procs/autoreg/pharma_sales_rep_effectiveness/notebook.ipynb) · [zh](translations/zh/procs/autoreg/pharma_sales_rep_effectiveness/notebook.ipynb)

**BOX**

- [Visualizing Emergency Department Length of Stay with PROC BOX](procs/box/ed_length_of_stay_boxplots/notebook.ipynb) — 🌐 [cs](translations/cs/procs/box/ed_length_of_stay_boxplots/notebook.ipynb) · [da](translations/da/procs/box/ed_length_of_stay_boxplots/notebook.ipynb) · [de](translations/de/procs/box/ed_length_of_stay_boxplots/notebook.ipynb) · [el](translations/el/procs/box/ed_length_of_stay_boxplots/notebook.ipynb) · [es](translations/es/procs/box/ed_length_of_stay_boxplots/notebook.ipynb) · [fi](translations/fi/procs/box/ed_length_of_stay_boxplots/notebook.ipynb) · [fr](translations/fr/procs/box/ed_length_of_stay_boxplots/notebook.ipynb) · [it](translations/it/procs/box/ed_length_of_stay_boxplots/notebook.ipynb) · [ja](translations/ja/procs/box/ed_length_of_stay_boxplots/notebook.ipynb) · [ko](translations/ko/procs/box/ed_length_of_stay_boxplots/notebook.ipynb) · [nl](translations/nl/procs/box/ed_length_of_stay_boxplots/notebook.ipynb) · [pl](translations/pl/procs/box/ed_length_of_stay_boxplots/notebook.ipynb) · [pt](translations/pt/procs/box/ed_length_of_stay_boxplots/notebook.ipynb) · [sv](translations/sv/procs/box/ed_length_of_stay_boxplots/notebook.ipynb) · [zh](translations/zh/procs/box/ed_length_of_stay_boxplots/notebook.ipynb)

**BOXPLOT**

- [Statistical Process Control of Coating Thickness Across Production Lines with PROC BOXPLOT](procs/boxplot/spc_box_whisker_process_control/notebook.ipynb) — 🌐 [cs](translations/cs/procs/boxplot/spc_box_whisker_process_control/notebook.ipynb) · [da](translations/da/procs/boxplot/spc_box_whisker_process_control/notebook.ipynb) · [de](translations/de/procs/boxplot/spc_box_whisker_process_control/notebook.ipynb) · [el](translations/el/procs/boxplot/spc_box_whisker_process_control/notebook.ipynb) · [es](translations/es/procs/boxplot/spc_box_whisker_process_control/notebook.ipynb) · [fi](translations/fi/procs/boxplot/spc_box_whisker_process_control/notebook.ipynb) · [fr](translations/fr/procs/boxplot/spc_box_whisker_process_control/notebook.ipynb) · [it](translations/it/procs/boxplot/spc_box_whisker_process_control/notebook.ipynb) · [ja](translations/ja/procs/boxplot/spc_box_whisker_process_control/notebook.ipynb) · [ko](translations/ko/procs/boxplot/spc_box_whisker_process_control/notebook.ipynb) · [nl](translations/nl/procs/boxplot/spc_box_whisker_process_control/notebook.ipynb) · [pl](translations/pl/procs/boxplot/spc_box_whisker_process_control/notebook.ipynb) · [pt](translations/pt/procs/boxplot/spc_box_whisker_process_control/notebook.ipynb) · [sv](translations/sv/procs/boxplot/spc_box_whisker_process_control/notebook.ipynb) · [zh](translations/zh/procs/boxplot/spc_box_whisker_process_control/notebook.ipynb)

**CALIS**

- [Modeling Customer Satisfaction and Loyalty with a Structural Equation Model (PROC CALIS)](procs/calis/customer_satisfaction_loyalty_sem/notebook.ipynb) — 🌐 [cs](translations/cs/procs/calis/customer_satisfaction_loyalty_sem/notebook.ipynb) · [da](translations/da/procs/calis/customer_satisfaction_loyalty_sem/notebook.ipynb) · [de](translations/de/procs/calis/customer_satisfaction_loyalty_sem/notebook.ipynb) · [el](translations/el/procs/calis/customer_satisfaction_loyalty_sem/notebook.ipynb) · [es](translations/es/procs/calis/customer_satisfaction_loyalty_sem/notebook.ipynb) · [fi](translations/fi/procs/calis/customer_satisfaction_loyalty_sem/notebook.ipynb) · [fr](translations/fr/procs/calis/customer_satisfaction_loyalty_sem/notebook.ipynb) · [it](translations/it/procs/calis/customer_satisfaction_loyalty_sem/notebook.ipynb) · [ja](translations/ja/procs/calis/customer_satisfaction_loyalty_sem/notebook.ipynb) · [ko](translations/ko/procs/calis/customer_satisfaction_loyalty_sem/notebook.ipynb) · [nl](translations/nl/procs/calis/customer_satisfaction_loyalty_sem/notebook.ipynb) · [pl](translations/pl/procs/calis/customer_satisfaction_loyalty_sem/notebook.ipynb) · [pt](translations/pt/procs/calis/customer_satisfaction_loyalty_sem/notebook.ipynb) · [sv](translations/sv/procs/calis/customer_satisfaction_loyalty_sem/notebook.ipynb) · [zh](translations/zh/procs/calis/customer_satisfaction_loyalty_sem/notebook.ipynb)

**CANDISC**

- [Bank Customer Risk Profiling](procs/candisc/bank_customer_risk_profiling/notebook.ipynb) — 🌐 [cs](translations/cs/procs/candisc/bank_customer_risk_profiling/notebook.ipynb) · [da](translations/da/procs/candisc/bank_customer_risk_profiling/notebook.ipynb) · [de](translations/de/procs/candisc/bank_customer_risk_profiling/notebook.ipynb) · [el](translations/el/procs/candisc/bank_customer_risk_profiling/notebook.ipynb) · [es](translations/es/procs/candisc/bank_customer_risk_profiling/notebook.ipynb) · [fi](translations/fi/procs/candisc/bank_customer_risk_profiling/notebook.ipynb) · [fr](translations/fr/procs/candisc/bank_customer_risk_profiling/notebook.ipynb) · [it](translations/it/procs/candisc/bank_customer_risk_profiling/notebook.ipynb) · [ja](translations/ja/procs/candisc/bank_customer_risk_profiling/notebook.ipynb) · [ko](translations/ko/procs/candisc/bank_customer_risk_profiling/notebook.ipynb) · [nl](translations/nl/procs/candisc/bank_customer_risk_profiling/notebook.ipynb) · [pl](translations/pl/procs/candisc/bank_customer_risk_profiling/notebook.ipynb) · [pt](translations/pt/procs/candisc/bank_customer_risk_profiling/notebook.ipynb) · [sv](translations/sv/procs/candisc/bank_customer_risk_profiling/notebook.ipynb) · [zh](translations/zh/procs/candisc/bank_customer_risk_profiling/notebook.ipynb)

**CAPABILITY**

- [Telecom Latency Capability](procs/capability/telecom_latency_capability/notebook.ipynb) — 🌐 [cs](translations/cs/procs/capability/telecom_latency_capability/notebook.ipynb) · [da](translations/da/procs/capability/telecom_latency_capability/notebook.ipynb) · [de](translations/de/procs/capability/telecom_latency_capability/notebook.ipynb) · [el](translations/el/procs/capability/telecom_latency_capability/notebook.ipynb) · [es](translations/es/procs/capability/telecom_latency_capability/notebook.ipynb) · [fi](translations/fi/procs/capability/telecom_latency_capability/notebook.ipynb) · [fr](translations/fr/procs/capability/telecom_latency_capability/notebook.ipynb) · [it](translations/it/procs/capability/telecom_latency_capability/notebook.ipynb) · [ja](translations/ja/procs/capability/telecom_latency_capability/notebook.ipynb) · [ko](translations/ko/procs/capability/telecom_latency_capability/notebook.ipynb) · [nl](translations/nl/procs/capability/telecom_latency_capability/notebook.ipynb) · [pl](translations/pl/procs/capability/telecom_latency_capability/notebook.ipynb) · [pt](translations/pt/procs/capability/telecom_latency_capability/notebook.ipynb) · [sv](translations/sv/procs/capability/telecom_latency_capability/notebook.ipynb) · [zh](translations/zh/procs/capability/telecom_latency_capability/notebook.ipynb)

**CATMOD**

- [Pharma Treatment Response Logit](procs/catmod/pharma_treatment_response_logit/notebook.ipynb) — 🌐 [cs](translations/cs/procs/catmod/pharma_treatment_response_logit/notebook.ipynb) · [da](translations/da/procs/catmod/pharma_treatment_response_logit/notebook.ipynb) · [de](translations/de/procs/catmod/pharma_treatment_response_logit/notebook.ipynb) · [el](translations/el/procs/catmod/pharma_treatment_response_logit/notebook.ipynb) · [es](translations/es/procs/catmod/pharma_treatment_response_logit/notebook.ipynb) · [fi](translations/fi/procs/catmod/pharma_treatment_response_logit/notebook.ipynb) · [fr](translations/fr/procs/catmod/pharma_treatment_response_logit/notebook.ipynb) · [it](translations/it/procs/catmod/pharma_treatment_response_logit/notebook.ipynb) · [ja](translations/ja/procs/catmod/pharma_treatment_response_logit/notebook.ipynb) · [ko](translations/ko/procs/catmod/pharma_treatment_response_logit/notebook.ipynb) · [nl](translations/nl/procs/catmod/pharma_treatment_response_logit/notebook.ipynb) · [pl](translations/pl/procs/catmod/pharma_treatment_response_logit/notebook.ipynb) · [pt](translations/pt/procs/catmod/pharma_treatment_response_logit/notebook.ipynb) · [sv](translations/sv/procs/catmod/pharma_treatment_response_logit/notebook.ipynb) · [zh](translations/zh/procs/catmod/pharma_treatment_response_logit/notebook.ipynb)

**CAUSALMED**

- [Decomposing the Effect of a Financial-Literacy Program on Loan Default with PROC CAUSALMED](procs/causalmed/financial_literacy_default_mediation/notebook.ipynb) — 🌐 [cs](translations/cs/procs/causalmed/financial_literacy_default_mediation/notebook.ipynb) · [da](translations/da/procs/causalmed/financial_literacy_default_mediation/notebook.ipynb) · [de](translations/de/procs/causalmed/financial_literacy_default_mediation/notebook.ipynb) · [el](translations/el/procs/causalmed/financial_literacy_default_mediation/notebook.ipynb) · [es](translations/es/procs/causalmed/financial_literacy_default_mediation/notebook.ipynb) · [fi](translations/fi/procs/causalmed/financial_literacy_default_mediation/notebook.ipynb) · [fr](translations/fr/procs/causalmed/financial_literacy_default_mediation/notebook.ipynb) · [it](translations/it/procs/causalmed/financial_literacy_default_mediation/notebook.ipynb) · [ja](translations/ja/procs/causalmed/financial_literacy_default_mediation/notebook.ipynb) · [ko](translations/ko/procs/causalmed/financial_literacy_default_mediation/notebook.ipynb) · [nl](translations/nl/procs/causalmed/financial_literacy_default_mediation/notebook.ipynb) · [pl](translations/pl/procs/causalmed/financial_literacy_default_mediation/notebook.ipynb) · [pt](translations/pt/procs/causalmed/financial_literacy_default_mediation/notebook.ipynb) · [sv](translations/sv/procs/causalmed/financial_literacy_default_mediation/notebook.ipynb) · [zh](translations/zh/procs/causalmed/financial_literacy_default_mediation/notebook.ipynb)

**CAUSALTRT**

- [Estimating the Causal Effect of a Care-Management Program on 30-Day Readmission with PROC CAUSALTRT](procs/causaltrt/care_program_readmission_causal_effect/notebook.ipynb) — 🌐 [cs](translations/cs/procs/causaltrt/care_program_readmission_causal_effect/notebook.ipynb) · [da](translations/da/procs/causaltrt/care_program_readmission_causal_effect/notebook.ipynb) · [fi](translations/fi/procs/causaltrt/care_program_readmission_causal_effect/notebook.ipynb) · [fr](translations/fr/procs/causaltrt/care_program_readmission_causal_effect/notebook.ipynb) · [it](translations/it/procs/causaltrt/care_program_readmission_causal_effect/notebook.ipynb) · [ja](translations/ja/procs/causaltrt/care_program_readmission_causal_effect/notebook.ipynb) · [ko](translations/ko/procs/causaltrt/care_program_readmission_causal_effect/notebook.ipynb) · [nl](translations/nl/procs/causaltrt/care_program_readmission_causal_effect/notebook.ipynb) · [pl](translations/pl/procs/causaltrt/care_program_readmission_causal_effect/notebook.ipynb) · [pt](translations/pt/procs/causaltrt/care_program_readmission_causal_effect/notebook.ipynb) · [zh](translations/zh/procs/causaltrt/care_program_readmission_causal_effect/notebook.ipynb)

**CHART**

- [Profiling Regional Grid Load and Outages with PROC CHART](procs/chart/grid_load_profiling_chart/notebook.ipynb) — 🌐 [cs](translations/cs/procs/chart/grid_load_profiling_chart/notebook.ipynb) · [da](translations/da/procs/chart/grid_load_profiling_chart/notebook.ipynb) · [fi](translations/fi/procs/chart/grid_load_profiling_chart/notebook.ipynb) · [fr](translations/fr/procs/chart/grid_load_profiling_chart/notebook.ipynb) · [it](translations/it/procs/chart/grid_load_profiling_chart/notebook.ipynb) · [ja](translations/ja/procs/chart/grid_load_profiling_chart/notebook.ipynb) · [ko](translations/ko/procs/chart/grid_load_profiling_chart/notebook.ipynb) · [nl](translations/nl/procs/chart/grid_load_profiling_chart/notebook.ipynb) · [pl](translations/pl/procs/chart/grid_load_profiling_chart/notebook.ipynb) · [pt](translations/pt/procs/chart/grid_load_profiling_chart/notebook.ipynb) · [zh](translations/zh/procs/chart/grid_load_profiling_chart/notebook.ipynb)

**CLP**

- [Minimizing Makespan in a Job-Shop with PROC OPTMODEL](procs/clp/job_shop_scheduling_clp/notebook.ipynb) — 🌐 [cs](translations/cs/procs/clp/job_shop_scheduling_clp/notebook.ipynb) · [da](translations/da/procs/clp/job_shop_scheduling_clp/notebook.ipynb) · [fr](translations/fr/procs/clp/job_shop_scheduling_clp/notebook.ipynb) · [it](translations/it/procs/clp/job_shop_scheduling_clp/notebook.ipynb) · [ja](translations/ja/procs/clp/job_shop_scheduling_clp/notebook.ipynb) · [ko](translations/ko/procs/clp/job_shop_scheduling_clp/notebook.ipynb) · [nl](translations/nl/procs/clp/job_shop_scheduling_clp/notebook.ipynb) · [pl](translations/pl/procs/clp/job_shop_scheduling_clp/notebook.ipynb) · [zh](translations/zh/procs/clp/job_shop_scheduling_clp/notebook.ipynb)

**CLUSTER**

- [Manufacturing Failure Mode Clustering](procs/cluster/manufacturing_failure_mode_clustering/notebook.ipynb) — 🌐 [cs](translations/cs/procs/cluster/manufacturing_failure_mode_clustering/notebook.ipynb) · [da](translations/da/procs/cluster/manufacturing_failure_mode_clustering/notebook.ipynb) · [ja](translations/ja/procs/cluster/manufacturing_failure_mode_clustering/notebook.ipynb) · [ko](translations/ko/procs/cluster/manufacturing_failure_mode_clustering/notebook.ipynb) · [nl](translations/nl/procs/cluster/manufacturing_failure_mode_clustering/notebook.ipynb) · [pl](translations/pl/procs/cluster/manufacturing_failure_mode_clustering/notebook.ipynb) · [zh](translations/zh/procs/cluster/manufacturing_failure_mode_clustering/notebook.ipynb)

**COMPUTAB**

- [Quarterly Pro Forma Income Statement with PROC COMPUTAB](procs/computab/bank_quarterly_income_statement/notebook.ipynb) — 🌐 [cs](translations/cs/procs/computab/bank_quarterly_income_statement/notebook.ipynb) · [da](translations/da/procs/computab/bank_quarterly_income_statement/notebook.ipynb) · [ja](translations/ja/procs/computab/bank_quarterly_income_statement/notebook.ipynb) · [ko](translations/ko/procs/computab/bank_quarterly_income_statement/notebook.ipynb) · [nl](translations/nl/procs/computab/bank_quarterly_income_statement/notebook.ipynb) · [pl](translations/pl/procs/computab/bank_quarterly_income_statement/notebook.ipynb) · [pt](translations/pt/procs/computab/bank_quarterly_income_statement/notebook.ipynb) · [zh](translations/zh/procs/computab/bank_quarterly_income_statement/notebook.ipynb)

**CONTENTS**

- [Genomic Variant Annotation Schema](procs/contents/genomic_variant_annotation_schema/notebook.ipynb) — 🌐 [cs](translations/cs/procs/contents/genomic_variant_annotation_schema/notebook.ipynb) · [da](translations/da/procs/contents/genomic_variant_annotation_schema/notebook.ipynb) · [ja](translations/ja/procs/contents/genomic_variant_annotation_schema/notebook.ipynb) · [ko](translations/ko/procs/contents/genomic_variant_annotation_schema/notebook.ipynb) · [nl](translations/nl/procs/contents/genomic_variant_annotation_schema/notebook.ipynb) · [pl](translations/pl/procs/contents/genomic_variant_annotation_schema/notebook.ipynb) · [zh](translations/zh/procs/contents/genomic_variant_annotation_schema/notebook.ipynb)

**CORR**

- [Genomic Gene Coexpression Network](procs/corr/genomic_gene_coexpression_network/notebook.ipynb) — 🌐 [da](translations/da/procs/corr/genomic_gene_coexpression_network/notebook.ipynb) · [ja](translations/ja/procs/corr/genomic_gene_coexpression_network/notebook.ipynb) · [ko](translations/ko/procs/corr/genomic_gene_coexpression_network/notebook.ipynb) · [nl](translations/nl/procs/corr/genomic_gene_coexpression_network/notebook.ipynb) · [pt](translations/pt/procs/corr/genomic_gene_coexpression_network/notebook.ipynb) · [zh](translations/zh/procs/corr/genomic_gene_coexpression_network/notebook.ipynb)

**CORRESP**

- [Mapping Brand Perception with Correspondence Analysis (PROC CORRESP)](procs/corresp/brand_attribute_perception_corresp/notebook.ipynb) — 🌐 [cs](translations/cs/procs/corresp/brand_attribute_perception_corresp/notebook.ipynb) · [da](translations/da/procs/corresp/brand_attribute_perception_corresp/notebook.ipynb) · [ja](translations/ja/procs/corresp/brand_attribute_perception_corresp/notebook.ipynb) · [ko](translations/ko/procs/corresp/brand_attribute_perception_corresp/notebook.ipynb) · [nl](translations/nl/procs/corresp/brand_attribute_perception_corresp/notebook.ipynb) · [pt](translations/pt/procs/corresp/brand_attribute_perception_corresp/notebook.ipynb) · [zh](translations/zh/procs/corresp/brand_attribute_perception_corresp/notebook.ipynb)

**CPM**

- [Critical-Path Scheduling of an Auto-Insurance Product Launch](procs/cpm/insurance_product_launch_cpm/notebook.ipynb)

**DISCRIM**

- [Genomic Cancer Subtype Classification](procs/discrim/genomic_cancer_subtype_classification/notebook.ipynb)

**DISTANCE**

- [Education Curriculum Similarity](procs/distance/education_curriculum_similarity/notebook.ipynb)

**DQMATCH**

- [Crm Customer Record Linkage](procs/dqmatch/crm_customer_record_linkage/notebook.ipynb)

**EFFECTPLOT**

- [Visualizing 30-Day Readmission Risk with Model-Based Effect Plots](procs/effectplot/hospital_readmission_effectplot/notebook.ipynb)

**ENTROPY**

- [Estimating a Residential Energy Demand System with Seemingly Unrelated Regression](procs/entropy/energy_demand_system_gme/notebook.ipynb)

**ESM**

- [Forecasting Emergency Department Visit Volume with Exponential Smoothing (PROC ESM)](procs/esm/ed_visit_volume_forecasting_esm/notebook.ipynb)

**EXPAND**

- [Pharma Quarterly To Monthly Enrollment](procs/expand/pharma_quarterly_to_monthly_enrollment/notebook.ipynb)

**FACTEX**

- [Factex Agriculture Split Plot](procs/factex/factex_agriculture_split_plot/notebook.ipynb)

**FACTMAC**

- [Modeling Patient-Experience Ratings Across Facilities and Specialties with PROC FACTMAC](procs/factmac/patient_experience_factmac_recommender/notebook.ipynb)

**FACTOR**

- [Manufacturing Quality Metric Reduction](procs/factor/manufacturing_quality_metric_reduction/notebook.ipynb)

**FASTCLUS**

- [Energy Building Efficiency Clustering](procs/fastclus/energy_building_efficiency_clustering/notebook.ipynb)

**FCMP**

- [Building a Reusable Actuarial Pricing Library with PROC FCMP](procs/fcmp/actuarial_pricing_functions/notebook.ipynb)

**FEDSQL**

- [Regulatory Compliance Data Aggregation](procs/fedsql/regulatory_compliance_data_aggregation/notebook.ipynb)

**FMM**

- [Discovering Subscriber Data-Usage Segments with PROC FASTCLUS](procs/fmm/subscriber_usage_segmentation_fmm/notebook.ipynb)

**FORECAST**

- [Forecasting Monthly Auto-Insurance Claim Counts with PROC FORECAST](procs/forecast/monthly_claims_seasonal_forecast/notebook.ipynb)

**FORMAT**

- [Clinical Trial Adverse Event Coding](procs/format/clinical_trial_adverse_event_coding/notebook.ipynb)

**FREQ**

- [Electoral Precinct Voting Pattern](procs/freq/electoral_precinct_voting_pattern/notebook.ipynb)

**G3D**

- [Visualizing Student Exam Performance with 3D Surfaces and Scatter Plots (PROC G3D)](procs/g3d/student_performance_surface_g3d/notebook.ipynb)

**GA**

- [Optimizing Last-Mile Delivery Routes with PROC OPTMODEL (Network TSP)](procs/ga/vehicle_route_optimization_ga/notebook.ipynb)

**GAGE**

- [Measurement System Analysis: Gage R&R for a State Weights and Measures Calibration Lab](procs/gage/scale_calibration_gage_rr/notebook.ipynb)

**GAM**

- [Modeling Nonlinear Retail Demand Curves with PROC GAM](procs/gam/retail_demand_curve_gam/notebook.ipynb)

**GAMPL**

- [Modeling Nonlinear Electricity Load Against Temperature with PROC GAMPL](procs/gampl/electricity_load_temperature_gam/notebook.ipynb)

**GAREABAR**

- [Plant Capacity vs. Throughput: Two-Dimensional Portfolio Analysis with PROC SGPLOT](procs/gareabar/manufacturing_capacity_throughput_areabar/notebook.ipynb)

**GBARLINE**

- [Telecom Monthly Network KPIs: Data Usage Bars with ARPU and Churn Lines (PROC GBARLINE)](procs/gbarline/telecom_network_kpi_barline/notebook.ipynb)

**GCHART**

- [Hospital Dept Resource Utilization Hbar](procs/gchart/hospital_dept_resource_utilization_hbar/notebook.ipynb)

**GCONTOUR**

- [Mapping Cell-Site Coverage with a Path-Loss Contour Surface](procs/gcontour/cellular_coverage_contour_map/notebook.ipynb)

**GEE**

- [Longitudinal Readmission Risk Under a Care-Management Program with PROC GEE](procs/gee/readmission_care_program_gee/notebook.ipynb)

**GENMOD**

- [Pharma Adverse Event Rate Poisson](procs/genmod/pharma_adverse_event_rate_poisson/notebook.ipynb)

**GEOCODE**

- [Geocoding Customer Deposit Accounts for CRA Market-Area Mapping](procs/geocode/cra_customer_geocoding/notebook.ipynb)

**GLIMMIX**

- [Clinical Trial Multisite Random Intercepts](procs/glimmix/clinical_trial_multisite_random_intercepts/notebook.ipynb)

**GLM**

- [Agriculture Latin Square Design](procs/glm/agriculture_latin_square_design/notebook.ipynb)

**GLMMOD**

- [Building a GLM Design Matrix for Loan Loss-Rate Modeling with PROC GLMMOD](procs/glmmod/credit_risk_design_matrix/notebook.ipynb)

**GLMPOWER**

- [Sizing a Driver-Routing Field Trial with PROC GLMPOWER](procs/glmpower/delivery_trial_power_sizing/notebook.ipynb)

**GLMSELECT**

- [Finding Demand Drivers with PROC GLMSELECT: Stepwise, LASSO, and Validated Forward Selection](procs/glmselect/demand_driver_selection/notebook.ipynb)

**GMAP**

- [Clinical Trial Site Network — Geographic Analysis](procs/gmap/clinical_trial_site_selection/notebook.ipynb)

**GPROJECT**

- [Projecting Clinical Trial Site Coordinates for Mapping with PROC GPROJECT](procs/gproject/clinical_trial_site_map_projection/notebook.ipynb)

**GREDUCE**

- [Reducing Delivery-Zone Map Detail for Fast Logistics Dashboards with PROC GREDUCE](procs/greduce/delivery_zone_map_reduction/notebook.ipynb)

**GVARCLUS**

- [Reducing Production-Line Sensor Redundancy with PROC GVARCLUS](procs/gvarclus/sensor_dimensionality_reduction/notebook.ipynb)

**HPCANDISC**

- [Discriminating Oncology Drug-Response Phenotypes from Pharmacodynamic Biomarkers with PROC HPCANDISC](procs/hpcandisc/drug_response_biomarker_discrimination/notebook.ipynb)

**HPCLUS**

- [Segmenting Telecom Subscribers with k-Means Clustering](procs/hpclus/telecom_subscriber_segmentation/notebook.ipynb)

**HPFMM**

- [Discovering Subscriber Usage Segments with K-Means Clustering (PROC FASTCLUS)](procs/hpfmm/subscriber_usage_segmentation_mixture/notebook.ipynb)

**HPGENSELECT**

- [Finding the Drivers of Daily Electricity Demand with GLM Variable Selection](procs/hpgenselect/utility_demand_glm_selection/notebook.ipynb)

**HPLMIXED**

- [Hierarchical Mixed Model of Residential Smart-Meter Energy Use with PROC HPLMIXED](procs/hplmixed/smart_meter_consumption_mixed_model/notebook.ipynb)

**HPPLS**

- [Credit-Risk Latent Factor Modeling with PROC HPPLS](procs/hppls/credit_risk_pls_dimension_reduction/notebook.ipynb)

**HPPRINCOMP**

- [Identifying Latent Academic Skill Dimensions with PROC PRINCOMP](procs/hpprincomp/student_assessment_pca/notebook.ipynb)

**HPQUANTSELECT**

- [Modeling the Upper Dimensional-Deviation Tail with PROC QUANTREG](procs/hpquantselect/manufacturing_scrap_tail_quantile_selection/notebook.ipynb)

**HPREG**

- [Retail Demand Modeling: Price and Promotion Drivers with Validation-Based Variable Selection](procs/hpreg/retail_demand_price_promotion_selection/notebook.ipynb)

**HPSPLIT**

- [Credit-Risk Scorecard with a Decision Tree (PROC HPSPLIT)](procs/hpsplit/credit_risk_scorecard_tree/notebook.ipynb)

**ICLIFETEST**

- [Iclifetest Bearing Inspection](procs/iclifetest/iclifetest_bearing_inspection/notebook.ipynb)

**ICPHREG**

- [Icphreg Joint Replacement](procs/icphreg/icphreg_joint_replacement/notebook.ipynb)

**IML**

- [Clinical Bootstrap Confidence Intervals](procs/iml/clinical_bootstrap_confidence_intervals/notebook.ipynb)

**IMPORT**

- [Clinical Lab Results Ingestion](procs/import/clinical_lab_results_ingestion/notebook.ipynb)

**INBREED**

- [Quantifying Shared-Design Heritage in a Power Transformer Fleet with PROC INBREED](procs/inbreed/transformer_design_lineage_relatedness/notebook.ipynb)

**ISHIKAWA**

- [Customer Churn Drivers Fishbone](procs/ishikawa/customer_churn_drivers_fishbone/notebook.ipynb)

**KCLUS**

- [K-Means Segmentation of Subscriber Behavior with PROC FASTCLUS](procs/kclus/subscriber_behavior_kmeans_segmentation/notebook.ipynb)

**KRIGE2D**

- [Spatial Prediction of Emergency Department Wait Times Across a Provider Catchment with PROC KRIGE2D](procs/krige2d/ed_wait_time_kriging_catchment/notebook.ipynb)

**LIFETEST**

- [Manufacturing Equipment Reliability](procs/lifetest/manufacturing_equipment_reliability/notebook.ipynb)

**LOAN**

- [Comparing Student Loan Repayment Plans with PROC LOAN](procs/loan/student_loan_repayment_comparison/notebook.ipynb)

**LOESS**

- [Denoising a Noisy Process Sensor Signal with PROC LOESS](procs/loess/process_sensor_loess_smoothing/notebook.ipynb)

**LOGISTIC**

- [Telecom Churn Propensity Model](procs/logistic/telecom_churn_propensity_model/notebook.ipynb)

**LP**

- [Portfolio Allocation Risk Constrained](procs/lp/portfolio_allocation_risk_constrained/notebook.ipynb)

**MACONTROL**

- [Hospital Medication Error Ewma](procs/macontrol/hospital_medication_error_ewma/notebook.ipynb)

**MBANALYSIS**

- [Market Basket Cross-Sell Analysis for a Grocery Retailer with PROC MBANALYSIS](procs/mbanalysis/retail_market_basket_cross_sell/notebook.ipynb)

**MCMC**

- [Bayesian Hierarchical Model of Insurance Claim Frequency by Region](procs/mcmc/bayesian_hierarchical_claim_frequency/notebook.ipynb)

**MDDB**

- [Building a Telecom Revenue-Assurance Summary Cube with PROC SUMMARY](procs/mddb/telecom_billing_olap_cube/notebook.ipynb)

**MDS**

- [Perceptual Mapping of Mobile Carriers with PROC MDS](procs/mds/telecom_carrier_perceptual_map/notebook.ipynb)

**MEANS**

- [Bank Transaction Amount Profiling](procs/means/bank_transaction_amount_profiling/notebook.ipynb)

**MI**

- [Handling Missing Loan-Application Data with Multiple Imputation (PROC MI)](procs/mi/credit_portfolio_multiple_imputation/notebook.ipynb)

**MIANALYZE**

- [Combining Multiply Imputed Process-Yield Models with PROC MIANALYZE (Manufacturing)](procs/mianalyze/process_yield_missing_sensor_mianalyze/notebook.ipynb)

**MIXED**

- [Longitudinal HbA1c Trajectories with PROC MIXED](procs/mixed/diabetes_hba1c_trajectory/notebook.ipynb)
- [Manufacturing Split Plot Design](procs/mixed/manufacturing_split_plot_design/notebook.ipynb)

**MODECLUS**

- [Density-Based Clustering of Grid Monitoring Sites with PROC MODECLUS](procs/modeclus/grid_monitoring_site_clustering/notebook.ipynb)

**MODEL**

- [Macro Supply Demand Equilibrium](procs/model/macro_supply_demand_equilibrium/notebook.ipynb)

**MVPDIAGNOSE**

- [Chemical Reactor Upset](procs/mvpdiagnose/chemical_reactor_upset/notebook.ipynb)

**MVPMODEL**

- [Mvpmodel Automotive Paint](procs/mvpmodel/mvpmodel_automotive_paint/notebook.ipynb)

**MVPMONITOR**

- [Steel Mill Rolling](procs/mvpmonitor/steel_mill_rolling/notebook.ipynb)

**NESTED**

- [Decomposing Claim-Settlement Variability Across an Insurer's Organizational Hierarchy with PROC NESTED](procs/nested/claims_settlement_variance_components/notebook.ipynb)

**NLIN**

- [Four-Parameter Logistic Dose-Response Curve Fitting with PROC NLIN](procs/nlin/dose_response_4pl_bioassay/notebook.ipynb) — 🌐 [cs](translations/cs/procs/nlin/dose_response_4pl_bioassay/notebook.ipynb) · [da](translations/da/procs/nlin/dose_response_4pl_bioassay/notebook.ipynb) · [de](translations/de/procs/nlin/dose_response_4pl_bioassay/notebook.ipynb) · [el](translations/el/procs/nlin/dose_response_4pl_bioassay/notebook.ipynb) · [es](translations/es/procs/nlin/dose_response_4pl_bioassay/notebook.ipynb) · [fi](translations/fi/procs/nlin/dose_response_4pl_bioassay/notebook.ipynb) · [fr](translations/fr/procs/nlin/dose_response_4pl_bioassay/notebook.ipynb) · [it](translations/it/procs/nlin/dose_response_4pl_bioassay/notebook.ipynb) · [ja](translations/ja/procs/nlin/dose_response_4pl_bioassay/notebook.ipynb) · [ko](translations/ko/procs/nlin/dose_response_4pl_bioassay/notebook.ipynb) · [nl](translations/nl/procs/nlin/dose_response_4pl_bioassay/notebook.ipynb) · [pl](translations/pl/procs/nlin/dose_response_4pl_bioassay/notebook.ipynb) · [pt](translations/pt/procs/nlin/dose_response_4pl_bioassay/notebook.ipynb) · [sv](translations/sv/procs/nlin/dose_response_4pl_bioassay/notebook.ipynb) · [zh](translations/zh/procs/nlin/dose_response_4pl_bioassay/notebook.ipynb)

**NLMIXED**

- [Population Pharmacokinetic Concentration-Time Modeling with PROC NLMIXED](procs/nlmixed/population_pk_concentration_time_model/notebook.ipynb)

**NLP**

- [Chemical Process Yield Maximization](procs/nlp/chemical_process_yield_maximization/notebook.ipynb)

**NPAR1WAY**

- [Bank Customer Satisfaction Kruskal](procs/npar1way/bank_customer_satisfaction_kruskal/notebook.ipynb)

**OPTLP**

- [Minimum-Cost Transportation Network Flow with PROC OPTMODEL](procs/optlp/min_cost_transportation_optlp/notebook.ipynb)

**OPTMODEL**

- [Multi-Plant Production Planning: Minimizing Supply-Chain Cost with PROC OPTMODEL (MILP)](procs/optmodel/multi_plant_production_planning_milp/notebook.ipynb)

**OPTQP**

- [Optimal Backhaul Bandwidth Allocation Across Service Classes (Quadratic Program)](procs/optqp/backhaul_bandwidth_allocation_qp/notebook.ipynb)

**ORTHOREG**

- [Response-Surface Optimization of a Manufacturing Process with PROC ORTHOREG](procs/orthoreg/response_surface_doe_orthoreg/notebook.ipynb)

**PARETO**

- [Manufacturing Defect Category Prioritization](procs/pareto/manufacturing_defect_category_prioritization/notebook.ipynb)

**PDLREG**

- [Estimating the Fiscal Multiplier of Public Infrastructure Spending with Polynomial Distributed Lags (PROC PDLREG)](procs/pdlreg/infrastructure_spending_fiscal_multiplier_pdl/notebook.ipynb)

**PHREG**

- [Energy Transformer Failure Analysis](procs/phreg/energy_transformer_failure_analysis/notebook.ipynb)

**PLOT**

- [Promotional Discount Elasticity Exploration with PROC PLOT](procs/plot/promo_discount_elasticity_plot/notebook.ipynb)

**PLS**

- [Calibrating NIR Spectra to Analyte Concentration with PROC PLS](procs/pls/nir_spectra_pls_calibration/notebook.ipynb)
- [NIR Spectral Calibration with Partial Least Squares (PROC PLS)](procs/pls/nir_spectral_calibration_pls/notebook.ipynb)

**POWER**

- [Pharma Phase3 Trial Design](procs/power/pharma_phase3_trial_design/notebook.ipynb)

**PRINCOMP**

- [Energy Smart Meter Load Shapes](procs/princomp/energy_smart_meter_load_shapes/notebook.ipynb)

**PRINQUAL**

- [Underwriting Risk Profiling with Optimal Variable Transformations (PROC PRINQUAL)](procs/prinqual/underwriting_risk_profiling/notebook.ipynb)

**PRINT**

- [Government Grant Disbursement Ledger](procs/print/government_grant_disbursement_ledger/notebook.ipynb)

**PSMATCH**

- [Reducing Confounding in an Observational Drug Study with PROC PSMATCH](procs/psmatch/propensity_score_matching_observational_therapy/notebook.ipynb)

**PYTHON**

- [Nlp Survey Classification](procs/python/nlp_survey_classification/notebook.ipynb)

**QUANTLIFE**

- [Where Support Friction Hurts Most: Censored Quantile Regression of Telecom Customer Lifetime (PROC QUANTLIFE)](procs/quantlife/telecom_churn_censored_quantile_regression/notebook.ipynb)

**QUANTREG**

- [Quantile Regression of Loss Given Default Across the Risk Distribution](procs/quantreg/lgd_quantile_regression/notebook.ipynb)

**QUANTSELECT**

- [Modeling Telecom Customer ARPU Across the Revenue Distribution with PROC QUANTREG](procs/quantselect/telecom_arpu_quantile_selection/notebook.ipynb)

**RANK**

- [Insurance Claim Severity Ranking](procs/rank/insurance_claim_severity_ranking/notebook.ipynb)

**RAREEVENTS**

- [Nuclear Plant Safety Incident Analysis](procs/rareevents/nuclear_plant_safety_incident_analysis/notebook.ipynb)

**REG**

- [Real Estate Property Valuation](procs/reg/real_estate_property_valuation/notebook.ipynb)

**RELIABILITY**

- [Energy Transformer Accelerated Life](procs/reliability/energy_transformer_accelerated_life/notebook.ipynb)

**REPORT**

- [Bank Regulatory Capital Report](procs/report/bank_regulatory_capital_report/notebook.ipynb)

**ROBUSTREG**

- [Robust Regression of Freight Delivery Cost per Route (PROC ROBUSTREG)](procs/robustreg/freight_cost_robust_regression/notebook.ipynb)

**RSREG**

- [Optimizing Insurance Pricing with Response Surface Methodology (PROC RSREG)](procs/rsreg/insurance_pricing_response_surface/notebook.ipynb)

**SGPANEL**

- [Retail Category Performance Panel](procs/sgpanel/retail_category_performance_panel/notebook.ipynb)

**SGPIE**

- [Healthcare Diagnosis Mix](procs/sgpie/healthcare_diagnosis_mix/notebook.ipynb)

**SGPLOT**

- [Retail Price Elasticity Scatter](procs/sgplot/retail_price_elasticity_scatter/notebook.ipynb)

**SGSCATTER**

- [Manufacturing Process Params](procs/sgscatter/manufacturing_process_params/notebook.ipynb)

**SHEWHART**

- [Manufacturing Dimension Spc](procs/shewhart/manufacturing_dimension_spc/notebook.ipynb)

**SIM2D**

- [Brownfield Soil-Lead Risk Mapping with Probability Kriging (PROC KRIGE2D)](procs/sim2d/brownfield_lead_contamination_risk_map/notebook.ipynb)

**SIMLIN**

- [Wholesale Electricity Market: Multiplier Analysis and Dynamic Simulation with PROC SIMLIN](procs/simlin/electricity_market_simlin_multipliers/notebook.ipynb)

**SIMNORMAL**

- [Simulating Correlated Regional Electricity Demand Scenarios for Grid Capacity Planning with PROC SIMNORMAL](procs/simnormal/grid_demand_scenario_simulation/notebook.ipynb)

**SPECTRA**

- [Detecting Seasonal Cycles in Weekly Retail Sales with PROC SPECTRA](procs/spectra/retail_sales_seasonal_spectral_analysis/notebook.ipynb)

**SQL**

- [Semiconductor Yield Defect Root Cause](procs/sql/semiconductor_yield_defect_root_cause/notebook.ipynb)

**STANDARD**

- [Retail Sales Metric Normalization](procs/standard/retail_sales_metric_normalization/notebook.ipynb)

**STATESPACE**

- [Joint Forecasting of Electricity Load and Natural Gas Demand with PROC VARMAX](procs/statespace/utility_load_gas_statespace_forecast/notebook.ipynb)

**STDRATE**

- [Risk-Adjusted 30-Day Mortality: Comparing Hospitals with Age- and Sex-Standardized Rates (PROC STDRATE)](procs/stdrate/hospital_risk_adjusted_mortality_stdrate/notebook.ipynb)

**STEPDISC**

- [Screening Audit-Risk Indicators with Stepwise Discriminant Analysis (PROC STEPDISC)](procs/stepdisc/tax_audit_risk_variable_screening/notebook.ipynb)

**SUMMARY**

- [Retail Sales Performance Rollups with PROC SUMMARY](procs/summary/retail_sales_performance_summary/notebook.ipynb)

**SURVEYFREQ**

- [Retail Customer Experience Survey](procs/surveyfreq/retail_customer_experience_survey/notebook.ipynb)

**SURVEYIMPUTE**

- [Imputing Item Nonresponse in a Stratified Household Income Survey with PROC SURVEYIMPUTE](procs/surveyimpute/household_income_survey_imputation/notebook.ipynb)

**SURVEYLOGISTIC**

- [Retail Purchase Intent Survey](procs/surveylogistic/retail_purchase_intent_survey/notebook.ipynb)

**SURVEYMEANS**

- [Energy Residential Energy Audit](procs/surveymeans/energy_residential_energy_audit/notebook.ipynb)

**SURVEYREG**

- [Agriculture Yield Determinants](procs/surveyreg/agriculture_yield_determinants/notebook.ipynb)

**SYSLIN**

- [Estimating a Retail Demand and Supply System with PROC SYSLIN](procs/syslin/retail_demand_supply_simultaneous_equations/notebook.ipynb)

**TABULATE**

- [Clinical Efficacy Summary Table](procs/tabulate/clinical_efficacy_summary_table/notebook.ipynb)

**TIMEDATA**

- [Accumulating Pharmacovigilance Adverse-Event Reports into Monthly Safety Time Series with PROC TIMESERIES](procs/timedata/adverse_event_signal_monthly_series/notebook.ipynb)

**TIMESERIES**

- [Pharma Clinical Visit Accumulation](procs/timeseries/pharma_clinical_visit_accumulation/notebook.ipynb)

**TMSCORE**

- [Topic Scoring of Adverse-Event Narratives with PROC TMSCORE](procs/tmscore/pharmacovigilance_ae_narrative_topic_scoring/notebook.ipynb)

**TPSPLINE**

- [Mapping Regional Air Quality with Thin-Plate Spline Smoothing (PROC TPSPLINE)](procs/tpspline/air_quality_surface_smoothing/notebook.ipynb)

**TRANSPOSE**

- [Bank Monthly Balance Pivot](procs/transpose/bank_monthly_balance_pivot/notebook.ipynb)

**TREE**

- [Hierarchical Store Segmentation with PROC TREE Dendrograms](procs/tree/store_segmentation_dendrogram/notebook.ipynb)

**TSCSREG**

- [Panel Regression of Manufacturing Unit Cost with PROC TSCSREG](procs/tscsreg/plant_unit_cost_panel_regression/notebook.ipynb)

**TTEST**

- [Pharma Treatment Vs Placebo](procs/ttest/pharma_treatment_vs_placebo/notebook.ipynb)

**UCM**

- [Energy Solar Generation Forecast](procs/ucm/energy_solar_generation_forecast/notebook.ipynb)

**UNIVARIATE**

- [Manufacturing Dimension Tolerance Analysis](procs/univariate/manufacturing_dimension_tolerance_analysis/notebook.ipynb)

**VARCLUS**

- [Variable Clustering of P&C Insurance Risk Predictors with PROC VARCLUS](procs/varclus/insurance_risk_variable_clustering/notebook.ipynb)

**VARCOMP**

- [Pharma Inter Lab Variability](procs/varcomp/pharma_inter_lab_variability/notebook.ipynb)

**VARIOGRAM**

- [Agriculture Soil Nutrient Mapping](procs/variogram/agriculture_soil_nutrient_mapping/notebook.ipynb)

**VARMAX**

- [Vector Autoregression of Electricity Demand and Wholesale Price (PROC VARMAX)](procs/varmax/electricity_demand_price_var/notebook.ipynb)

**VARREDUCE**

- [Reducing Credit-Risk Predictors with PROC VARREDUCE](procs/varreduce/credit_default_variable_reduction/notebook.ipynb)

**X11**

- [Seasonal Adjustment of Monthly Prescription Dispensing Volumes with PROC X13 (X-11 Method)](procs/x11/rx_dispensing_seasonal_adjustment/notebook.ipynb)

**X13**

- [Pharma Prescription Volume Adjustment](procs/x13/pharma_prescription_volume_adjustment/notebook.ipynb)

### By industry (11 examples)

**Banking And Financial Services**

- [Small-Business Revolving Credit-Line Utilization Model](banking_and_financial_services/credit_line_utilization_model/notebook.ipynb) — 🌐 [cs](translations/cs/banking_and_financial_services/credit_line_utilization_model/notebook.ipynb) · [da](translations/da/banking_and_financial_services/credit_line_utilization_model/notebook.ipynb) · [de](translations/de/banking_and_financial_services/credit_line_utilization_model/notebook.ipynb) · [el](translations/el/banking_and_financial_services/credit_line_utilization_model/notebook.ipynb) · [es](translations/es/banking_and_financial_services/credit_line_utilization_model/notebook.ipynb) · [fi](translations/fi/banking_and_financial_services/credit_line_utilization_model/notebook.ipynb) · [fr](translations/fr/banking_and_financial_services/credit_line_utilization_model/notebook.ipynb) · [it](translations/it/banking_and_financial_services/credit_line_utilization_model/notebook.ipynb) · [ja](translations/ja/banking_and_financial_services/credit_line_utilization_model/notebook.ipynb) · [ko](translations/ko/banking_and_financial_services/credit_line_utilization_model/notebook.ipynb) · [nl](translations/nl/banking_and_financial_services/credit_line_utilization_model/notebook.ipynb) · [pl](translations/pl/banking_and_financial_services/credit_line_utilization_model/notebook.ipynb) · [pt](translations/pt/banking_and_financial_services/credit_line_utilization_model/notebook.ipynb) · [sv](translations/sv/banking_and_financial_services/credit_line_utilization_model/notebook.ipynb) · [zh](translations/zh/banking_and_financial_services/credit_line_utilization_model/notebook.ipynb)

**Education**

- [Time-to-Dropout Survival Analysis of a Student Cohort](education/graduation_dropout_survival/notebook.ipynb) — 🌐 [cs](translations/cs/education/graduation_dropout_survival/notebook.ipynb) · [da](translations/da/education/graduation_dropout_survival/notebook.ipynb) · [de](translations/de/education/graduation_dropout_survival/notebook.ipynb) · [el](translations/el/education/graduation_dropout_survival/notebook.ipynb) · [es](translations/es/education/graduation_dropout_survival/notebook.ipynb) · [fi](translations/fi/education/graduation_dropout_survival/notebook.ipynb) · [fr](translations/fr/education/graduation_dropout_survival/notebook.ipynb) · [it](translations/it/education/graduation_dropout_survival/notebook.ipynb) · [ja](translations/ja/education/graduation_dropout_survival/notebook.ipynb) · [ko](translations/ko/education/graduation_dropout_survival/notebook.ipynb) · [nl](translations/nl/education/graduation_dropout_survival/notebook.ipynb) · [pl](translations/pl/education/graduation_dropout_survival/notebook.ipynb) · [pt](translations/pt/education/graduation_dropout_survival/notebook.ipynb) · [sv](translations/sv/education/graduation_dropout_survival/notebook.ipynb) · [zh](translations/zh/education/graduation_dropout_survival/notebook.ipynb)

**Energy And Utilities**

- [Battery Storage Dispatch Optimization for Energy Arbitrage and Peak Shaving](energy_and_utilities/battery_storage_dispatch/notebook.ipynb) — 🌐 [cs](translations/cs/energy_and_utilities/battery_storage_dispatch/notebook.ipynb) · [da](translations/da/energy_and_utilities/battery_storage_dispatch/notebook.ipynb) · [de](translations/de/energy_and_utilities/battery_storage_dispatch/notebook.ipynb) · [el](translations/el/energy_and_utilities/battery_storage_dispatch/notebook.ipynb) · [es](translations/es/energy_and_utilities/battery_storage_dispatch/notebook.ipynb) · [fi](translations/fi/energy_and_utilities/battery_storage_dispatch/notebook.ipynb) · [fr](translations/fr/energy_and_utilities/battery_storage_dispatch/notebook.ipynb) · [it](translations/it/energy_and_utilities/battery_storage_dispatch/notebook.ipynb) · [ja](translations/ja/energy_and_utilities/battery_storage_dispatch/notebook.ipynb) · [ko](translations/ko/energy_and_utilities/battery_storage_dispatch/notebook.ipynb) · [nl](translations/nl/energy_and_utilities/battery_storage_dispatch/notebook.ipynb) · [pl](translations/pl/energy_and_utilities/battery_storage_dispatch/notebook.ipynb) · [pt](translations/pt/energy_and_utilities/battery_storage_dispatch/notebook.ipynb) · [sv](translations/sv/energy_and_utilities/battery_storage_dispatch/notebook.ipynb) · [zh](translations/zh/energy_and_utilities/battery_storage_dispatch/notebook.ipynb)

**Government And Public Sector**

- [Weekly Notifiable-Disease Outbreak Forecasting for Public-Health Surveillance](government_and_public_sector/disease_outbreak_forecast/notebook.ipynb) — 🌐 [cs](translations/cs/government_and_public_sector/disease_outbreak_forecast/notebook.ipynb) · [da](translations/da/government_and_public_sector/disease_outbreak_forecast/notebook.ipynb) · [de](translations/de/government_and_public_sector/disease_outbreak_forecast/notebook.ipynb) · [el](translations/el/government_and_public_sector/disease_outbreak_forecast/notebook.ipynb) · [es](translations/es/government_and_public_sector/disease_outbreak_forecast/notebook.ipynb) · [fi](translations/fi/government_and_public_sector/disease_outbreak_forecast/notebook.ipynb) · [fr](translations/fr/government_and_public_sector/disease_outbreak_forecast/notebook.ipynb) · [it](translations/it/government_and_public_sector/disease_outbreak_forecast/notebook.ipynb) · [ja](translations/ja/government_and_public_sector/disease_outbreak_forecast/notebook.ipynb) · [ko](translations/ko/government_and_public_sector/disease_outbreak_forecast/notebook.ipynb) · [nl](translations/nl/government_and_public_sector/disease_outbreak_forecast/notebook.ipynb) · [pl](translations/pl/government_and_public_sector/disease_outbreak_forecast/notebook.ipynb) · [pt](translations/pt/government_and_public_sector/disease_outbreak_forecast/notebook.ipynb) · [sv](translations/sv/government_and_public_sector/disease_outbreak_forecast/notebook.ipynb) · [zh](translations/zh/government_and_public_sector/disease_outbreak_forecast/notebook.ipynb)

**Healthcare Providers**

- [Relieving ED Crowding: Quantile Regression of Emergency-Department Boarding Time](healthcare_providers/ed_boarding_quantreg/notebook.ipynb) — 🌐 [cs](translations/cs/healthcare_providers/ed_boarding_quantreg/notebook.ipynb) · [da](translations/da/healthcare_providers/ed_boarding_quantreg/notebook.ipynb) · [de](translations/de/healthcare_providers/ed_boarding_quantreg/notebook.ipynb) · [el](translations/el/healthcare_providers/ed_boarding_quantreg/notebook.ipynb) · [es](translations/es/healthcare_providers/ed_boarding_quantreg/notebook.ipynb) · [fi](translations/fi/healthcare_providers/ed_boarding_quantreg/notebook.ipynb) · [fr](translations/fr/healthcare_providers/ed_boarding_quantreg/notebook.ipynb) · [it](translations/it/healthcare_providers/ed_boarding_quantreg/notebook.ipynb) · [ja](translations/ja/healthcare_providers/ed_boarding_quantreg/notebook.ipynb) · [ko](translations/ko/healthcare_providers/ed_boarding_quantreg/notebook.ipynb) · [nl](translations/nl/healthcare_providers/ed_boarding_quantreg/notebook.ipynb) · [pl](translations/pl/healthcare_providers/ed_boarding_quantreg/notebook.ipynb) · [pt](translations/pt/healthcare_providers/ed_boarding_quantreg/notebook.ipynb) · [sv](translations/sv/healthcare_providers/ed_boarding_quantreg/notebook.ipynb) · [zh](translations/zh/healthcare_providers/ed_boarding_quantreg/notebook.ipynb)

**Insurance**

- [Claims Triage by Predicted Ultimate Severity](insurance/claims_triage_severity/notebook.ipynb) — 🌐 [cs](translations/cs/insurance/claims_triage_severity/notebook.ipynb) · [da](translations/da/insurance/claims_triage_severity/notebook.ipynb) · [de](translations/de/insurance/claims_triage_severity/notebook.ipynb) · [el](translations/el/insurance/claims_triage_severity/notebook.ipynb) · [es](translations/es/insurance/claims_triage_severity/notebook.ipynb) · [fi](translations/fi/insurance/claims_triage_severity/notebook.ipynb) · [fr](translations/fr/insurance/claims_triage_severity/notebook.ipynb) · [it](translations/it/insurance/claims_triage_severity/notebook.ipynb) · [ja](translations/ja/insurance/claims_triage_severity/notebook.ipynb) · [ko](translations/ko/insurance/claims_triage_severity/notebook.ipynb) · [nl](translations/nl/insurance/claims_triage_severity/notebook.ipynb) · [pl](translations/pl/insurance/claims_triage_severity/notebook.ipynb) · [pt](translations/pt/insurance/claims_triage_severity/notebook.ipynb) · [sv](translations/sv/insurance/claims_triage_severity/notebook.ipynb) · [zh](translations/zh/insurance/claims_triage_severity/notebook.ipynb)

**Pharmaceuticals And Life Sciences**

- [Estimating Vaccine Efficacy from a Randomized Trial via Time-to-First-Infection](pharmaceuticals_and_life_sciences/vaccine_efficacy_survival_analysis/notebook.ipynb) — 🌐 [cs](translations/cs/pharmaceuticals_and_life_sciences/vaccine_efficacy_survival_analysis/notebook.ipynb) · [da](translations/da/pharmaceuticals_and_life_sciences/vaccine_efficacy_survival_analysis/notebook.ipynb) · [de](translations/de/pharmaceuticals_and_life_sciences/vaccine_efficacy_survival_analysis/notebook.ipynb) · [el](translations/el/pharmaceuticals_and_life_sciences/vaccine_efficacy_survival_analysis/notebook.ipynb) · [es](translations/es/pharmaceuticals_and_life_sciences/vaccine_efficacy_survival_analysis/notebook.ipynb) · [fi](translations/fi/pharmaceuticals_and_life_sciences/vaccine_efficacy_survival_analysis/notebook.ipynb) · [fr](translations/fr/pharmaceuticals_and_life_sciences/vaccine_efficacy_survival_analysis/notebook.ipynb) · [it](translations/it/pharmaceuticals_and_life_sciences/vaccine_efficacy_survival_analysis/notebook.ipynb) · [ja](translations/ja/pharmaceuticals_and_life_sciences/vaccine_efficacy_survival_analysis/notebook.ipynb) · [ko](translations/ko/pharmaceuticals_and_life_sciences/vaccine_efficacy_survival_analysis/notebook.ipynb) · [nl](translations/nl/pharmaceuticals_and_life_sciences/vaccine_efficacy_survival_analysis/notebook.ipynb) · [pl](translations/pl/pharmaceuticals_and_life_sciences/vaccine_efficacy_survival_analysis/notebook.ipynb) · [pt](translations/pt/pharmaceuticals_and_life_sciences/vaccine_efficacy_survival_analysis/notebook.ipynb) · [sv](translations/sv/pharmaceuticals_and_life_sciences/vaccine_efficacy_survival_analysis/notebook.ipynb) · [zh](translations/zh/pharmaceuticals_and_life_sciences/vaccine_efficacy_survival_analysis/notebook.ipynb)

**Retail And Consumer Goods**

- [Predicting Category Basket Penetration with Logistic Regression](retail_and_consumer_goods/basket_penetration_logistic/notebook.ipynb)
- [Conjoint Analysis of Product-Feature Part-Worths with PROC TRANSREG](retail_and_consumer_goods/feature_conjoint_transreg/notebook.ipynb)

**Telecommunications**

- [Modeling Cell-Site Data Throughput from Load and Configuration Drivers](telecommunications/data_throughput_reg/notebook.ipynb)

**Transportation And Logistics**

- [Intermodal Mode-Shift Analysis: Rail vs Truck Cost and Emissions](transportation_and_logistics/intermodal_mode_shift/notebook.ipynb)

<!-- END EXAMPLE INDEX -->

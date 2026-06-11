# Hospital Readmission Risk — Model-Based Effect Plots

Fits a logistic regression for 30-day hospital readmission on a 100-discharge
synthetic cohort, then translates the fitted coefficients into
predicted-probability **effect plots** for care-management risk stratification.

## What it demonstrates

- **PROC LOGISTIC** with `CLASS` reference coding, `CLODDS=WALD`, `RSQUARE`,
  `LACKFIT`, `UNITS`, and `ODDSRATIO`, capturing the fitted estimates with
  `ODS OUTPUT ParameterEstimates=`.
- Three model-based effect displays built from the fitted coefficients and
  drawn with **PROC SGPLOT**:
  - **Fit curve** — predicted P(readmit) vs length of stay.
  - **Sliced fit** — predicted P(readmit) vs age, one curve per payer.
  - **Interaction display** — predicted P(readmit) by department and payer.

## Key results (from the executed notebook)

- 55 of 100 discharges readmitted; generalized R-square 0.246;
  Hosmer–Lemeshow *p* = 0.73 (good fit).
- Length of stay OR 1.36 per day; age OR 1.05 per year; Medicaid OR 6.02
  vs Medicare (95% CI 1.46–24.8).
- Predicted readmission probability rises from ~0.23 (1-day stay) to ~0.98
  (18-day stay) for a Medicare cardiology patient at the cohort means.

## Implementation note

SAS produces these displays directly through the `EFFECTPLOT` statement in
PROC LOGISTIC. Jenner accepts that statement but does not yet render the
FIT / SLICEFIT / INTERACTION graphics, so the notebook reconstructs the
identical predicted-probability curves from the fitted coefficients. The
engine gap is tracked by `tests/400998_nb_logistic_effectplot_fit_curve`.

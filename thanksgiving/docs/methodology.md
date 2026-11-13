# Methodology

## Question and target

The question is when, in the weeks before Thanksgiving 2026 (Thursday 26 November), a US shopper should expect the lowest price for a frozen whole turkey. The target is the **national store-weighted average advertised price of a conventional frozen whole turkey, per lb**, from USDA AMS *Weekly Grocery Store Turkey Feature Activity*. Each observation covers one ad week (normally Saturday to Friday) and is published on the Friday the week ends. See [data_inventory.md](data_inventory.md) for sources, coverage and data cleaning.

The modeled variable is the log price, $\log P_{y,w}$, for season $y$ and ad week $w$. Time within the season is measured as days to Thanksgiving, $t$ = the fourth Thursday of November minus the ad-week midpoint. Thanksgiving week has $t = 2$, the week before $t = 9$, and so on.

## Candidate models

| Model | Specification | Jenner procedure |
|---|---|---|
| Naive | Last observed price persists; the interval grows with $\sqrt{h}$ using the historical week-to-week standard deviation | DATA step, PROC SQL |
| A0 | $\log P = \alpha_y + \varepsilon$ (season effect only, flat season) | PROC GLM |
| A1-A3 | $\log P = \alpha_y + \sum_{k=1}^{K} \beta_k t^k + \varepsilon$, $K = 1, 2, 3$ | PROC GLM, PROC GLMSELECT |
| B1 | $\alpha_y + f(t) + \varepsilon$, $f$ a smoothing spline with 3 df | PROC GAM |
| B2 | A2 + log number of advertising stores | PROC GLM |
| C | $\log P_t = \mu_t + \beta_1 t + \beta_2 t^2 + \varepsilon_t$, $\mu_t = \mu_{t-1} + \eta_t$ on a **daily** calendar; the price is observed only at ad-week midpoints | PROC UCM |
| D | $\log P_{r,y,t} = \gamma_y + \beta_1 t + \beta_2 t^2 + a_r + b_{r,y} + \varepsilon$ with random region and region-by-season effects | PROC MIXED |

The season effect $\alpha_y$ carries all between-year variation: inflation, supply and changes in USDA's store sample. For the forecast season it is estimated from that season's weeks observed so far, so the forecast is anchored on current-year prices.

Model C is a state-space model with a daily latent price level. The Kalman filter treats the days between ad-week midpoints, and the off-season, as missing observations. Nothing is interpolated.

## Hypotheses

| Hypothesis | Test | Result |
|---|---|---|
| H1 Prices fall as Thanksgiving approaches | Shape of the polynomial in $t$; season-by-season comparison of Thanksgiving week with two ad weeks earlier | **Only until mid-November.** The cubic term is significant ($t = -3.53$, $p < 0.001$) and the fitted curve bottoms out about 12 days before Thanksgiving. In 16 of 21 completed seasons the Thanksgiving-week price was higher than the price two ad weeks earlier (mean +8.2%, median +9.3%). |
| H2 Retailers cut prices when they advertise most | Within-season correlation of log price with log stores advertising; OLS coefficient | **Supported.** Spearman $\rho = -0.33$ ($p < 0.001$). Controlling for season and a quadratic in $t$, the elasticity of price to the number of advertising stores is $-0.048$ ($p < 0.001$). The store count is not known ahead of time, so it is not used for forecasting. |
| H3 Turkeys are sold as a loss leader | Store-weighted retail ad price against the previous week's wholesale price for frozen hens, three ad weeks through Thanksgiving, 2022-2025 | **Supported in two of four seasons.** Retail was 44% below wholesale in 2022 and in 2025, 1% below in 2024 and 8% above in 2023. Mean log ratio $-0.27$ ($t = -2.81$, $p = 0.017$, 12 weeks). Wholesale ranged from \$0.96 to \$1.75 per lb while the retail ad price ranged from \$0.95 to \$1.11. |
| H4 Fresh turkeys carry a premium | Paired log difference, fresh minus frozen, in the two ad weeks through Thanksgiving, 2005-2025 | **Supported.** Mean log premium 0.56, or about 75% ($t = 32.7$, $p < 0.001$, 42 weeks). The premium was 45-80% before 2015 and 65-110% from 2018. |
| H5 Regional differences | PROC MIXED (REML, Kenward-Roger) with random region and region-by-season effects; region × $t$ interaction | **Supported.** Variance components: region 0.0019, region × season 0.0018, residual 0.0194. Region fixed effect F = 3.59, p = 0.004; region × $t$ F = 3.34, p = 0.006. Store-weighted mean prices run from \$0.87 (Southeast) to \$1.02 (Northwest). |

These are associations, not causal effects.

## Validation

**Rolling-origin backtests** were run for seasons 2012-2025 at two forecast origins: **26 days before Thanksgiving** (about four ad weeks unknown) and **14 days before Thanksgiving** (three ad weeks unknown, the same point in the season as this forecast). Each forecast is fitted only on earlier seasons plus the forecast season's weeks whose report had been published by the origin date. Adjacent weeks are never split at random.

Metrics, computed on the dollar scale for every unseen national week:

- MAE, RMSE and MAPE
- empirical coverage and mean width of the 95% prediction interval
- **lowest-week hit rate**: the share of seasons where the week with the lowest predicted price was the week with the lowest actual price
- **mean regret**: the actual price in the predicted-cheapest week minus the actual minimum

For the naive and flat-season models, every future week gets the same predicted price, so their lowest-week hit rate and regret reflect row order, not skill.

The model comparison table is at `output/tables/model_comparison.csv`, with per-week detail in `output/tables/backtest_detail.csv`.

| Model | RMSE, 14 days out | 95% coverage | RMSE, 26 days out | 95% coverage |
|---|---|---|---|---|
| C state space (UCM) | $0.091 | 97.5% | $0.105 | 69.6% |
| A1 linear | $0.112 | 97.5% | $0.163 | 91.1% |
| B1 GAM | $0.112 | 95.0% | $0.151 | 91.1% |
| A3 cubic | $0.113 | 95.0% | $0.150 | 92.9% |
| Naive | $0.115 | 100% | $0.181 | 98.2% |
| A0 flat season | $0.116 | 95.0% | $0.168 | 91.1% |
| A2 quadratic | $0.121 | 95.0% | $0.166 | 91.1% |

**Selection rule:** keep models whose 95% intervals cover 85-100% of outcomes at both origins, then choose the lowest RMSE at the 14-day origin, breaking near-ties (within half a cent) on the 26-day origin.

**Selected model: A3.** The state-space model has the lowest point error at both origins, but its intervals covered only 70% of outcomes at the 26-day origin, so it fails the coverage requirement. Among the rest, A1, B1 and A3 are within a tenth of a cent of each other at the 14-day origin, and A3 is best at the 26-day origin. A3 is also the specification with the lowest AIC on the full sample.

Two cautions follow from the table:

- Two weeks out, no model beats the naive forecast by much (\$0.113 against \$0.115). Most of what is known about the next three weeks is this season's price level.
- No model picks the single cheapest remaining week reliably (36-50% of seasons). The forecast supports "the next week or so is a better bet than Thanksgiving week", not a specific day.

The state-space model is reported as a cross-check. For 2026 it forecasts a flatter path, about \$1.15 per lb from 13 November through Thanksgiving with a rise of under one cent, against A3's rise of 11 cents. Both put the low in mid-November and neither shows a gain from waiting.

## Prediction intervals

For the GLM models, the 95% interval on the log scale is the standard OLS prediction interval for a new observation,
$\hat\mu \pm t_{0.975,\,\nu}\sqrt{\widehat{\mathrm{Var}}(\hat\mu) + \hat\sigma^2}$.
It includes parameter uncertainty (the forecast season's level among it) and residual week-to-week variation. Intervals are exponentiated. The point forecast is the conditional mean $\exp(\hat\mu + s^2/2)$, where $s$ is the prediction standard error.

For the GAM (B1), PROC GAM gives no standard error for the overall prediction. Its STD output is per smoothing component. The interval therefore combines the smoothing component's standard error, the residual variance $\hat\sigma^2$, and $\hat\sigma^2/n_y$ for the uncertainty in the current season's level ($n_y$ = observed weeks this season). This is an approximation.

Three points about interpretation:

- The interval covers the **national average advertised price for that day's ad week**. It does not cover the price at an individual store.
- Residuals of the quadratic model are close to normal (Shapiro-Wilk $W = 0.99$, $p = 0.48$).
- Residual autocorrelation within a season is negligible (lag-1 $r = 0.02$), so weekly shocks are treated as independent.

## Daily forecast and cheapest day

Daily expected prices evaluate the fitted seasonal curve at each day's days-to-Thanksgiving value. USDA does not publish daily retail prices, so **daily accuracy cannot be validated**. The daily curve means "the expected advertised price for ads running on that day".

Each day in the output CSV carries one of three statuses:

- `observed`: the day falls in a published ad week; the weekly price is shown.
- `inferred`: before the cutoff, but its ad week is not yet published.
- `forecast`: after the cutoff.

The predicted lowest-price date is $d^* = \arg\min_d \hat E[P_d]$ over dates after the cutoff. The probability that each remaining ad week is the cheapest comes from 20,000 joint simulations (seed 20261126). Each simulated path draws a common level shift with the standard error of the mean forecast, plus an independent shock per ad week with the residual variance. The same paths give the probability that the price on the first forecast day is below the price on Thanksgiving Day.

## Limitations

- Advertised prices are not transaction prices. Loyalty-card prices, coupons and "free turkey with purchase" offers are not in the data.
- The forecast describes the national average for conventional frozen whole turkeys. Fresh, organic, antibiotic-free and kosher birds are priced differently, and regional averages differ by 10 to 15 cents per lb.
- The 2026 season level rests on four observed weeks, three of them from October, when few stores advertise.
- The cheapest date is a statement about expected prices. It is not a guarantee, and a frozen turkey bought late also needs several days to thaw.
- The wholesale comparison covers four seasons. It describes those seasons and is not a test of pricing strategy in general.

## Reproducibility

`run_all.sas` runs the whole analysis, including every chart and social card, and `config/settings.sas` holds all settings (cutoff date, store threshold, season window, seed).

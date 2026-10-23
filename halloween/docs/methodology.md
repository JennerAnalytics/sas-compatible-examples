# Methodology

## Question and target

The question is when in October 2026 a US shopper should expect the lowest price for a Halloween carving pumpkin. The target is the **national store-weighted average advertised price of a conventional carving pumpkin sold each**, from USDA AMS *Weekly Grocery Store Specialty Crops Feature Activity*. Each observation covers one ad week (Saturday to Friday) and is published on the Friday the week ends. See [data_inventory.md](data_inventory.md) for sources, coverage and data cleaning.

The modeled variable is the log price, $\log P_{y,w}$, for season $y$ and ad week $w$. Time within the season is measured as days to Halloween, $t = $ 31 October minus the ad-week midpoint.

## Candidate models

| Model | Specification | Jenner procedure |
|---|---|---|
| Naive | Last observed price persists; the interval grows with $\sqrt{h}$ using the historical week-to-week standard deviation | DATA step, PROC SQL |
| A0 | $\log P = \alpha_y + \varepsilon$ (season effect only, flat season) | PROC GLM |
| A1-A3 | $\log P = \alpha_y + \sum_{k=1}^{K} \beta_k t^k + \varepsilon$, $K = 1, 2, 3$ | PROC GLM, PROC GLMSELECT |
| B1 | $\alpha_y + f(t) + \varepsilon$, $f$ a smoothing spline with 3 df | PROC GAM |
| B2/B3 | B1 + lagged wholesale price (linear or smooth) + search interest | PROC GAM, PROC GLM |
| C | $\log P_t = \mu_t + \beta_1 t + \beta_2 t^2 + \varepsilon_t$, $\mu_t = \mu_{t-1} + \eta_t$ on a **daily** calendar; the price is observed only at ad-week midpoints | PROC UCM |
| D | $\log P_{r,y,t} = \gamma_y + \beta_1 t + \beta_2 t^2 + a_r + b_{r,y} + \varepsilon$ with random region and region-by-season effects | PROC MIXED |

The season effect $\alpha_y$ carries all between-year variation: inflation, supply and changes in USDA's product mix. For the forecast season it is estimated from that season's weeks observed so far, so the forecast is anchored on current-year prices.

Model C is a real state-space model with a daily latent price level. The Kalman filter treats the days between ad-week midpoints, and the off-season, as missing observations. Nothing is interpolated.

## Explanatory variables and hypotheses

| Hypothesis | Test | Result |
|---|---|---|
| H1 Halloween deadline discount (prices fall into Halloween) | Shape of $f(t)$ | **Not supported for advertised prices.** Prices bottom out 2-4 weeks before Halloween and rise in the final week. Type III tests for the cubic terms: $p < 0.001$. |
| H2 Seasonal demand pushes prices up | Within-season correlation of log price with "pumpkin patch" search interest; GAM/OLS coefficient | **Opposite sign.** Higher-search weeks have *lower* advertised prices (Spearman $\rho = -0.31$, $p < 0.001$; OLS coefficient $-0.0024$ per index point, $p = 0.026$, controlling for season and $t$). This fits countercyclical pricing, where retailers feature seasonal items as traffic drivers at peak demand. |
| H3 Larger harvests lower prices | Regression of estimated season effects on log national production (2011-2025) and fresh-market production (2016-2025) | No detectable association ($p = 0.40$ and $0.54$; 15 and 10 seasons). |
| H4 Wholesale prices pass through to retail | Lagged 7-day mean of daily terminal-market Howden 36-inch bin prices in the weekly model, linear and smooth | No detectable effect ($p = 0.71$ linear, $p = 0.32$ smooth). Wholesale data were therefore not used in forecasting. |
| H5 Regional differences | PROC MIXED (REML, Kenward-Roger) with random region and region-by-season effects; region × $t$ interaction | **Supported.** Variance components: region 0.0027, region × season 0.0040, residual 0.0233. Region fixed effect F = 6.14, p < 0.001; region × $t$ F = 2.86, p = 0.015. |

These are associations, not causal effects. None of the regressions has an identification strategy that would support causal supply or demand elasticities.

## Validation

**Rolling-origin backtests** were run for seasons 2016-2025 at two forecast origins: **30 September** (all of October unknown) and **21 October** (the same point in the season as the 2026 forecast). Each forecast is fitted only on earlier seasons plus the forecast season's weeks whose report had been published by the origin date. Adjacent weeks are never split at random.

Metrics, computed on the dollar scale for every unseen national week:

- MAE, RMSE and MAPE
- empirical coverage and mean width of the 95% prediction interval
- **lowest-week hit rate**: the share of seasons where the week with the lowest predicted price was the week with the lowest actual price
- **mean regret**: the actual price in the predicted-cheapest week minus the actual minimum

For the naive model, every future week gets the same predicted price, so its lowest-week hit rate and regret are not meaningful.

The model comparison table is at `output/tables/model_comparison.csv`, with per-week detail in `output/tables/backtest_detail.csv`.

**Selection rule:** choose the lowest RMSE at the 21 October origin among models whose coverage is within 85-100%. Break ties on the 30 September origin, then on simplicity.

## Prediction intervals

For the GLM models, the 95% interval on the log scale is the standard OLS prediction interval for a new observation,
$\hat\mu \pm t_{0.975,\,\nu}\sqrt{\widehat{\mathrm{Var}}(\hat\mu) + \hat\sigma^2}$.
It includes parameter uncertainty (the forecast season's level among it) and residual week-to-week variation. Intervals are exponentiated. The point forecast is the conditional mean $\exp(\hat\mu + s^2/2)$, where $s$ is the prediction standard error.

For the GAM (B1), SAS PROC GAM gives no standard error for the overall prediction. Its STD/UCLM/LCLM outputs are per smoothing component. The interval therefore combines the smoothing component's standard error, the residual variance $\hat\sigma^2$, and $\hat\sigma^2/n_y$ for the uncertainty in the current season's level ($n_y$ = observed weeks this season). This is an approximation.

Three points about interpretation:

- The interval covers the **national average advertised price for that day's ad week**. It does not cover the price at an individual store.
- Residuals are heavier-tailed than normal (Shapiro-Wilk $W = 0.85$), and the 2012 season opens with a $2.16 outlier. In the backtests, 95% intervals covered 98-100% of unseen weeks, so they are, if anything, conservative.
- Residual autocorrelation within a season is negligible (lag-1 $r = -0.05$), so weekly shocks are treated as independent.

## Daily forecast and cheapest day

Daily expected prices evaluate the fitted seasonal curve at each day's days-to-Halloween value. USDA does not publish daily retail prices, so **daily accuracy cannot be validated**. The daily curve means "the expected advertised price for ads running on that day".

Each day in the output CSV carries one of three statuses:

- `observed`: the day falls in a published ad week; the weekly price is shown.
- `inferred`: before the cutoff, but its ad week is not yet published.
- `forecast`: after the cutoff.

The predicted lowest-price date is $d^* = \arg\min_d \hat E[P_d]$ over dates after the cutoff. The probability that each remaining ad week is the cheapest comes from 20,000 joint simulations (seed 20261031). Each simulated path draws a common level shift with the standard error of the mean forecast, plus an independent shock per ad week with the residual variance.

## Limitations

- Advertised prices are not transaction prices. Farm-stand and pumpkin-patch prices are not covered.
- Retailers stop advertising pumpkins in the final week. Late-October observations are thin (100-500 stores), and post-Halloween or unadvertised clearance prices are not observed. **The model cannot see an in-store "day before Halloween" markdown.**
- USDA's product definitions changed in 2023, when size-marked pumpkins started being reported separately.
- The forecast describes the national average. Regional prices differ by $1-2.
- The cheapest date is a statement about expected prices. It is not a guarantee, and it says nothing about availability or selection, which typically worsen late in the month.

## Reproducibility

`run_all.sas` runs the whole analysis, and `config/settings.sas` holds all settings (cutoff date, store threshold, seed). The scripts in `scripts/` re-download the data.

## Jenner limitations found

Building this analysis exposed defects in Jenner. Each was reproduced and assigned to a fix. Results that depend on an unfixed procedure are marked pending above.

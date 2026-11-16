# Post copy

Numbers are from the run with forecast cutoff 12 November 2026 (latest USDA ad week: Oct 31 - Nov 6). Rerun `sas/08_forecast.sas` and `sas/10_social_cards.sas` after each Friday USDA release and update the figures below.

## LinkedIn (use with turkey_linkedin_1200x627.png, or as a carousel with all four cards)

🦃 When is the best time to buy a Thanksgiving turkey? We asked 22 years of USDA data.

Conventional wisdom says the deals get better the closer you get to the holiday. The supermarket ad data say the best deals come earlier.

📉 Advertised frozen-turkey prices typically bottom out in mid-November, about two weeks before Thanksgiving.
📈 Then they climb, to about 11% above the low by Thanksgiving Day. In 16 of the last 21 seasons, Thanksgiving-week ads were pricier than the ads two weeks earlier.
💸 The latest USDA week (Oct 31 - Nov 6) came in at $1.19/lb. Forecast: about $1.16/lb around Sat Nov 14 vs. $1.27/lb on Wed Nov 25. On a 16-lb bird, waiting until the last minute costs about $1.72. This week's ad price beat Thanksgiving week's in 79% of 20,000 simulated price paths.

Three more findings for the economists:
• The turkey is a loss leader, and the data show it. In 2022 and 2025, supermarkets advertised frozen turkeys about 44% below the wholesale price. Wholesale swung between $0.96 and $1.75/lb over four years; the advertised price stayed between $0.95 and $1.11.
• Weeks with more stores advertising turkeys have lower advertised prices. Prices are lowest exactly when demand peaks.
• Fresh costs more: in the two ad weeks through Thanksgiving, fresh whole turkeys are advertised about 75% above frozen on average, and closer to 90% in recent years.

The whole pipeline is SAS-compatible code running on Jenner Analytics: PROC IMPORT, SQL, GLM, GLMSELECT, GAM, UCM state-space and MIXED models, rolling-origin backtests over 14 seasons, 95% prediction intervals, and every chart and card drawn with PROC SGPLOT. Code and data are open source (MIT): https://github.com/JennerAnalytics/sas-compatible-examples/tree/main/thanksgiving

Caveats: these are national average advertised supermarket prices for conventional frozen whole turkeys, not checkout receipts. Loyalty-card and "free turkey with $100 purchase" offers are not in the data, and your store may differ.

#Thanksgiving #DataScience #Econometrics #Forecasting #SAS #Analytics

## LinkedIn, the deals post (use with turkey_deals_linkedin_1200x627.png, or as a carousel with turkey_deals_by_week_1080x1080.png and turkey_deals_map_1200x627.png)

Numbers are from the price-spread run on USDA data through the ad week of 7-13 November 2026. Rerun `run_spread.sas` after each Friday USDA release and update the figures below.

🦃 I found one turkey for $88 and another for $11. So we stopped asking what the average turkey costs and asked when the best deals show up.

The average advertised price of a frozen whole turkey hardly moves before Thanksgiving: about $1.16/lb in mid-October, about $1.00 by the holiday. The cheapest ads tell a different story.

📉 The typical cheapest ad in a US region falls from $1.02/lb in mid-October to about $0.35 by November 10.
🎯 The best deals (the 10th percentile of those cheapest ads) fall from $0.68 to $0.24/lb, and stay there through Thanksgiving week.
📅 Five weeks before Thanksgiving week, 5% of regions have a turkey advertised at 50 cents a pound or less. Three weeks before: 48%. The week before: 91%.
🗺️ In the ad week of 7-13 November the cheapest ad was $0.24/lb in the Southeast and $0.29 in the Northeast, against $0.58 in the Northwest.

So the deals are not better at the last minute. They arrive about 16 days out, and they hold.

For the statisticians: PROC QUANTREG for the 10th, 50th and 90th percentiles, PROC AUTOREG with a HETERO statement for how the variance changes over the season, and PROC SGMAP for the map. All SAS-compatible code running on Jenner Analytics, open source (MIT): https://github.com/JennerAnalytics/sas-compatible-examples/tree/main/thanksgiving

Caveats: these are advertised prices from USDA, not checkout receipts. USDA publishes a low, an average and a high for each region, not store-level prices, so the percentiles are across regions and seasons. Some of the lowest prices require an additional purchase. In a backtest the low end was harder to predict than the average.

#Thanksgiving #DataScience #Statistics #QuantileRegression #SAS #Analytics

## Short version (X / Bluesky / Threads)

🦃 Don't wait for Thanksgiving week to buy your turkey. 22 years of USDA supermarket ad data: frozen-turkey prices bottom out in mid-November and rise ~11% by the holiday. Forecast $1.16/lb around Nov 14 vs $1.27 on Nov 25. Open SAS-compatible code on Jenner Analytics: https://github.com/JennerAnalytics/sas-compatible-examples/tree/main/thanksgiving

## Follow-up post (loss-leader card)

🦃 In 2025, US supermarkets advertised frozen turkeys 44% below the wholesale price.

Wholesale frozen hens cost $1.72/lb in the weeks before Thanksgiving 2025. The average advertised supermarket price was $0.97. In 2024, when wholesale fell to $0.96, the advertised price was $0.95. Retailers price the turkey to fill the cart, not to cover the bird.

This year wholesale is about $1.80/lb and the latest advertised average is $1.19.

Data: USDA Agricultural Marketing Service. Analysis in SAS-compatible code on Jenner Analytics: https://github.com/JennerAnalytics/sas-compatible-examples/tree/main/thanksgiving

## Alt text

- turkey_linkedin_1200x627.png: Line chart of US advertised supermarket prices for frozen whole turkeys, October to Thanksgiving 2026. Weekly observed prices between $1.19 and $1.30 per lb, then a forecast that bottoms out at $1.16 around Nov 14 and rises to $1.27 by Nov 25, with a widening 95% prediction band.
- turkey_season_curve_1080x1080.png: Curve of the typical frozen-turkey price season relative to its low: about 11% above the low in late October, lowest in mid-November, rising to about 11% above the low on Thanksgiving.
- turkey_cost_of_waiting_1080x1350.png: Waiting until the last minute costs about $1.72 on a 16-lb frozen turkey; 79% chance that this week's advertised price beats Thanksgiving week's.
- turkey_loss_leader_1080x1080.png: Paired bars for 2022 to 2025 comparing wholesale and supermarket advertised prices per lb: $1.75 vs $0.98, $1.02 vs $1.11, $0.96 vs $0.95, $1.72 vs $0.97.
- turkey_deals_linkedin_1200x627.png: Line chart of frozen turkey ad prices from mid-October to Thanksgiving 2026. The best deals fall from $0.68 to $0.24 per lb by November 10 and stay flat; the typical cheapest ad falls from $1.02 to $0.35; the regional average stays near $1.00 to $1.16.
- turkey_deals_by_week_1080x1080.png: Bar chart of the share of US regions with a turkey advertised at $0.50 per lb or less, by ad week: 0%, 5%, 16%, 48%, 86%, 91%, and 81% in Thanksgiving week.
- turkey_deals_map_1200x627.png: US map coloured by region showing the lowest advertised frozen turkey price in the ad week of 7-13 November 2026: Southeast $0.24, Northeast $0.29, Midwest $0.35, South Central $0.48, Southwest $0.49, Northwest $0.58, Alaska $0.58, Hawaii $0.99.

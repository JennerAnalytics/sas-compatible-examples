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

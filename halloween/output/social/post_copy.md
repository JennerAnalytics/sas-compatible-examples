# Post copy

## LinkedIn (use with pumpkin_linkedin_1200x627.png, or as a carousel with all three cards)

🎃 When is the best day to buy a Halloween pumpkin? We asked 16 years of USDA data.

Conventional wisdom says to wait: pumpkins get cheaper as Halloween approaches. The supermarket ad data say the opposite.

📉 Advertised pumpkin prices typically bottom out in mid-October.
📈 Then they climb, to about 24% above the low by Halloween, as stores stop featuring pumpkins.
💸 The latest USDA week (Oct 17-23) came in at $5.54, up from $5.36, just as our model expected. Forecast: about $5.84 on Tue Oct 27 vs. $6.38 on Oct 31. Buying by Oct 30 beat waiting for Halloween in 72% of 20,000 simulated price paths.

Two more findings for the economists:
• Weeks with more "pumpkin patch" Google searches have *lower* advertised prices: pumpkins work as a traffic driver at peak demand.
• Daily wholesale pumpkin prices and the size of the US harvest didn't help predict supermarket ad prices.

The whole pipeline is SAS-compatible code running on Jenner Analytics: PROC IMPORT, SQL, GLM, GAM, UCM state-space and MIXED models, rolling-origin backtests over 10 seasons, 95% prediction intervals and SGPLOT charts. Code and data are open source (MIT): https://github.com/JennerAnalytics/sas-compatible-examples/tree/main/halloween

Caveats: these are national average advertised supermarket prices, not farm-stand prices or checkout receipts, and nobody can see the unadvertised Oct 31 clearance bin.

#Halloween #DataScience #Econometrics #Forecasting #SAS #Analytics

## Short version (X / Bluesky / Threads)

🎃 Don't wait for a Halloween pumpkin bargain. 16 years of USDA supermarket ad data: prices bottom out mid-October and rise ~24% into Halloween. Latest week $5.54 (up from $5.36); forecast $5.84 Tue Oct 27 vs $6.38 Oct 31. Open SAS-compatible code on Jenner Analytics: https://github.com/JennerAnalytics/sas-compatible-examples/tree/main/halloween

## Alt text

- pumpkin_linkedin_1200x627.png: Line chart of October 2026 US advertised supermarket pumpkin prices. Weekly observed prices around $5.20-$5.60 in October, $5.54 for Oct 17-23, then a forecast rising from $5.84 on Oct 27 to $6.38 on Oct 31, with a widening 95% prediction band.
- pumpkin_season_curve_1080x1080.png: Curve of the typical pumpkin price season relative to its low: about 11% above the low in mid-September, lowest around Oct 11, rising to about 24% above the low on Oct 31.
- pumpkin_cost_of_waiting_1080x1350.png: Waiting for a Halloween bargain costs about $0.54 per pumpkin; 72% chance that buying by Oct 30 beats waiting until Halloween.

# Data inventory

Retrieved 21 October 2026. All sources are free and public. Raw files sit unmodified in `data/raw/`.

| Source | File | Frequency | Coverage | Unit | Rows |
|---|---|---|---|---|---|
| USDA AMS, *Weekly Grocery Store Specialty Crops Feature Activity* (FVWRETAIL, slug 3324), section "Report by Region", commodity Pumpkins | `usda_ams_fvwretail_pumpkins_by_region.csv` | Weekly (ad week Sat-Fri) | Aug 2011 to week of 10 Oct 2026; 9 regions incl. National | $ each or $ per lb, by product | 4,158 |
| USDA AMS terminal-market vegetable price reports (FV020) for 11 markets: Asheville, Atlanta, Baltimore, Boston, Chicago, Columbia, Detroit, Los Angeles, Miami, New York, Philadelphia | `usda_ams_terminal_pumpkins_daily.csv` | Daily (market days) | 1 Sep - 15 Nov, 2011-2026 | $ per package (bins, cartons) | 58,767 |
| USDA NASS Quick Stats, national annual survey statistics, commodity PUMPKINS | `usda_nass_pumpkins_national_annual.csv` | Annual | Production/acreage 2000-2025; fresh-market split 2016-2025 | cwt, acres, $/cwt | 248 |
| Google Trends, US web search interest, "pumpkin patch" and "pumpkins" | `google_trends_pumpkin_daily_by_season.csv` | Daily | 15 Aug - 5 Nov each year 2011-2025; 15 Aug - 20 Oct 2026 | Index 0-100, normalized within each season | 2,624 |

Weather (NOAA) was not used. NOAA's Climate Data Online API needs a registered token, and weather was optional in the brief.

## Target series

National, variety `N/A` (generic carving pumpkin), sold **each**, conventional (non-organic). It is the only pumpkin product reported every season since 2011.

- 141 national weekly observations; 131 remain after excluding weeks outside the late-Aug to early-Nov window (8 weeks) and weeks with fewer than 100 advertising stores (2 weeks, 2016-10-29 and 2019-10-26, with 5 and 66 stores).
- 6 to 10 weeks per season. 2013 is missing the weeks of 28 Sep to 12 Oct.
- 2026: 6 weeks observed (5 Sep to 16 Oct). The week beginning 17 Oct had not been published at the cutoff.
- No duplicate (week, region, product) keys. No missing weighted-average prices.

## Product definitions and changes

- Per-pound and per-each prices are never mixed. Pie, miniature and organic pumpkins are excluded from the target.
- In 2023 USDA started reporting size-marked carving pumpkins separately ("Marked Small/Medium/Large/Extra Large"). The generic `N/A` series continues, but its composition may have changed. Season fixed effects absorb level shifts like this. The seasonal shape is assumed stable.
- The national `price_range` is reported as `0.00-0.00`, so only the store-weighted average is usable nationally.
- USDA republished all 2023 reports on 2024-01-26, so `published_date` is not the original release date. The backtests treat a week as known from its `report_end_date` (the Friday the ad week ends, when USDA normally releases it).

## Wholesale

Howden-type carving pumpkins in 36-inch bins are the most common quote (15,155 rows). The daily national index is the geometric mean, across markets, of each market's mean (low+high)/2 quote. Markets quoting per day fell from about 5-6 (2011-2020) to 2-3 (2024-2026).

## Supply

NASS publishes the 2026 crop in early 2027. So supply can explain past seasons but cannot be used to forecast 2026.

## Search interest

Google Trends rescales every query window to its own peak, so the index measures the shape of interest within a season, not demand quantity, and levels are not comparable across seasons.

## Known limitations

- **Advertised, not transaction prices.** The series is the store-weighted average price in grocery-store ads, not the price paid at checkout or at farm stands and pumpkin patches.
- **Weekly, not daily.** Ads run for a week. No daily retail price is observed, so daily accuracy cannot be validated independently.
- **Late-October thinning.** Retailers largely stop advertising pumpkins in the last week before Halloween. Final-week observations rest on 100-500 stores versus 2,000-11,000 in early October. Unadvertised in-store markdowns are not observed.
- **Wholesale and retail differ.** Terminal-market quotes are wholesale prices for bins (several hundred pounds), not consumer prices.

## Licensing and attribution

- USDA AMS and NASS data are US federal government works in the public domain. Cite "USDA Agricultural Marketing Service, Market News" and "USDA National Agricultural Statistics Service, Quick Stats".
- Google Trends data may be published with attribution: "Source: Google Trends (www.google.com/trends)".

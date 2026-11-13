# Data inventory

Retrieved 12 November 2026 from USDA Agricultural Marketing Service (AMS) Market News, <https://mymarketnews.ams.usda.gov/public_data>. All sources are free and public. The files in `data/raw/` hold the fields used here, unmodified in value.

| Source | File | Frequency | Coverage | Unit | Rows |
|---|---|---|---|---|---|
| USDA AMS, *Weekly Grocery Store Turkey Feature Activity* (report 2867), section "Report Details", section Whole, region National, conventional birds | `usda_ams_turkey_whole_national.csv` | Weekly (ad week, normally Saturday to Friday) | Ad weeks beginning 10 Sep to 20 Dec, 2005 to 2025; 2026 to the week of 31 Oct | $ per lb | 479 |
| Same report, six contiguous regions (Midwest, Northeast, Northwest, South Central, Southeast, Southwest), frozen, conventional, under 16 lb | `usda_ams_turkey_frozen_by_region.csv` | Weekly | Ad weeks beginning 20 Oct to 28 Nov, 2015 to 2026 | $ per lb | 357 |
| USDA AMS, *Weekly National Turkey Report* (report 3647), whole young hens 8-16 lb, frozen, conventional, U.S. Grade A, domestic, FOB | `usda_ams_turkey_wholesale_frozen_hens.csv` | Weekly | September to mid-December, 2022 to 2026 | cents per lb | 75 |

USDA MyMarketNews does not serve these tables to scripted clients, so they were saved from the Public Data page in a browser.

## Columns

`usda_ams_turkey_whole_national.csv`: one row per ad week and condition (Fresh or Frozen). `under16_*` and `over16_*` are USDA's two size classes, "Whole Turkey < 16 Lbs" and "Whole Turkey > 16 Lbs": store-weighted average advertised price, lowest and highest advertised price (reported from 2024), and the number of stores advertising.

`usda_ams_turkey_frozen_by_region.csv`: `report_begin_date` (yyyymmdd), region code, store-weighted average price and stores advertising.

`usda_ams_turkey_wholesale_frozen_hens.csv`: `report_begin_date` (yyyymmdd, a Monday), weighted average, low and high price in cents per lb, and volume traded. A week with two lines is averaged by volume.

## Target series

National, conventional, **frozen whole turkey**, $ per lb. The two size classes are combined into one store-weighted average: their prices differ by more than 5 cents in under 9% of weeks, and by 1.3 cents on average.

- Season window: ad weeks whose midpoint falls 0 to 47 days before Thanksgiving, roughly the second week of October through Thanksgiving week.
- Weeks with fewer than 500 advertising stores are excluded. These are early-October weeks, when a handful of ads set the national average.
- 133 weekly observations over 22 seasons, 5 to 7 per season. In 2026, four weeks were observed at the cutoff (10 Oct to 6 Nov). The week of 7 to 13 November had not been published.
- No duplicate (week, condition) keys.

## Known limitations

- **Advertised, not transaction prices.** The series is the store-weighted average price in grocery-store ads. Loyalty-card prices, coupons and "free turkey with purchase" offers are not included.
- **Weekly, not daily.** Ads run for a week. No daily retail price is observed, so the daily curve is modelled.
- **Store counts changed.** Before 2015 USDA rounded store counts to the nearest ten, and the store sample has changed over 22 years. Season effects absorb level shifts. The seasonal shape is assumed stable.
- **Thin weeks.** In mid-October 500 to 3,000 stores advertise frozen turkeys, against 20,000 to 35,000 in the two weeks before Thanksgiving week.
- **Wholesale history is short.** The wholesale series starts in 2022, so the retail-wholesale comparison covers four completed seasons.
- **Regional file.** Regions were redefined in 2015; the regional model uses 2015 onward and the under-16 lb class.

## Licensing and attribution

USDA AMS data are US federal government works in the public domain. Cite "USDA Agricultural Marketing Service, Market News".

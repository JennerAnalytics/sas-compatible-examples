#!/bin/sh
# Downloads USDA NASS Quick Stats national annual pumpkin statistics (survey program) to data/raw.
set -e
cd "$(dirname "$0")/.."
Q='source_desc=SURVEY&commodity_desc=PUMPKINS&agg_level_desc=NATIONAL&freq_desc=ANNUAL'
UUID=$(curl -sS -X POST https://quickstats.nass.usda.gov/uuid/encode --data "$Q" | tr -d '"')
curl -sS "https://quickstats.nass.usda.gov/data/spreadsheet/$UUID.csv" -o data/raw/usda_nass_pumpkins_national_annual.csv
wc -l data/raw/usda_nass_pumpkins_national_annual.csv

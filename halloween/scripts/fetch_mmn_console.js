// USDA AMS MyMarketNews blocks non-browser HTTP clients. Open
// https://mymarketnews.ams.usda.gov/public_data in a browser, paste this into the
// developer console, and save the two CSV strings it copies (window.pkcsv, window.whcsv)
// to data/raw/ with the file names below.
//   usda_ams_fvwretail_pumpkins_by_region.csv  <- window.pkcsv
//   usda_ams_terminal_pumpkins_daily.csv       <- window.whcsv
(async () => {
  const iso = s => { const m = (s || '').match(/(\d\d)\/(\d\d)\/(\d{4})/); return m ? `${m[3]}-${m[1]}-${m[2]}` : ''; };
  const q = v => { v = v == null ? '' : String(v); return /[",\n]/.test(v) ? '"' + v.replace(/"/g, '""').replace(/\n/g, ' ') + '"' : v; };
  const get = async (slug, section, from, to) =>
    (await (await fetch(`/public_data/ajax-search-data-by-report-section/${slug}/${encodeURIComponent(section)}?q=commodity=Pumpkins;report_begin_date=${from}:${to}`)).json()).results || [];

  // Retail: FVWRETAIL (slug 3324), "Report by Region", all years.
  const retail = [];
  for (let y = 2007; y <= 2026; y++) retail.push(...await get(3324, 'Report by Region', `01/01/${y}`, `12/31/${y}`));
  window.pkcsv = 'report_begin_date,report_end_date,published_date,region,variety,unit,organic,price_range,stores_with_ads,wtd_avg_price,pct_marked_local,final_ind\n' +
    retail.map(x => [iso(x.report_begin_date), iso(x.report_end_date), iso(x.published_date), x.region, x.variety, x.size, x.organic,
      x.price_Range, x.stores_with_Ads, x.wtd_Avg_Price, x['%_Marked_Local'], x.final_ind].map(q).join(',')).sort().join('\n') + '\n';

  // Wholesale: terminal-market vegetable reports (FV020), Sep 1 - Nov 15 each year.
  const terminals = [3914, 2278, 2282, 2286, 2291, 2295, 2303, 2307, 2311, 2315, 2319];
  const wh = [];
  for (const slug of terminals) for (let y = 2011; y <= 2026; y++) wh.push(...await get(slug, 'Report Details', `09/01/${y}`, `11/15/${y}`));
  window.whcsv = 'report_date,market,slug_name,origin,package,variety,item_size,properties,organic,low_price,high_price,mostly_low_price,mostly_high_price,market_tone\n' +
    wh.map(x => [iso(x.report_date), x.market_location_city, x.slug_name, x.origin, x.package, x.variety, x.item_size, x.properties, x.organic,
      x.low_price, x.high_price, x.mostly_low_price, x.mostly_high_price, x.market_tone_comments].map(q).join(',')).sort().join('\n') + '\n';
  console.log('retail rows', retail.length, 'wholesale rows', wh.length);
})();

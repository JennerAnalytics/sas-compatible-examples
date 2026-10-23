// Google Trends daily search interest, one window per season (Aug 15 - Nov 5), US.
// Open https://trends.google.com/trends/explore?geo=US&q=pumpkin%20patch, paste into the
// developer console, and save window.gt to data/raw/google_trends_pumpkin_daily_by_season.csv.
// Each window is normalised by Google to its own maximum (100), so levels are comparable
// within a season only.
(async () => {
  async function series(term, from, to) {
    const req = { comparisonItem: [{ keyword: term, geo: 'US', time: `${from} ${to}` }], category: 0, property: '' };
    const t = await (await fetch('/trends/api/explore?hl=en-US&tz=420&req=' + encodeURIComponent(JSON.stringify(req)))).text();
    const w = JSON.parse(t.slice(t.indexOf('{'))).widgets.find(w => w.id === 'TIMESERIES');
    const t2 = await (await fetch('/trends/api/widgetdata/multiline?hl=en-US&tz=420&req=' + encodeURIComponent(JSON.stringify(w.request)) + '&token=' + w.token)).text();
    return JSON.parse(t2.slice(t2.indexOf('{'))).default.timelineData.map(x => [new Date(+x.time * 1000).toISOString().slice(0, 10), x.value[0], x.isPartial ? 1 : 0]);
  }
  const out = ['term,date,index,is_partial,window_start,window_end'];
  for (const term of ['pumpkin patch', 'pumpkins']) for (let y = 2011; y <= 2026; y++) {
    const a = `${y}-08-15`, b = y === 2026 ? '2026-10-20' : `${y}-11-05`;
    (await series(term, a, b)).forEach(x => out.push([term, x[0], x[1], x[2], a, b].join(',')));
    await new Promise(r => setTimeout(r, 1500));
  }
  window.gt = out.join('\n') + '\n';
  console.log('rows', out.length - 1);
})();

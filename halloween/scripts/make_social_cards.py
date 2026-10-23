"""Render social-media cards (PNG) from the Jenner forecast outputs.

Reads output/forecasts/pumpkin_price_forecast_oct2026.csv, output/tables/season_profile.csv
and output/tables/cheapest_week.csv, writes HTML cards to output/social/ and screenshots
them with headless Chrome.
"""

import csv
import datetime as dt
import pathlib
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
OUT = ROOT / "output" / "social"
CHROME = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

INK = "#1F2433"
MUTED = "#5B6170"
FAINT = "#9AA0AB"
GRID = "#E6E3DD"
BG = "#FBF7F1"
ORANGE = "#D9661F"
BAND = "#F4C49B"
NAVY = "#2B3A55"


def read_csv(path):
    with open(path, newline="") as f:
        return [{k.lower(): v for k, v in row.items()} for row in csv.DictReader(f)]


def fnum(v):
    return float(v) if v not in ("", ".", None) else None


def money(v):
    return f"${v:.2f}"


def svg_forecast(rows, w, h, pad):
    """October chart: observed weekly ad prices, expected price, 95% band."""
    days = [dt.date.fromisoformat(r["date"]) for r in rows]
    lo = [fnum(r["prediction_lower_95"]) for r in rows]
    hi = [fnum(r["prediction_upper_95"]) for r in rows]
    mid = [fnum(r["predicted_price"]) for r in rows]
    obs = [fnum(r["observed_price"]) for r in rows]
    status = [r["observation_status"] for r in rows]
    ymin, ymax = 3.5, 8.5
    l, t, r_, b = pad

    def x(i):
        return l + (w - l - r_) * i / (len(rows) - 1)

    def y(v):
        return t + (h - t - b) * (ymax - v) / (ymax - ymin)

    parts = []
    for v in range(4, 9):
        parts.append(f'<line x1="{l}" x2="{w - r_}" y1="{y(v):.1f}" y2="{y(v):.1f}" stroke="{GRID}" stroke-width="1"/>')
        parts.append(f'<text x="{l - 10}" y="{y(v) + 5:.1f}" text-anchor="end" font-size="15" fill="{FAINT}">${v}</text>')
    fc = [i for i, s in enumerate(status) if s == "forecast"]
    start = fc[0] - 1
    band = " ".join(f"{x(i):.1f},{y(hi[i]):.1f}" for i in range(start, len(rows)))
    band += " " + " ".join(f"{x(i):.1f},{y(lo[i]):.1f}" for i in reversed(range(start, len(rows))))
    parts.append(f'<polygon points="{band}" fill="{BAND}" opacity="0.55"/>')
    fit = " ".join(f"{x(i):.1f},{y(mid[i]):.1f}" for i in range(0, start + 1))
    parts.append(f'<polyline points="{fit}" fill="none" stroke="{FAINT}" stroke-width="2" stroke-dasharray="5 5"/>')
    line = " ".join(f"{x(i):.1f},{y(mid[i]):.1f}" for i in range(start, len(rows)))
    parts.append(f'<polyline points="{line}" fill="none" stroke="{ORANGE}" stroke-width="4" stroke-linecap="round"/>')
    runs = []
    for i, v in enumerate(obs):
        if v is None:
            continue
        if runs and runs[-1][2] == v and runs[-1][1] == i - 1:
            runs[-1][1] = i
        else:
            runs.append([i, i, v])
    for a, z, v in runs:
        parts.append(f'<line x1="{x(a) - 6:.1f}" x2="{x(z) + 6:.1f}" y1="{y(v):.1f}" y2="{y(v):.1f}" stroke="{NAVY}" stroke-width="5" stroke-linecap="round"/>')
    cut = start
    parts.append(f'<line x1="{x(cut):.1f}" x2="{x(cut):.1f}" y1="{t}" y2="{h - b}" stroke="{FAINT}" stroke-width="1.5" stroke-dasharray="4 4"/>')
    parts.append(f'<text x="{x(cut) - 8:.1f}" y="{t + 16}" text-anchor="end" font-size="14" fill="{MUTED}">today</text>')
    best = min(fc, key=lambda i: mid[i])
    last = len(rows) - 1
    parts.append(f'<circle cx="{x(best):.1f}" cy="{y(mid[best]):.1f}" r="8" fill="{ORANGE}" stroke="{BG}" stroke-width="3"/>')
    parts.append(f'<text x="{x(best) + 4:.1f}" y="{y(mid[best]) + 34:.1f}" font-size="17" font-weight="700" fill="{INK}">{days[best]:%b} {days[best].day}: {money(mid[best])}</text>')
    parts.append(f'<circle cx="{x(last):.1f}" cy="{y(mid[last]):.1f}" r="6" fill="{ORANGE}"/>')
    parts.append(f'<text x="{x(last) - 10:.1f}" y="{y(mid[last]) - 16:.1f}" text-anchor="end" font-size="17" font-weight="700" fill="{INK}">Oct 31: {money(mid[last])}</text>')
    for i, d in enumerate(days):
        if d.day in (1, 8, 15, 22, 31):
            parts.append(f'<text x="{x(i):.1f}" y="{h - b + 26}" text-anchor="middle" font-size="15" fill="{FAINT}">Oct {d.day}</text>')
    legend_y = h - 8
    parts.append(
        f'<line x1="{l}" x2="{l + 26}" y1="{legend_y - 5}" y2="{legend_y - 5}" stroke="{NAVY}" stroke-width="5" stroke-linecap="round"/>'
        f'<text x="{l + 34}" y="{legend_y}" font-size="14" fill="{MUTED}">Weekly advertised average (USDA)</text>'
        f'<line x1="{l + 290}" x2="{l + 316}" y1="{legend_y - 5}" y2="{legend_y - 5}" stroke="{ORANGE}" stroke-width="4" stroke-linecap="round"/>'
        f'<text x="{l + 324}" y="{legend_y}" font-size="14" fill="{MUTED}">Forecast</text>'
        f'<rect x="{l + 404}" y="{legend_y - 12}" width="22" height="13" fill="{BAND}" opacity="0.8"/>'
        f'<text x="{l + 434}" y="{legend_y}" font-size="14" fill="{MUTED}">95% prediction band</text>'
    )
    return f'<svg width="{w}" height="{h}" viewBox="0 0 {w} {h}" xmlns="http://www.w3.org/2000/svg" font-family="Helvetica, Arial, sans-serif">{"".join(parts)}</svg>'


def svg_profile(rows, w, h, pad):
    """Typical season: relative advertised price by date, Sep 6 to Oct 31."""
    dates = [dt.date.fromisoformat(r["date"]) for r in rows]
    rel = [float(r["relative_price"]) for r in rows]
    l, t, r_, b = pad
    ymin, ymax = 0.97, 1.28

    def x(i):
        return l + (w - l - r_) * i / (len(rows) - 1)

    def y(v):
        return t + (h - t - b) * (ymax - v) / (ymax - ymin)

    parts = []
    for v, lab in ((1.0, "low"), (1.1, "+10%"), (1.2, "+20%")):
        parts.append(f'<line x1="{l}" x2="{w - r_}" y1="{y(v):.1f}" y2="{y(v):.1f}" stroke="{GRID}" stroke-width="1.5"/>')
        parts.append(f'<text x="{l - 12}" y="{y(v) + 6:.1f}" text-anchor="end" font-size="22" fill="{FAINT}">{lab}</text>')
    area = f"{x(0):.1f},{y(ymin):.1f} " + " ".join(f"{x(i):.1f},{y(v):.1f}" for i, v in enumerate(rel)) + f" {x(len(rel) - 1):.1f},{y(ymin):.1f}"
    parts.append(f'<polygon points="{area}" fill="{BAND}" opacity="0.45"/>')
    line = " ".join(f"{x(i):.1f},{y(v):.1f}" for i, v in enumerate(rel))
    parts.append(f'<polyline points="{line}" fill="none" stroke="{ORANGE}" stroke-width="6" stroke-linecap="round" stroke-linejoin="round"/>')
    lo_i = min(range(len(rel)), key=lambda i: rel[i])
    hi_sep = max((i for i, d in enumerate(dates) if d.month == 9), key=lambda i: rel[i])
    last = len(rel) - 1
    notes = [
        (hi_sep, f"Mid-September: +{(rel[hi_sep] - 1) * 100:.0f}%", -26, "middle"),
        (lo_i, f"The low: around {dates[lo_i]:%b} {dates[lo_i].day}", 44, "end"),
        (last, f"Halloween: +{(rel[last] - 1) * 100:.0f}%", -26, "end"),
    ]
    for i, text, dy, anchor in notes:
        parts.append(f'<circle cx="{x(i):.1f}" cy="{y(rel[i]):.1f}" r="10" fill="{ORANGE}" stroke="{BG}" stroke-width="4"/>')
        tx = x(i) - 18 if anchor == "end" and dy > 0 else x(i)
        parts.append(f'<text x="{tx:.1f}" y="{y(rel[i]) + dy:.1f}" text-anchor="{anchor}" font-size="26" font-weight="700" fill="{INK}">{text}</text>')
    for i, d in enumerate(dates):
        if (d.month, d.day) in ((9, 15), (10, 1), (10, 15), (10, 31)):
            parts.append(f'<text x="{x(i):.1f}" y="{h - b + 36}" text-anchor="middle" font-size="22" fill="{FAINT}">{d:%b} {d.day}</text>')
    return f'<svg width="{w}" height="{h}" viewBox="0 0 {w} {h}" xmlns="http://www.w3.org/2000/svg" font-family="Helvetica, Arial, sans-serif">{"".join(parts)}</svg>'


PAGE = """<!doctype html><html><head><meta charset="utf-8"><style>
html,body{{margin:0;padding:0;background:{bg};}}
.card{{width:{w}px;height:{h}px;box-sizing:border-box;padding:{p}px;background:{bg};color:{ink};
font-family:Helvetica,Arial,sans-serif;display:flex;flex-direction:column;position:relative;overflow:hidden}}
.kicker{{font-size:{ks}px;letter-spacing:.14em;text-transform:uppercase;color:{orange};font-weight:700}}
h1{{font-size:{hs}px;line-height:1.05;margin:.25em 0 .2em;font-weight:800;letter-spacing:-.01em}}
.sub{{font-size:{ss}px;line-height:1.35;color:{muted};margin:0}}
.foot{{margin-top:auto;font-size:{fs}px;color:{faint};line-height:1.4;display:flex;justify-content:space-between;gap:24px;align-items:flex-end}}
.brand{{color:{ink};font-weight:700;white-space:nowrap}}
.big{{font-size:{bs}px;font-weight:800;color:{orange};line-height:1;letter-spacing:-.02em}}
.stat{{font-size:{ss}px;color:{ink};line-height:1.35}}
.emoji{{position:absolute;right:{p}px;top:{p}px;font-size:{es}px;line-height:1}}
</style></head><body><div class="card">{body}</div></body></html>"""


def page(w, h, body, p=56, ks=20, hs=58, ss=26, fs=17, bs=200, es=72):
    return PAGE.format(bg=BG, ink=INK, muted=MUTED, faint=FAINT, orange=ORANGE, w=w, h=h, p=p,
                       ks=ks, hs=hs, ss=ss, fs=fs, bs=bs, es=es, body=body)


FOOT = ('<div class="foot"><div>{note}<br>Data: USDA Agricultural Marketing Service; national average advertised '
        'supermarket price, carving pumpkins sold each.</div><div class="brand">Forecast: Jenner Analytics</div></div>')


def main():
    fc = read_csv(ROOT / "output" / "forecasts" / "pumpkin_price_forecast_oct2026.csv")
    prof = read_csv(ROOT / "output" / "tables" / "season_profile.csv")
    weeks = read_csv(ROOT / "output" / "tables" / "cheapest_week.csv")
    future = [r for r in fc if r["observation_status"] == "forecast"]
    best = min(future, key=lambda r: float(r["predicted_price"]))
    last = fc[-1]
    bd = dt.date.fromisoformat(best["date"])
    best_p, last_p = float(best["predicted_price"]), float(last["predicted_price"])
    first_week = weeks[0]
    pct_first = float(first_week["percent"])
    wk = dt.date.fromisoformat(first_week["ad_week"])
    wk_end = wk + dt.timedelta(days=6)
    OUT.mkdir(parents=True, exist_ok=True)

    cards = {}
    cards["pumpkin_linkedin_1200x627"] = page(1200, 627, (
        '<div class="kicker">The Economics of Halloween</div>'
        '<h1 style="font-size:50px">Buy your pumpkin this weekend.</h1>'
        '<p class="sub" style="font-size:22px">Supermarket pumpkin prices typically bottom out in mid-October. '
        f'From here, expected prices rise into Halloween: {money(best_p)} on {bd:%b} {bd.day}, {money(last_p)} on Oct 31.</p>'
        + svg_forecast(fc, 1088, 330, (56, 26, 24, 62))
        + FOOT.format(note="Advertised prices, not checkout prices. Ads run weekly, so daily values are modelled.")
    ), p=56, fs=14, es=64)

    cards["pumpkin_season_curve_1080x1080"] = page(1080, 1080, (
        '<div class="emoji">🎃</div>'
        '<div class="kicker">Myth vs. data</div>'
        '<h1>Pumpkins don\'t get<br>cheaper as Halloween<br>gets closer.</h1>'
        '<p class="sub">16 seasons of USDA supermarket ad prices (2011&ndash;2026): the typical season, relative to its low.</p>'
        + svg_profile(prof, 968, 560, (110, 70, 30, 60))
        + FOOT.format(note="Fitted seasonal pattern; late-October values rest on fewer ads.")
    ), p=56, hs=66, ss=26, fs=17)

    cards["pumpkin_cost_of_waiting_1080x1350"] = page(1080, 1350, (
        '<div class="emoji">🎃</div>'
        '<div class="kicker">When should you buy a pumpkin?</div>'
        '<h1 style="font-size:64px">Waiting for a Halloween<br>bargain costs you about</h1>'
        f'<div class="big" style="margin:28px 0 8px">{money(last_p - best_p)}</div>'
        '<p class="stat">extra per pumpkin, on average: the expected advertised price on Oct 31 versus this weekend.</p>'
        '<div style="height:44px"></div>'
        f'<div class="big" style="font-size:150px">{pct_first:.0f}%</div>'
        f'<p class="stat">chance the {wk:%b} {wk.day}&ndash;{wk_end:%b} {wk_end.day} ad week is cheaper than Halloween itself '
        '(20,000 simulated price paths).</p>'
        '<div style="height:36px"></div>'
        '<p class="sub">Prices peak in mid-September, bottom out in mid-October, and climb again in the last week, '
        'when stores mostly stop advertising pumpkins.</p>'
        + FOOT.format(note="Forecast range on Oct 31: "
                      f"{money(float(last['prediction_lower_95']))}&ndash;{money(float(last['prediction_upper_95']))} (95%).")
    ), p=64, ss=30, fs=17)

    for name, html in cards.items():
        src = OUT / f"{name}.html"
        src.write_text(html)
        w, h = (int(v) for v in name.rsplit("_", 1)[1].split("x"))
        png = OUT / f"{name}.png"
        subprocess.run([CHROME, "--headless=new", "--disable-gpu", "--hide-scrollbars",
                        f"--window-size={w},{h}", "--force-device-scale-factor=2",
                        f"--screenshot={png}", src.as_uri()], check=True, capture_output=True)
        print(png)
    return 0


if __name__ == "__main__":
    sys.exit(main())

#!/usr/bin/env python3
"""Clinical-trial figure conformance harness — single-file edition.

Enforces the Clinical Trial Figure Specification (Jenner_CRO_Graph_spec.md)
on a graphics engine's SVG output, with optional raster (PNG) visual-regression
and CVD simulation.

THREE WAYS TO USE THIS ONE FILE
--------------------------------
1. As a CLI (point it at real SVG figures; exits non-zero on any failure):
       python clinical_figure_conformance.py fig1.svg fig2.svg
       python clinical_figure_conformance.py fig.svg --json      # machine-readable
       python clinical_figure_conformance.py                     # self-test demo

2. As a pytest suite:
       pytest clinical_figure_conformance.py -q

3. As a library (import the checks):
       from clinical_figure_conformance import parse_svg, run_all

DEPENDENCIES
------------
Core structural conformance: standard library only.
Raster regression + CVD simulation: numpy + Pillow (optional; tests skip if absent).

THE SVG CONTRACT THE ENGINE MUST EMIT
--------------------------------------
Roles on `class`; metadata on `data-*`. Example:

  <svg data-figure-class="km_risk" data-design-width-in="9.0"
       data-design-height-in="6.0" data-dpi="300">
    <path class="clin-series" data-group="High Dose" stroke="#D55E00"
          stroke-width="2" stroke-dasharray="2,2" data-marker="triangle"/>
    <path class="clin-axis"    stroke="#000000" stroke-width="1"/>
    <line class="clin-refline" stroke="#000000" stroke-dasharray="3,3"/>
    <line class="clin-gridline" stroke="#E0E0E0"/>          <!-- off by default -->
    <text class="clin-title" font-family="Arial" font-size="10" fill="#000000"/>
  </svg>

Text roles: clin-title, clin-axis-label, clin-tick, clin-legend, clin-data,
clin-footnote, clin-annotation.
"""

from __future__ import annotations

import re
import sys
import xml.etree.ElementTree as ET
from dataclasses import dataclass, field
from itertools import combinations
from pathlib import Path

# =========================================================================== #
# SPEC CONSTANTS                                                               #
# =========================================================================== #

# Okabe-Ito / Wong CVD-safe palette.
# Slot 0 (black) = control / single series / all axes & text.
# Slot 7 (yellow, #F0E442) is excluded from line/marker rotation on white
# backgrounds — near-invisible at contrast ratio 1.07:1 against white.
# The active rotation is slots 0-6 only.
PALETTE: tuple[str, ...] = (
    "#000000",  # 0 Black      — control / axes
    "#0072B2",  # 1 Blue       — arm 2
    "#D55E00",  # 2 Vermillion — arm 3
    "#009E73",  # 3 Bluish green — arm 4
    "#CC79A7",  # 4 Reddish purple — arm 5
    "#E69F00",  # 5 Orange     — arm 6
    "#56B4E9",  # 6 Sky blue   — arm 7
    "#F0E442",  # 7 Yellow     — dark-background fills ONLY; excluded from rotation
)
PALETTE_SET = frozenset(PALETTE)
BLACK = "#000000"
YELLOW = "#F0E442"          # excluded from line/marker rotation on white backgrounds

DIMENSION_TOLERANCE_IN = 0.06
MIN_DPI = 300
MAX_REFLINE_WIDTH_PX = 1.5
GRIDLINE_FAINT_COLORS = frozenset({"#E0E0E0", "#E5E5E5", "#EEEEEE"})
ALLOW_GRIDLINES_DEFAULT = False
SSIM_PASS_THRESHOLD = 0.995
GRAYSCALE_LUMINANCE_TOL = 0.12
ALLOWED_FONT_FAMILIES = frozenset({"arial", "helvetica", "albany amt"})


@dataclass(frozen=True)
class DimensionClass:
    name: str
    width_in: float
    height_in: float
    height_variable: bool = False
    min_height_in: float = 0.0


DIMENSION_CLASSES: dict[str, DimensionClass] = {
    d.name: d for d in (
        DimensionClass("general",  9.0, 5.56),
        DimensionClass("compact",  6.4, 4.0),
        DimensionClass("portrait", 6.5, 8.0),
        DimensionClass("km_risk",  9.0, 6.0),
        DimensionClass("forest",   9.0, 0.0, height_variable=True, min_height_in=3.0),
    )
}

FONT_RULES: dict[str, tuple[float, float]] = {  # role -> (min_pt, max_pt)
    "clin-title":       (10.0, 11.0),
    "clin-axis-label":  (9.0,  10.0),
    "clin-tick":        (8.0,   9.0),
    "clin-legend":      (8.0,   9.0),
    "clin-data":        (7.0,   8.0),
    "clin-footnote":    (7.0,   8.0),
    "clin-annotation":  (7.0,   8.0),
}

# =========================================================================== #
# SVG MODEL                                                                    #
# =========================================================================== #
_HEX_RE = re.compile(r"^#?[0-9a-fA-F]{6}$")


def _norm_color(value: str | None) -> str | None:
    if not value:
        return None
    v = value.strip()
    if v.lower() in {"none", "transparent"}:
        return None
    return ("#" + v.lstrip("#")).upper() if _HEX_RE.match(v) else v.upper()


def _norm_dash(value: str | None) -> str:
    if not value or value.strip().lower() in {"none", ""}:
        return "solid"
    parts = re.split(r"[,\s]+", value.strip())
    try:
        nums = [round(float(p), 2) for p in parts if p]
    except ValueError:
        return value.strip().lower()
    return ",".join(str(n) for n in nums) if nums else "solid"


def _size_pt(value: str | None) -> float | None:
    if not value:
        return None
    m = re.match(r"([0-9]*\.?[0-9]+)", value.strip())
    return float(m.group(1)) if m else None


def _family(value: str | None) -> str | None:
    return value.split(",")[0].strip().strip("'\"").lower() if value else None


def _float_attr(el: ET.Element, attr: str) -> float | None:
    raw = el.get(attr)
    if raw is None:
        return None
    try:
        return float(re.sub(r"[a-zA-Z%]+$", "", raw.strip()))
    except ValueError:
        return None


@dataclass(frozen=True)
class Series:
    group: str | None
    stroke: str | None
    dash: str
    marker: str | None
    width: float | None


@dataclass(frozen=True)
class Stroked:
    stroke: str | None
    dash: str
    width: float | None


@dataclass(frozen=True)
class TextRun:
    role: str
    family: str | None
    size_pt: float | None
    fill: str | None


@dataclass
class FigureModel:
    figure_class: str | None
    design_w_in: float | None
    design_h_in: float | None
    dpi: int | None
    series: list[Series] = field(default_factory=list)
    axes: list[Stroked] = field(default_factory=list)
    reflines: list[Stroked] = field(default_factory=list)
    gridlines: list[Stroked] = field(default_factory=list)
    texts: list[TextRun] = field(default_factory=list)


def parse_svg(source: str | Path) -> FigureModel:
    """Parse an SVG string or file path into a FigureModel."""
    if isinstance(source, Path) or (isinstance(source, str) and "<svg" not in source):
        text = Path(source).read_text()
    else:
        text = str(source)

    root = ET.fromstring(text)

    def f(attr: str) -> float | None:
        v = root.get(attr)
        try:
            return float(v) if v is not None else None
        except ValueError:
            return None

    dpi_raw = root.get("data-dpi")
    model = FigureModel(
        figure_class=root.get("data-figure-class"),
        design_w_in=f("data-design-width-in"),
        design_h_in=f("data-design-height-in"),
        dpi=int(float(dpi_raw)) if dpi_raw else None,
    )

    for el in root.iter():
        cls = set((el.get("class") or "").split())
        if "clin-series" in cls:
            model.series.append(Series(
                el.get("data-group"),
                _norm_color(el.get("stroke")),
                _norm_dash(el.get("stroke-dasharray")),
                el.get("data-marker"),
                _float_attr(el, "stroke-width"),
            ))
        elif "clin-axis" in cls:
            model.axes.append(Stroked(
                _norm_color(el.get("stroke")),
                _norm_dash(el.get("stroke-dasharray")),
                _float_attr(el, "stroke-width"),
            ))
        elif "clin-refline" in cls:
            model.reflines.append(Stroked(
                _norm_color(el.get("stroke")),
                _norm_dash(el.get("stroke-dasharray")),
                _float_attr(el, "stroke-width"),
            ))
        elif "clin-gridline" in cls:
            model.gridlines.append(Stroked(
                _norm_color(el.get("stroke")),
                _norm_dash(el.get("stroke-dasharray")),
                _float_attr(el, "stroke-width"),
            ))
        elif el.tag.rsplit("}", 1)[-1] == "text":
            role = next((t for t in cls if t in FONT_RULES), None)
            if role:
                model.texts.append(TextRun(
                    role,
                    _family(el.get("font-family")),
                    _size_pt(el.get("font-size")),
                    _norm_color(el.get("fill")),
                ))

    return model


# =========================================================================== #
# CHECK RESULTS                                                                #
# =========================================================================== #
@dataclass(frozen=True)
class CheckResult:
    name: str
    passed: bool
    message: str
    offenders: tuple = ()

    def __bool__(self) -> bool:
        return self.passed


def _ok(name: str, msg: str = "ok") -> CheckResult:
    return CheckResult(name, True, msg)


def _fail(name: str, msg: str, offenders=None) -> CheckResult:
    return CheckResult(name, False, msg, tuple(offenders or ()))


# =========================================================================== #
# CHECKS                                                                       #
# =========================================================================== #

def relative_luminance(hex_color: str) -> float:
    h = hex_color.lstrip("#")
    r, g, b = (int(h[i:i + 2], 16) / 255 for i in (0, 2, 4))

    def lin(c: float) -> float:
        return c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4

    return 0.2126 * lin(r) + 0.7152 * lin(g) + 0.0722 * lin(b)


def _named_groups(model: FigureModel) -> dict[str, Series]:
    out: dict[str, Series] = {}
    for i, s in enumerate(model.series):
        key = s.group if s.group is not None else f"_anon{i}"
        out.setdefault(key, s)
    return out


def check_dimensions(model: FigureModel) -> CheckResult:
    n = "dimensions"
    if model.design_w_in is None:
        return _fail(n, "no design width declared on SVG root (data-design-width-in)")
    declared = model.figure_class
    candidates = (
        [DIMENSION_CLASSES[declared]] if declared in DIMENSION_CLASSES
        else list(DIMENSION_CLASSES.values())
    )
    tol = DIMENSION_TOLERANCE_IN
    for dc in candidates:
        if abs(model.design_w_in - dc.width_in) > tol:
            continue
        if dc.height_variable:
            if model.design_h_in is not None and model.design_h_in + tol >= dc.min_height_in:
                return _ok(n, f"matches variable-height class '{dc.name}'")
        elif model.design_h_in is not None and abs(model.design_h_in - dc.height_in) <= tol:
            return _ok(n, f"matches class '{dc.name}'")
    return _fail(
        n,
        f"size {model.design_w_in}×{model.design_h_in} in matches no documented class "
        f"(declared class={declared!r})",
    )


def check_dpi(model: FigureModel) -> CheckResult:
    n = "dpi"
    if model.dpi is None:
        return _fail(n, "no dpi declared on SVG root (data-dpi)")
    return (
        _ok(n, f"{model.dpi} dpi ≥ {MIN_DPI}")
        if model.dpi >= MIN_DPI
        else _fail(n, f"{model.dpi} dpi < required {MIN_DPI}")
    )


def check_palette(model: FigureModel) -> CheckResult:
    """All series colours must come from the approved Okabe-Ito palette,
    and yellow (#F0E442) must not be used for lines/markers on white backgrounds."""
    n = "palette"
    bad = [
        f"{s.group or '?'}={s.stroke}"
        for s in model.series
        if s.stroke is not None and s.stroke not in PALETTE_SET
    ]
    if bad:
        return _fail(n, "series colours outside approved Okabe-Ito palette", bad)
    yellow_series = [s.group or "?" for s in model.series if s.stroke == YELLOW]
    if yellow_series:
        return _fail(
            n,
            f"yellow ({YELLOW}) used for a line/marker series — "
            "excluded from rotation on white; reserve for dark-background fills only",
            yellow_series,
        )
    return _ok(n, "all series colours within approved palette (yellow excluded from rotation)")


def check_monochrome_axes_and_text(model: FigureModel) -> CheckResult:
    """Axes and all text must be pure black (#000000)."""
    n = "monochrome_axes_text"
    bad = [f"axis stroke={a.stroke}" for a in model.axes if a.stroke not in (None, BLACK)]
    bad += [f"text[{t.role}] fill={t.fill}" for t in model.texts if t.fill not in (None, BLACK)]
    return _fail(n, "axes/text not pure black", bad) if bad else _ok(n, "axes and text are black")


def check_fonts(model: FigureModel) -> CheckResult:
    """Font family must be Arial/Helvetica/Albany AMT; size must be within spec range."""
    n = "fonts"
    bad = []
    for t in model.texts:
        if t.family is not None and t.family not in ALLOWED_FONT_FAMILIES:
            bad.append(f"{t.role}: family '{t.family}' not in {sorted(ALLOWED_FONT_FAMILIES)}")
        lo_hi = FONT_RULES.get(t.role)
        if lo_hi and t.size_pt is not None and not (lo_hi[0] <= t.size_pt <= lo_hi[1]):
            bad.append(f"{t.role}: {t.size_pt}pt outside [{lo_hi[0]}, {lo_hi[1]}]")
    return _fail(n, "font violations", bad) if bad else _ok(n, "fonts conform")


def check_gridlines(model: FigureModel, allow: bool | None = None) -> CheckResult:
    """Gridlines must be OFF by default; if allowed, must be faint gray."""
    n = "gridlines"
    if allow is None:
        allow = ALLOW_GRIDLINES_DEFAULT
    if not model.gridlines:
        return _ok(n, "no gridlines present")
    if not allow:
        return _fail(n, f"{len(model.gridlines)} gridline(s) present (spec default: off)")
    bad = [
        f"gridline stroke={g.stroke}"
        for g in model.gridlines
        if g.stroke not in GRIDLINE_FAINT_COLORS
    ]
    return (
        _fail(n, "gridlines present but not faint gray (#E0E0E0 range)", bad)
        if bad
        else _ok(n, "gridlines allowed and faint")
    )


def check_reference_lines(model: FigureModel) -> CheckResult:
    """Reference lines must be black, dashed/dotted, ≤ 1.5 px."""
    n = "reference_lines"
    bad = []
    for r in model.reflines:
        if r.stroke not in (None, BLACK):
            bad.append(f"refline stroke={r.stroke} (must be black)")
        if r.dash == "solid":
            bad.append("refline is solid (must be dashed or dotted)")
        if r.width is not None and r.width > MAX_REFLINE_WIDTH_PX:
            bad.append(f"refline width {r.width}px > max {MAX_REFLINE_WIDTH_PX}px")
    return _fail(n, "reference-line style violations", bad) if bad else _ok(n, "reference lines conform")


def check_redundant_encoding(model: FigureModel, strict: bool = True) -> CheckResult:
    """Every pair of groups must differ on colour AND dash pattern AND marker symbol."""
    n = "redundant_encoding"
    groups = _named_groups(model)
    if len(groups) < 2:
        return _ok(n, "single series — redundancy not applicable")
    bad = []
    for (ga, a), (gb, b) in combinations(groups.items(), 2):
        shared = [
            channel
            for channel, same in (
                ("colour",  a.stroke == b.stroke),
                ("dash",    a.dash   == b.dash),
                ("marker",  a.marker == b.marker),
            )
            if same
        ]
        if strict and shared:
            bad.append(f"'{ga}' vs '{gb}': share {', '.join(shared)}")
    return (
        _fail(n, "groups not fully redundantly encoded (colour + dash + marker required)", bad)
        if bad
        else _ok(n, f"{len(groups)} groups fully redundant on colour + dash + marker")
    )


def check_grayscale_safety(model: FigureModel) -> CheckResult:
    """Governing principle: series must be separable WITHOUT colour."""
    n = "grayscale_safety"
    groups = _named_groups(model)
    if len(groups) < 2:
        return _ok(n, "single series — n/a")
    bad = []
    for (ga, a), (gb, b) in combinations(groups.items(), 2):
        non_color = (a.dash != b.dash) or (a.marker != b.marker)
        lum_gap = (
            abs(relative_luminance(a.stroke) - relative_luminance(b.stroke))
            if a.stroke and b.stroke
            else 0.0
        )
        if not non_color and lum_gap < GRAYSCALE_LUMINANCE_TOL:
            bad.append(
                f"'{ga}' vs '{gb}': indistinguishable in B&W "
                f"(Δluminance={lum_gap:.3f}, no distinct dash/marker)"
            )
    return (
        _fail(n, "series collapse under grayscale conversion", bad)
        if bad
        else _ok(n, "all series separable without colour")
    )


ALL_CHECKS = (
    check_dimensions,
    check_dpi,
    check_palette,
    check_monochrome_axes_and_text,
    check_fonts,
    check_gridlines,
    check_reference_lines,
    check_redundant_encoding,
    check_grayscale_safety,
)


def run_all(model: FigureModel) -> list[CheckResult]:
    return [chk(model) for chk in ALL_CHECKS]


# =========================================================================== #
# OPTIONAL RASTER (numpy + Pillow)                                             #
# =========================================================================== #
try:
    import numpy as _np
    from PIL import Image as _Image
    _RASTER = True
except Exception:
    _RASTER = False

if _RASTER:
    _C1 = (0.01 * 255) ** 2
    _C2 = (0.03 * 255) ** 2

    _CVD_MATRICES = {
        "protan": _np.array([[0.152286, 1.052583, -0.204868],
                             [0.114503, 0.786281,  0.099216],
                             [-0.003882, -0.048116, 1.051998]]),
        "deutan": _np.array([[0.367322, 0.860646, -0.227968],
                             [0.280085, 0.672501,  0.047413],
                             [-0.011820, 0.042940,  0.968881]]),
        "tritan": _np.array([[1.255528, -0.076749, -0.178779],
                             [-0.078411, 0.930809,  0.147602],
                             [0.004733,  0.691367,  0.303900]]),
    }

    def _lum_array(img: "_Image.Image") -> "_np.ndarray":
        a = _np.asarray(img.convert("RGB"), dtype=_np.float64)
        return a @ _np.array([0.299, 0.587, 0.114])

    def _box_mean(a: "_np.ndarray", k: int) -> "_np.ndarray":
        ii = _np.cumsum(_np.cumsum(_np.pad(a, ((1, 0), (1, 0))), 0), 1)
        s = ii[k:, k:] - ii[:-k, k:] - ii[k:, :-k] + ii[:-k, :-k]
        return s / (k * k)

    def ssim(a: "_Image.Image", b: "_Image.Image", window: int = 7) -> float:
        """Mean structural similarity in [0, 1]; 1.0 == identical."""
        if a.size != b.size:
            raise ValueError(f"image size mismatch: {a.size} vs {b.size}")
        x, y = _lum_array(a), _lum_array(b)
        k = min(window, *x.shape)
        mx, my = _box_mean(x, k), _box_mean(y, k)
        vx  = _box_mean(x * x, k) - mx * mx
        vy  = _box_mean(y * y, k) - my * my
        vxy = _box_mean(x * y, k) - mx * my
        num = (2 * mx * my + _C1) * (2 * vxy + _C2)
        den = (mx * mx + my * my + _C1) * (vx + vy + _C2)
        return float(_np.clip(num / den, 0, 1).mean())

    def _srgb_to_linear(a: "_np.ndarray") -> "_np.ndarray":
        a = a / 255.0
        return _np.where(a <= 0.04045, a / 12.92, ((a + 0.055) / 1.055) ** 2.4)

    def _linear_to_srgb(a: "_np.ndarray") -> "_np.ndarray":
        a = _np.clip(a, 0, 1)
        s = _np.where(a <= 0.0031308, a * 12.92, 1.055 * a ** (1 / 2.4) - 0.055)
        return _np.clip(s * 255, 0, 255).astype(_np.uint8)

    def simulate_cvd(img: "_Image.Image", kind: str) -> "_Image.Image":
        """Simulate colour-vision deficiency (protan/deutan/tritan)."""
        mat = _CVD_MATRICES[kind]
        rgb = _np.asarray(img.convert("RGB"), dtype=_np.float64)
        out = _srgb_to_linear(rgb) @ mat.T
        return _Image.fromarray(_linear_to_srgb(out), "RGB")

    def compare_to_golden(
        candidate: str | Path,
        golden: str | Path,
        threshold: float = SSIM_PASS_THRESHOLD,
        update: bool = False,
    ) -> CheckResult:
        candidate, golden = Path(candidate), Path(golden)
        if update or not golden.exists():
            golden.parent.mkdir(parents=True, exist_ok=True)
            _Image.open(candidate).convert("RGB").save(golden)
            return CheckResult("regression", True, f"golden written: {golden.name}")
        score = ssim(_Image.open(candidate), _Image.open(golden))
        ok = score >= threshold
        return CheckResult(
            "regression", ok,
            f"SSIM {score:.5f} {'≥' if ok else '<'} {threshold}",
        )


# =========================================================================== #
# INLINE FIXTURES                                                              #
# =========================================================================== #
CONFORMING_SVG = """<svg xmlns="http://www.w3.org/2000/svg"
 data-figure-class="km_risk" data-design-width-in="9.0"
 data-design-height-in="6.0" data-dpi="300" viewBox="0 0 2700 1800">
 <path class="clin-series" data-group="Placebo" stroke="#000000" stroke-width="2"
       stroke-dasharray="solid" data-marker="circle" d="M0,0 L1,1"/>
 <path class="clin-series" data-group="Low Dose" stroke="#0072B2" stroke-width="2"
       stroke-dasharray="6,3" data-marker="square" d="M0,0 L1,1"/>
 <path class="clin-series" data-group="High Dose" stroke="#D55E00" stroke-width="2"
       stroke-dasharray="2,2" data-marker="triangle" d="M0,0 L1,1"/>
 <path class="clin-axis" stroke="#000000" stroke-width="1" d="M0,0 L1,0"/>
 <path class="clin-axis" stroke="#000000" stroke-width="1" d="M0,0 L0,1"/>
 <line class="clin-refline" stroke="#000000" stroke-width="1" stroke-dasharray="3,3"/>
 <text class="clin-title" font-family="Arial" font-size="10" fill="#000000">Overall Survival</text>
 <text class="clin-axis-label" font-family="Arial" font-size="9" fill="#000000">Time (weeks)</text>
 <text class="clin-tick" font-family="Arial" font-size="8" fill="#000000">0</text>
 <text class="clin-footnote" font-family="Arial" font-size="7" fill="#000000">n=300</text>
</svg>"""

VIOLATING_SVG = """<svg xmlns="http://www.w3.org/2000/svg"
 data-figure-class="km_risk" data-design-width-in="9.0"
 data-design-height-in="6.0" data-dpi="150" viewBox="0 0 1350 900">
 <path class="clin-series" data-group="Other" stroke="#FF00FF" stroke-width="2"
       stroke-dasharray="solid" data-marker="circle" d="M0,0 L1,1"/>
 <path class="clin-series" data-group="Vermillion" stroke="#D55E00" stroke-width="2"
       stroke-dasharray="solid" data-marker="circle" d="M0,0 L1,1"/>
 <path class="clin-series" data-group="Green" stroke="#009E73" stroke-width="2"
       stroke-dasharray="solid" data-marker="circle" d="M0,0 L1,1"/>
 <path class="clin-axis" stroke="#3333FF" stroke-width="1" d="M0,0 L1,0"/>
 <line class="clin-gridline" stroke="#999999" stroke-width="1"/>
 <line class="clin-refline" stroke="#D55E00" stroke-width="3" stroke-dasharray="solid"/>
 <text class="clin-title" font-family="Comic Sans MS" font-size="18" fill="#FF0000">OS</text>
</svg>"""

YELLOW_SERIES_SVG = """<svg xmlns="http://www.w3.org/2000/svg"
 data-figure-class="general" data-design-width-in="9.0"
 data-design-height-in="5.56" data-dpi="300">
 <path class="clin-series" data-group="Control" stroke="#000000" stroke-width="2"
       stroke-dasharray="solid" data-marker="circle" d="M0,0 L1,1"/>
 <path class="clin-series" data-group="Active" stroke="#F0E442" stroke-width="2"
       stroke-dasharray="6,3" data-marker="square" d="M0,0 L1,1"/>
</svg>"""


# =========================================================================== #
# PYTEST SUITE                                                                 #
# =========================================================================== #
def test_conforming_passes_every_check():
    model = parse_svg(CONFORMING_SVG)
    for r in run_all(model):
        assert r.passed, f"{r.name}: {r.message} {r.offenders}"


def test_offpalette_colour_caught():
    assert not check_palette(parse_svg(VIOLATING_SVG))


def test_yellow_line_series_caught():
    """Yellow must not be used as a line/marker colour on white backgrounds."""
    assert not check_palette(parse_svg(YELLOW_SERIES_SVG))


def test_coloured_axis_and_text_caught():
    assert not check_monochrome_axes_and_text(parse_svg(VIOLATING_SVG))


def test_gridline_caught():
    assert not check_gridlines(parse_svg(VIOLATING_SVG))


def test_bad_refline_caught():
    assert not check_reference_lines(parse_svg(VIOLATING_SVG))


def test_bad_font_caught():
    assert not check_fonts(parse_svg(VIOLATING_SVG))


def test_low_dpi_caught():
    assert not check_dpi(parse_svg(VIOLATING_SVG))


def test_colour_only_encoding_collapses_in_bw():
    assert not check_grayscale_safety(parse_svg(VIOLATING_SVG))


def test_redundant_encoding_requires_all_three_channels():
    assert not check_redundant_encoding(parse_svg(VIOLATING_SVG), strict=True)


def test_gridlines_allowed_when_opted_in_and_faint():
    svg = (
        '<svg xmlns="http://www.w3.org/2000/svg" data-figure-class="general" '
        'data-design-width-in="9.0" data-design-height-in="5.56" data-dpi="300">'
        '<line class="clin-gridline" stroke="#E0E0E0" stroke-width="1"/></svg>'
    )
    m = parse_svg(svg)
    assert not check_gridlines(m, allow=False), "gridlines must fail when not allowed"
    assert check_gridlines(m, allow=True),      "faint gridlines must pass when allowed"


def test_raster_available_or_skipped():
    import pytest
    if not _RASTER:
        pytest.skip("numpy/Pillow not installed")
    img = _Image.new("RGB", (64, 48), "white")
    assert ssim(img, img) > 0.9999
    for kind in ("protan", "deutan", "tritan"):
        out = simulate_cvd(img, kind)
        assert out.size == img.size


# =========================================================================== #
# CLI                                                                          #
# =========================================================================== #
def _print_report(label: str, results: list[CheckResult]) -> None:
    print(f"--- {label} ---")
    for r in results:
        status = "PASS" if r.passed else "FAIL"
        print(f"[{status}] {r.name:<26} {r.message}")
        for o in r.offenders:
            print(f"           - {o}")


def _main(argv: list[str]) -> int:
    paths = [a for a in argv if not a.startswith("--")]
    as_json = "--json" in argv

    if not paths:
        ok  = run_all(parse_svg(CONFORMING_SVG))
        bad = run_all(parse_svg(VIOLATING_SVG))
        if as_json:
            import json
            print(json.dumps({
                "conforming": [vars(r) for r in ok],
                "violating":  [vars(r) for r in bad],
            }, indent=2))
        else:
            _print_report("conforming fixture", ok)
            print()
            _print_report("violating fixture", bad)
        return 0 if all(ok) else 1

    overall_ok = True
    payload: dict = {}
    for path in paths:
        results = run_all(parse_svg(Path(path)))
        overall_ok = overall_ok and all(results)
        payload[path] = [vars(r) for r in results]
        if not as_json:
            _print_report(path, results)
            print()

    if as_json:
        import json
        print(json.dumps(payload, indent=2))

    return 0 if overall_ok else 1


if __name__ == "__main__":
    raise SystemExit(_main(sys.argv[1:]))

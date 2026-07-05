# Program translator (`translate.py`)

Jenner programs can be written in **26 natural languages** — `DATA` (English),
`DONNÉES` (French), `データ` (Japanese), `数据` (Chinese), `DATOS` (Spanish), and
so on all parse identically. The engine auto-detects the language(s) used in a
script, so a program written in French runs as-is, no flags needed.

`translate.py` converts the keywords of a program between any two supported
languages, **in either direction** — English → Japanese, French → English,
Spanish → Korean, anything. It handles:

- plain scripts (`.jenner`, `.sas`)
- Jupyter notebooks (`.ipynb`) — only code cells are translated; markdown,
  embedded outputs, and metadata are untouched

String literals, comments, variable names, and data values are never modified.
Only the Python standard library is required (Python 3.8+).

## Usage

```bash
# English → French
python3 tools/translate.py --to fr analysis.jenner -o analyse.jenner

# French → English (reverse direction works the same way)
python3 tools/translate.py --to en analyse.jenner -o analysis.jenner

# Notebook → Japanese
python3 tools/translate.py --to ja notebook.ipynb -o notebook_ja.ipynb

# Restrict which source languages are recognized (default: auto-detect)
python3 tools/translate.py --to es --from en,fr mixed.jenner

# Lowercase / Titlecase keywords instead of UPPERCASE
python3 tools/translate.py --to de --case lower program.jenner

# List all 26 supported languages
python3 tools/translate.py --list-languages
```

## Fidelity

This tool is a faithful port of `jenner translate` from the Jenner engine and
produces **identical output**: the keyword tables (`keywords.json`) are exported
directly from the engine's `src/i18n/data/keywords/*.toml` files, and the
scanner mirrors the engine's string/comment handling and keyword-resolution
order. Round-trips are lossless: translating English → French → English
returns the original program byte-for-byte.

`keywords.json` is regenerated from the Jenner engine repository with
`scripts/export-i18n-keywords.py`; do not edit it by hand.

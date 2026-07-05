# SAS-Compatible Examples (Jenner)

🌐 [Čeština](translations/cs/README.md) · [Dansk](translations/da/README.md) · [Deutsch](translations/de/README.md) · [Ελληνικά](translations/el/README.md) · [Español](translations/es/README.md) · [Suomi](translations/fi/README.md) · [Français](translations/fr/README.md) · [Italiano](translations/it/README.md) · [日本語](translations/ja/README.md) · [한국어](translations/ko/README.md) · [Nederlands](translations/nl/README.md) · [Polski](translations/pl/README.md) · [Português](translations/pt/README.md) · [Svenska](translations/sv/README.md) · [中文](translations/zh/README.md)

A curated, **validated** collection of analytical example notebooks that run on
[Jenner](https://jenneranalytics.com) — a SAS-compatible DATA step and PROC engine.

Every notebook here has been **content-reviewed for truthfulness**, not merely
checked that it executes:

- It runs cleanly through the Jenner Jupyter kernel, and **the executed outputs
  (tables and plots) are embedded** — read the results directly on GitHub without
  downloading or re-running anything.
- Every number and conclusion in the narrative is **grounded in the notebook's real
  output** — no pre-written or fabricated findings.
- Each generated image has been **visually reviewed**.
- The advertised SAS procedure is the one actually executed.

Notebooks that could not meet this bar were excluded rather than published. This is a
deliberately small, high-trust set; it grows as more examples pass review.

## Layout

- `procs/<proc>/<slug>/notebook.ipynb` — examples organized by SAS procedure.
- `<industry>/<slug>/` — examples organized by domain.

## Running an example

```bash
jenner jupyter install
jupyter lab
```

Select the **Jenner** kernel and Run All. Because outputs are already embedded, you can
also just read each notebook as-is.

## Program languages

Jenner programs can be written in **26 natural languages** — `DATA`, `DONNÉES`,
`データ`, `数据`, and `DATOS` all parse identically, and the engine auto-detects
the language of a script. Translated versions of these notebooks (markdown
narrative *and* code keywords) live under [`translations/`](translations/), one
tree per language, so you can read an analysis end-to-end in your own language.

To convert any program or notebook between languages — in either direction —
use [`tools/translate.py`](tools/README.md).

# SAS-Compatible Examples (Jenner)

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

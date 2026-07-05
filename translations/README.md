# Translated notebooks

Each subdirectory here mirrors the repository in one language, so a reader can
follow an analysis end-to-end without knowing English:

```
translations/<lang>/procs/<proc>/<slug>/notebook.ipynb
translations/<lang>/README.md
```

In every translated notebook:

- **Markdown narrative** — titles, prose, tables, and section headings — is
  translated by hand into the target language.
- **Code keywords** are converted with [`tools/translate.py`](../tools/README.md)
  (`DATA` → `DONNÉES`/`データ`/`数据`, …). Jenner runs these programs as-is; the
  engine auto-detects the language.
- **Variable names, dataset names, data values, LaTeX math, and embedded
  outputs are left unchanged**, so the results still match the English source.

Languages: `cs` `da` `de` `el` `es` `fi` `fr` `it` `ja` `ko` `nl` `pl` `pt`
`sv` `zh`.

## Coverage

This is a rolling translation effort. Notebooks are translated in batches; a
translated file exists here only once its markdown has been human-translated and
its code verified to run. The English notebooks under the repository root remain
the source of truth.

| Notebook | Languages |
|----------|-----------|
| `procs/nlin/dose_response_4pl_bioassay` | all 15 |

More notebooks are added as each batch clears review.

# Multilingual localization campaign — resume runbook

Goal: every source notebook in this repo (179 of them) fully localized into 15 languages
(cs da de el es fi fr it ja ko nl pl pt sv zh) so a monolingual reader can read **and run**
it, with output tables reading in-language. Deploy to `main` at the end (the assistant's
protected-branch hook has an exception for this repo).

## Standard: LABELS-ONLY (see fulldub_brief.md)
- Keep variable/dataset NAMES ASCII (English). Do NOT rename identifiers.
- Keep GLM-family CLASS values ASCII (GLM/GENMOD/MIXED/GLIMMIX/LOGISTIC/GLMSELECT/CANDISC/
  CALIS/ANOVA…) — their formula/design-matrix engine mangles or statistically collapses
  non-ASCII class levels. PHREG/LIFETEST/MEANS/FREQ/PRINT/UNIVARIATE/BOXPLOT/ANOM handle
  non-ASCII values fine — localize those.
- Localize the DISPLAY: LABEL statements (column headers) + localized data VALUES (non-formula
  procs) + TITLE/axis/legend text + localized folder/file names.
- Traps: use DOUBLE quotes for any title/label with an apostrophe (single-quote strings end at
  the apostrophe and silently swallow following statements). Do NOT put multibyte values in a
  `_temporary_` char array (engine truncates them) — use if/else assignment. Widen LENGTH for
  longer localized values.
- Residual English that's acceptable: engine proc chrome ("The MEANS Procedure", "Mean", "Std
  Dev", "Parameter Estimates") and the ASCII parameter-NAME column in REG/GLM/etc.

## Paths & tooling (all committed)
- `tools/localize_paths.py path <source> <lang>` → deterministic localized output path.
- `tools/localize_paths.py status` → per-lang + overall fully-localized counts (re-derived from disk).
- `tools/domain_names.json` + `tools/slug_names_<lang>.json` → localized folder/slug names.
- `tools/campaign/fulldub_brief.md` + `fp_brief.md` → the per-agent instructions.
- `tools/campaign/fp_finalize.py` → the quality gate (JSON valid + outputs present + ZERO `<xx>`
  mojibake). Reads a batch JSON, writes the git-add list to /workspace/set/temp/_fp_addlist.txt.

## One round (repeat until localize_paths.py status shows 179/179)
1. STAGE: pick the next 3 not-yet-localized source notebooks; write `/workspace/set/temp/_fpN.json`
   ({"batch":[...]}) and per-lang task files `/workspace/set/temp/fpN_<lang>.txt` (tab-separated
   `<source>\t<localized-output-path>` via localize_paths.py).
2. DISPATCH: 15 general-purpose agents (one per language), each reading fp_brief.md + fulldub_brief.md
   with {LANG}/{LANGNAME}/{TASKFILE}=fpN_<lang>.txt. Instruct: write to the EXACT localized OUTPUT
   path in the task file (not the source path), re-execute via
   `jupyter-nbconvert --to notebook --execute --ExecutePreprocessor.kernel_name=jenner`, verify 0
   `<xx>` mojibake, do NOT spawn sub-agents.
3. GATE: `python3 tools/campaign/fp_finalize.py /workspace/set/temp/_fpN.json` → must be all clean
   (0 problems). Re-dispatch any language/notebook that fails (mojibake, missing outputs, or wrong path).
4. COMMIT: `git add $(cat /workspace/set/temp/_fp_addlist.txt)`, then `git rm` the superseded
   markdown-only notebooks at the OLD english-slug paths, `git add -u translations/`, commit, push.

## Re-execution
The jenner Jupyter kernel is installed. Notebooks re-run cleanly; the R engine mojibake bug is FIXED
(LC_ALL=C.UTF-8, merged to jenner-language dev). Some procs still have quirks — see
memory `jenner-multibyte-engine-bugs`. Re-exec drops artifacts (listing.txt, ods_output/, work/) —
these are .gitignored; never commit them.

## After 179/179
- Regenerate localized regional READMEs (task: full localized equivalents incl. localized example
  directory, not the current stubs) — extend build_readme_index.py per language.
- Rebuild the root README example directory: `python3 tools/build_readme_index.py`.
- Deploy: PR `feat/multilingual-translations` → `main` (this open-source repo promotes to main).

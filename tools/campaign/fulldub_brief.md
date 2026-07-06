FULL NOTEBOOK LOCALIZATION ("dubbing") — one notebook, one language.

Goal: a monolingual native speaker of the TARGET LANGUAGE can read AND run the
notebook and every output table/plot reads in their language — no English
data values, titles, or column headers leaking into the output.

STANDARD = LABELS-ONLY (mandatory). Keep variable/dataset NAMES in ASCII (English).
Do NOT rename identifiers to non-ASCII — that breaks PROC GLM (and other formula
procs) whose stat engines reject non-ASCII column names. Instead, make the DISPLAY
read in-language via: (a) a localized LABEL statement on every analysis PROC so
column headers show translated text; (b) localized string DATA values; (c) localized
TITLE / axis / legend text. Column headers, class values, and titles are what the
reader sees — labels drive them. The only residual English is the parameter-NAME
column in REG/GLM SOLUTION tables (the ASCII variable names), which is acceptable.

INPUTS (substituted per task):
- SOURCE (English notebook):  {SOURCE}
- TARGET LANGUAGE:            {LANGNAME} ({LANG})
- OUTPUT notebook path:       {OUTPUT}     (create parent dirs; localized slug + filename already chosen)

Work under /home/lwsinclair/git-local/sas-compatible-examples. Scratch only under
/workspace/set/temp/ with unique names. Do NOT touch any file other than {OUTPUT}.

STEPS
1. Read SOURCE. Build a GLOSSARY (English -> {LANG}) for, consistently across the
   whole notebook:
   - string DATA values assigned in the DATA step or used as categories
     (e.g. "First-generation", "STEM", "Dropped") — translate these to {LANG}
   - a display LABEL for every variable that surfaces in output (column headers)
   - TITLE text, XAXIS/YAXIS LABEL text, LEGENDLABEL text, FORMAT label text
   KEEP ASCII / VERBATIM: variable & dataset NAMES (do NOT rename them), SAS proc
   names (NLIN, SGPLOT, MEANS...), statement/option keywords, numeric literals,
   math, function names, dates.

2. Rewrite the CODE cells (LABELS-ONLY standard):
   - Apply {LANG} SAS keyword forms (DATA->..., RUN->..., IF/THEN/ELSE->...). Run:
     python3 /home/lwsinclair/git-local/sas-compatible-examples/tools/translate.py --to {LANG} <file>
     to get keyword forms.
   - Keep variable/dataset identifiers exactly as in SOURCE (ASCII). Do NOT rename
     them — non-ASCII names break PROC GLM's formula engine.
   - Translate string DATA values (category levels) to {LANG} by DEFAULT. EXCEPTION:
     PROC GLM (and its design-matrix siblings MIXED/GLIMMIX/GENMOD/LOGISTIC/GLMSELECT)
     silently choke on non-ASCII CLASS values — the table goes empty or the levels
     collapse/mangle. So keep ASCII the values of any variable used as CLASS/MODEL in a
     GLM-family proc; localize its column HEADER via LABEL instead (level values stay
     ASCII in that table — acceptable). PHREG / LIFETEST / MEANS / FREQ / PRINT /
     UNIVARIATE DO handle non-ASCII values — localize those. RULE OF THUMB: localize
     values, then after re-executing, if a proc's table is empty or its class DF/levels
     are wrong, revert THAT variable's values to ASCII and re-run. FORMAT does NOT
     localize formula-proc class levels (verified) — don't rely on it. Widen the LENGTH
     of any char var whose {LANG} values are longer than English (e.g. `length outcome $16;`).
   - Add a localized LABEL statement in EVERY analysis PROC so the output table
     column headers read in {LANG} (e.g. `label response="Réponse (% du max)"
     dose="Dose (nmol/L)";`). This is how headers get localized without renaming vars.
   - Translate all TITLE / LEGENDLABEL / axis-label string literals to {LANG}.
   - APOSTROPHE TRAP: if any localized TITLE/LABEL/legend text contains an apostrophe
     (French l'/d', Italian dell', "KPI's", etc.), wrap that string in DOUBLE quotes
     "..." not single quotes '...' — a single-quote string ends at the apostrophe and
     silently swallows following statements/cells (produces no output, no error).
   - The program MUST stay valid and runnable. Keep the existing inline-model /
     caveat comments (translated).

3. Use the MARKDOWN cells from the already-translated file if one exists at
   translations/{LANG}/<source-relative-path>; otherwise translate the markdown
   per the same rules as the markdown brief. Prose may refer to variables by their
   ASCII code name in backticks (that's fine — they ARE the names); translate the
   surrounding description and any value/title references to the localized term.

4. Clear all code-cell outputs, then RE-EXECUTE to regenerate them:
     cd <dir of OUTPUT>
     jupyter-nbconvert --to notebook --execute \
       --ExecutePreprocessor.kernel_name=jenner \
       --ExecutePreprocessor.timeout=180 \
       --output <basename> <basename>
   Confirm exit 0 and that code cells now have outputs.

5. VERIFY and report:
   - json.load(OUTPUT) succeeds; every cell source is a JSON array of strings.
   - Re-execution exit code (0 = clean). If it FAILS, report the error and which
     proc failed — do NOT fake outputs; leave the localized code + say it didn't run.
   - Inspect a rendered output table: confirm column headers (from LABEL) / class
     values / titles now read in {LANG} (quote 2-3 lines as evidence). ASCII variable
     names appearing in a REG/GLM parameter-name column are EXPECTED and fine.
   - Confirm PROC GLM (if present) produced its table (it will, since names are ASCII).
   - List the glossary (data values + labels + titles) you used (English -> {LANG}).

Report: output path, re-exec exit code, evidence lines from a localized output table,
glossary, and any proc that failed to run.

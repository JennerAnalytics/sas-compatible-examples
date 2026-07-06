FULL NOTEBOOK LOCALIZATION — batch, one language. Follow /workspace/set/temp/fulldub_brief.md
for the per-notebook method (glossary → localize code identifiers/data values/titles/labels →
reuse translated markdown → RE-EXECUTE via jupyter-nbconvert --kernel jenner → verify).

Your task list is /workspace/set/temp/{TASKFILE} — tab-separated lines "<SOURCE>\t<OUTPUT>",
paths relative to /home/lwsinclair/git-local/sas-compatible-examples (cd there first).

For EACH line:
- SOURCE = the English notebook. OUTPUT = the exact localized path to create (parents too).
- Reuse the already-translated MARKDOWN from translations/{LANG}/<SOURCE-with-notebook.ipynb>
  if it exists (same relative dir as SOURCE, under translations/{LANG}/); otherwise translate
  the markdown yourself. Then localize the CODE (identifiers, string data values, TITLE/axis/
  legend/LABEL text) consistently, add LABEL statements so output headers read in {LANG}, and
  set the notebook's kernelspec to jenner.
- Write to OUTPUT, then RE-EXECUTE it in place:
    cd <dir of OUTPUT>
    jupyter-nbconvert --to notebook --execute --ExecutePreprocessor.kernel_name=jenner \
      --ExecutePreprocessor.timeout=240 --output <basename> <basename>
- Verify: json.load OK; code cells have outputs; quote 2-3 output lines showing localized
  headers/values. Report the re-exec EXIT CODE per notebook. If a proc fails to execute, say
  so honestly and which proc — leave the localized code, do NOT fabricate outputs.

Scratch only under /workspace/set/temp/ with unique names. Edit only files under the OUTPUT
paths. Report per-notebook: output path, re-exec exit code, localized-output evidence, glossary.

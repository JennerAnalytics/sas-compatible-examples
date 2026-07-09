#!/usr/bin/env python3
"""Deterministic localized output paths + full-pipeline staging/status.

Given the English source notebook path and a target language, compute the
localized output path under translations/<lang>/ using:
  - tools/domain_names.json  (industry-domain folder -> localized, per lang)
  - tools/slug_names_<lang>.json  (source path -> localized slug, per lang)

Path convention (regional trees only; English source untouched):
  procs/<proc>/<slug>/notebook.ipynb
     -> translations/<lang>/procs/<proc>/<localized_slug>/<localized_slug>.ipynb
  <industry>/<slug>/notebook.ipynb
     -> translations/<lang>/<localized_industry>/<localized_slug>/<localized_slug>.ipynb
(`procs` and the proc-name segment stay verbatim — technical SAS identifiers.)

CLI:
  localize_paths.py path <source_rel> <lang>     # print localized output path
  localize_paths.py status                       # per-lang fully-localized counts
  localize_paths.py list-todo <lang> <N>         # next N source paths not yet localized
"""
import json, sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
LANGS = ["cs","da","de","el","es","fi","fr","it","ja","ko","nl","pl","pt","sv","zh"]

def _load(p):
    return json.loads((REPO/p).read_text())

def localized_path(source_rel, lang):
    domains = _load("tools/domain_names.json")
    slugs = _load(f"tools/slug_names_{lang}.json")
    parts = source_rel.split("/")            # [top, ...mid..., slug, notebook.ipynb]
    slug_loc = slugs[source_rel]
    top = parts[0]
    if top == "procs":
        proc = parts[1]
        mid = f"procs/{proc}"
    else:
        mid = domains[top][lang]              # localized industry folder
    return f"translations/{lang}/{mid}/{slug_loc}/{slug_loc}.ipynb"

_SRC_OUTPUT_CACHE = {}

def _source_code_has_output(source_rel):
    """Per-index output presence for the English source's code cells, cached.
    A localized cell is allowed to lack output only where the SOURCE cell at
    the same index also lacks output (e.g. a PATTERN-statement-only setup
    cell) — this still catches a genuine execution regression while not
    perpetually flagging a structurally quiet cell as "not localized"."""
    if source_rel not in _SRC_OUTPUT_CACHE:
        nb = json.loads((REPO/source_rel).read_text())
        _SRC_OUTPUT_CACHE[source_rel] = [
            bool(c.get("outputs")) for c in nb["cells"] if c["cell_type"] == "code"
        ]
    return _SRC_OUTPUT_CACHE[source_rel]

def is_localized(source_rel, lang):
    """Fully localized == output path exists, valid JSON, and code cells have
    outputs (except where the source cell at that index never had output)."""
    p = REPO/localized_path(source_rel, lang)
    if not p.exists():
        return False
    try:
        nb = json.loads(p.read_text())
    except Exception:
        return False
    code = [c for c in nb["cells"] if c["cell_type"] == "code"]
    if not code:
        return False
    src_has_output = _source_code_has_output(source_rel)
    required = src_has_output if len(src_has_output) == len(code) else [True] * len(code)
    return all(c.get("outputs") for c, need in zip(code, required) if need)

def all_sources():
    return [r["path"] for r in json.loads(
        Path("/workspace/set/temp/notebook_titles.json").read_text())]

def main():
    cmd = sys.argv[1]
    if cmd == "path":
        print(localized_path(sys.argv[2], sys.argv[3]))
    elif cmd == "status":
        srcs = all_sources()
        print(f"sources: {len(srcs)}")
        total = 0
        for lang in LANGS:
            n = sum(1 for s in srcs if is_localized(s, lang))
            total += n
            print(f"  {lang}: {n}/{len(srcs)}")
        print(f"fully localized (all 15): {total//15} / {len(srcs)} (sum {total})")
    elif cmd == "list-todo":
        lang, N = sys.argv[2], int(sys.argv[3])
        srcs = all_sources()
        todo = [s for s in srcs if not is_localized(s, lang)][:N]
        for s in todo:
            print(f"{s}\t{localized_path(s, lang)}")

if __name__ == "__main__":
    main()

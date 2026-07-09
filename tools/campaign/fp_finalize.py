#!/usr/bin/env python3
"""Quality gate for a full-pipeline (localize+rerun) batch.

For each (source, lang): verify the localized notebook exists, is valid JSON,
every code cell has outputs, and NO byte-escape mojibake (`<xx>`) appears in any
output (the multibyte-truncation signature). Writes the git-add list of clean
files and reports which (lang, notebook) need redoing.
"""
import json, sys, re
from pathlib import Path
sys.path.insert(0, "/home/lwsinclair/git-local/sas-compatible-examples/tools")
from localize_paths import localized_path, LANGS

REPO = Path("/home/lwsinclair/git-local/sas-compatible-examples")
MOJI = re.compile(r'<[0-9a-f]{2}>')

def cell_out_text(nb):
    t = ""
    for c in nb["cells"]:
        if c["cell_type"] == "code":
            for o in c.get("outputs", []):
                x = o.get("text")
                t += ("".join(x) if isinstance(x, list) else (x or ""))
    return t

def source_code_has_output(source_rel):
    """Per-index output presence for the English source's code cells. A localized
    cell is allowed to lack output only where the SOURCE cell at the same index
    also lacks output (e.g. a PATTERN-statement-only setup cell) — this still
    catches a genuine execution regression while not flagging a structurally
    quiet cell that never had output even in the untouched English source."""
    nb = json.loads((REPO / source_rel).read_text())
    return [bool(c.get("outputs")) for c in nb["cells"] if c["cell_type"] == "code"]

def main(batch_json):
    batch = json.load(open(batch_json))["batch"]
    clean, problems = [], []
    for s in batch:
        src_has_output = source_code_has_output(s)
        for l in LANGS:
            rel = localized_path(s, l)
            p = REPO / rel
            tag = f"{l}:{s.split('/')[-2]}"
            if not p.exists():
                problems.append(f"{tag} ABSENT"); continue
            try:
                nb = json.loads(p.read_text())
            except Exception as e:
                problems.append(f"{tag} BADJSON {e}"); continue
            code = [c for c in nb["cells"] if c["cell_type"] == "code"]
            if not code:
                problems.append(f"{tag} MISSING-OUTPUTS"); continue
            required = src_has_output if len(src_has_output) == len(code) else [True] * len(code)
            if not all(c.get("outputs") for c, need in zip(code, required) if need):
                problems.append(f"{tag} MISSING-OUTPUTS"); continue
            moji = MOJI.findall(cell_out_text(nb))
            if moji:
                problems.append(f"{tag} MOJIBAKE×{len(moji)}"); continue
            clean.append(rel)
    Path("/workspace/set/temp/_fp_addlist.txt").write_text("\n".join(clean))
    print(f"clean: {len(clean)} / {len(batch)*len(LANGS)}; problems: {len(problems)}")
    for pr in problems: print("  !", pr)
    return 1 if problems else 0

if __name__ == "__main__":
    sys.exit(main(sys.argv[1]))

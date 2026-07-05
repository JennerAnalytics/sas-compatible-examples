#!/usr/bin/env python3
"""Prepare a batch of notebooks for translation.

For each English notebook and each target language, this:
  1. creates translations/<lang>/<path>/ (translating the slug directory names),
  2. writes a code-keyword-translated notebook.ipynb via tools/translate.py,
  3. records which markdown cells still need HUMAN translation.

It never fabricates markdown translations — it only does the mechanical code
half and emits a manifest of remaining human work, so the notebook markdown can
be translated (e.g. by a per-language agent) in a later step.

A notebook/language is considered DONE only when its markdown cells differ from
the English source; this script skips those, so it is safely resumable.

Usage:
    python3 tools/prepare_translation_batch.py --langs fr,es,ja [--limit N]
    python3 tools/prepare_translation_batch.py --status        # coverage report
"""
import argparse
import json
import subprocess
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
TOOL = REPO / "tools" / "translate.py"
LANGS = ["cs", "da", "de", "el", "es", "fi", "fr",
         "it", "ja", "ko", "nl", "pl", "pt", "sv", "zh"]


def english_notebooks():
    # All source notebooks except the translated mirror trees and tooling.
    return sorted(p for p in REPO.glob("**/notebook.ipynb")
                  if "translations" not in p.parts and "tools" not in p.parts)


def md_indices(nb):
    return [i for i, c in enumerate(nb["cells"]) if c["cell_type"] == "markdown"]


def _translatable_prose(src):
    """Human-prose residue of a markdown cell after stripping code, math, HTML,
    table rules, and punctuation. Empty => a structural-only cell (a `---`
    separator or a pure <div>/<img> banner) that stays identical after
    translation and must not be counted as 'untranslated'."""
    import re
    s = "".join(src) if isinstance(src, list) else src
    s = re.sub(r"```.*?```", " ", s, flags=re.S)
    s = re.sub(r"`[^`]*`", " ", s)
    s = re.sub(r"\$\$.*?\$\$", " ", s, flags=re.S)
    s = re.sub(r"\$[^$]*\$", " ", s)
    s = re.sub(r"<[^>]+>", " ", s)
    s = re.sub(r"data:image/[^\"')]+", " ", s)
    s = re.sub(r"[-=|:#*_>\s]+", " ", s)
    return s.strip()


def md_translated(en_nb, tr_nb):
    """True if every prose-bearing markdown cell differs from English.
    Structural-only cells (separators, HTML banners) are ignored."""
    for i in md_indices(en_nb):
        en = "".join(en_nb["cells"][i]["source"])
        tr = "".join(tr_nb["cells"][i]["source"])
        if _translatable_prose(en_nb["cells"][i]["source"]) and en == tr:
            return False
    return True


def prepare(langs, limit):
    todo = []
    for src in english_notebooks()[: limit or None]:
        en_nb = json.loads(src.read_text())
        rel = src.relative_to(REPO)                      # procs/<proc>/<slug>/notebook.ipynb
        for lang in langs:
            dst = REPO / "translations" / lang / rel
            dst.parent.mkdir(parents=True, exist_ok=True)
            if dst.exists() and md_translated(en_nb, json.loads(dst.read_text())):
                continue                                  # already fully done — skip
            if not dst.exists():
                subprocess.run(
                    [sys.executable, str(TOOL), "--to", lang, "-o", str(dst), str(src)],
                    check=True, capture_output=True)
            todo.append({"lang": lang, "file": str(dst.relative_to(REPO)),
                         "md_cells": md_indices(en_nb),
                         "source": str(rel)})
    return todo


def status():
    ens = english_notebooks()
    print(f"English notebooks: {len(ens)}")
    print(f"{'lang':5} {'code-staged':>11} {'md-done':>8}")
    for lang in LANGS:
        staged = done = 0
        for src in ens:
            dst = REPO / "translations" / lang / src.relative_to(REPO)
            if dst.exists():
                staged += 1
                if md_translated(json.loads(src.read_text()), json.loads(dst.read_text())):
                    done += 1
        print(f"{lang:5} {staged:>11} {done:>8}")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--langs", default=",".join(LANGS))
    ap.add_argument("--limit", type=int, default=0)
    ap.add_argument("--status", action="store_true")
    ap.add_argument("--manifest", default="tools/translation_todo.json")
    args = ap.parse_args()
    if args.status:
        status()
        return
    langs = [l for l in args.langs.split(",") if l]
    todo = prepare(langs, args.limit)
    (REPO / args.manifest).write_text(json.dumps(todo, indent=1, ensure_ascii=False))
    print(f"Prepared {len(todo)} notebook/language jobs needing markdown translation.")
    print(f"Manifest: {args.manifest}")


if __name__ == "__main__":
    main()

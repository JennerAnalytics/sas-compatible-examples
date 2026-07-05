#!/usr/bin/env python3
"""Generate the example directory for README.md.

Walks every source notebook, pulls its H1 title, and emits a Markdown index
grouped by SAS procedure (procs/<proc>/<slug>) and by industry domain, with a
links to each notebook and to its 15 translations. Writes between the markers
  <!-- BEGIN EXAMPLE INDEX --> ... <!-- END EXAMPLE INDEX -->
in README.md (creating them at end of file if absent).
"""
import json, re
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
LANGS = ["cs","da","de","el","es","fi","fr","it","ja","ko","nl","pl","pt","sv","zh"]
BEGIN, END = "<!-- BEGIN EXAMPLE INDEX -->", "<!-- END EXAMPLE INDEX -->"

INDUSTRIES = ["banking_and_financial_services","education","energy_and_utilities",
    "government_and_public_sector","healthcare_providers","hospitality_and_travel",
    "insurance","media_and_advertising","pharmaceuticals_and_life_sciences",
    "real_estate","retail_and_consumer_goods","telecommunications",
    "transportation_and_logistics","CRO"]

def title_of(nb_path):
    nb = json.loads(nb_path.read_text())
    for c in nb["cells"]:
        if c["cell_type"] == "markdown":
            txt = "".join(c["source"])
            m = re.search(r"^#\s+(.+)$", txt, re.M)
            if m:
                t = m.group(1).strip()
                t = re.sub(r"<[^>]+>", "", t).strip()   # drop any inline html
                if t:
                    return t
    return nb_path.parent.name.replace("_", " ").title()

def humanize(slug):
    return slug.replace("_", " ")

def translated_langs(rel):
    """Which of the 15 languages have this notebook translated."""
    import sys
    sys.path.insert(0, str(REPO/"tools"))
    from prepare_translation_batch import md_translated
    en = json.loads((REPO/rel).read_text())
    out = []
    for l in LANGS:
        p = REPO/"translations"/l/rel
        if p.exists():
            try:
                if md_translated(en, json.loads(p.read_text())):
                    out.append(l)
            except Exception:
                pass
    return out

def build():
    lines = [BEGIN, "", "## Example directory", "",
             "Every example below is a validated, content-reviewed notebook. "
             "The 🌐 column links to available translations (markdown narrative "
             "+ code) under [`translations/`](translations/).", ""]

    # By procedure
    procs = sorted(REPO.glob("procs/*/*/notebook.ipynb"))
    by_proc = {}
    for p in procs:
        by_proc.setdefault(p.parent.parent.name, []).append(p)
    lines += [f"### By SAS procedure ({len(procs)} examples)", ""]
    for proc in sorted(by_proc):
        lines.append(f"**{proc.upper()}**")
        lines.append("")
        for nb in sorted(by_proc[proc]):
            rel = nb.relative_to(REPO).as_posix()
            tl = translated_langs(rel)
            langlinks = " · ".join(f"[{l}](translations/{l}/{rel})" for l in tl)
            badge = f" — 🌐 {langlinks}" if tl else ""
            lines.append(f"- [{title_of(nb)}]({rel}){badge}")
        lines.append("")

    # By industry
    inds = []
    for ind in INDUSTRIES:
        inds += sorted((REPO/ind).glob("*/notebook.ipynb")) if (REPO/ind).exists() else []
    if inds:
        lines += [f"### By industry ({len(inds)} examples)", ""]
        for ind in INDUSTRIES:
            d = REPO/ind
            nbs = sorted(d.glob("*/notebook.ipynb")) if d.exists() else []
            if not nbs:
                continue
            lines.append(f"**{humanize(ind).title()}**")
            lines.append("")
            for nb in nbs:
                rel = nb.relative_to(REPO).as_posix()
                tl = translated_langs(rel)
                langlinks = " · ".join(f"[{l}](translations/{l}/{rel})" for l in tl)
                badge = f" — 🌐 {langlinks}" if tl else ""
                lines.append(f"- [{title_of(nb)}]({rel}){badge}")
            lines.append("")
    lines.append(END)
    return "\n".join(lines)

def main():
    readme = REPO/"README.md"
    text = readme.read_text()
    index = build()
    if BEGIN in text and END in text:
        text = re.sub(re.escape(BEGIN)+r".*?"+re.escape(END), index, text, flags=re.S)
    else:
        text = text.rstrip()+"\n\n"+index+"\n"
    readme.write_text(text)
    n = index.count("\n- ")
    print(f"README index rebuilt: {n} example entries")

if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""Translate Jenner/SAS-compatible programs between natural languages.

Jenner lets you write DATA step and PROC code in 26 natural languages —
``DONNÉES`` (French), ``データ`` (Japanese), ``DATOS`` (Spanish), and so on
all parse exactly like ``DATA``. This tool converts the *keywords* of a
program from any supported language to any other, in either direction,
without needing the jenner binary. It handles both plain ``.jenner`` /
``.sas`` scripts and Jupyter notebooks (``.ipynb`` — only code cells are
touched; markdown, outputs, and metadata are preserved byte-for-byte).

It is a faithful port of ``jenner translate`` from the Jenner engine:
string literals and block comments are never modified, variable names and
data values pass through untouched, and keyword resolution order matches
the engine, so both tools produce identical output.

Usage:
    python3 translate.py --to fr program.jenner            # English → French
    python3 translate.py --to en programme_fr.jenner       # French → English
    python3 translate.py --to ja -o out.ipynb nb.ipynb     # notebook → Japanese
    python3 translate.py --to es --from en,fr mixed.jenner # restrict sources
    python3 translate.py --list-languages

Only the Python standard library is required (Python 3.8+). The keyword
tables live in ``keywords.json`` next to this script, exported from the
Jenner engine's ``src/i18n/data/keywords/*.toml`` files.
"""
import argparse
import json
import sys
import unicodedata
from pathlib import Path

KEYWORDS_JSON = Path(__file__).resolve().parent / "keywords.json"


def norm(surface: str) -> str:
    """NFC-normalize and uppercase — matches the engine's lookup key."""
    return unicodedata.normalize("NFC", surface).upper()


class LanguageMap:
    """Keyword tables for all languages, with engine-identical resolution."""

    def __init__(self, data: dict):
        self.order = data["language_order"]
        self.names = {}
        # lang -> token -> primary surface
        self.forward = {}
        # lang -> normalized surface -> token
        self.reverse = {}
        for code in self.order:
            lang = data["languages"][code]
            self.names[code] = lang["name"]
            fwd, rev = {}, {}
            for token, surfaces in lang["keywords"].items():
                fwd[token] = surfaces[0]
                for s in surfaces:
                    rev[norm(s)] = token
            self.forward[code] = fwd
            self.reverse[code] = rev

    def resolve_in(self, surface: str, source_langs):
        """Surface form -> canonical token, searching languages in engine order."""
        key = norm(surface)
        for code in self.order:
            if not source_langs or code in source_langs:
                token = self.reverse[code].get(key)
                if token is not None:
                    return token
        return None

    def surface_for(self, token: str, target: str):
        """Canonical token -> primary surface in target language (English fallback)."""
        surface = self.forward.get(target, {}).get(token)
        if surface is None and target != "en":
            surface = self.forward["en"].get(token)
        return surface

    def is_in_language(self, surface: str, code: str) -> bool:
        return norm(surface) in self.reverse.get(code, {})


def is_word_start(ch: str) -> bool:
    return ch.isalpha() or ch == "_"


def is_word_continue(ch: str) -> bool:
    return ch.isalnum() or ch == "_"


def apply_case(surface: str, style: str) -> str:
    if style == "lower":
        return surface.lower()
    if style == "title":
        return surface[:1].upper() + surface[1:].lower() if surface else surface
    return surface.upper()


class Translator:
    def __init__(self, lang_map, source_langs, target, case_style="upper"):
        self.map = lang_map
        self.source_langs = source_langs
        self.target = target
        self.case_style = case_style
        self.stats = {"translated": 0, "recognized": 0, "already_target": 0}

    def translate_source(self, source: str) -> str:
        """Scan .jenner source, translating keywords and preserving all else."""
        # In auto-detect mode (no --from, or a broad list), skip single ASCII
        # letters: they are loop variables (i, j, x), not keywords. Single-char
        # CJK keywords (他, 非) are still translated.
        auto_detect = not self.source_langs or len(self.source_langs) > 2
        out = []
        i, n = 0, len(source)
        while i < n:
            ch = source[i]
            if ch in ("'", '"'):
                end = self._scan_string(source, i, ch)
                out.append(source[i:end])
                i = end
                continue
            if ch == "/" and i + 1 < n and source[i + 1] == "*":
                end = self._scan_block_comment(source, i)
                out.append(source[i:end])
                i = end
                continue
            if is_word_start(ch):
                start = i
                while i < n and is_word_continue(source[i]):
                    i += 1
                word = source[start:i]
                skip_short = auto_detect and len(word) == 1 and word.isascii()
                token = None if skip_short else self.map.resolve_in(word, self.source_langs)
                if token is not None:
                    self.stats["recognized"] += 1
                    if self.map.is_in_language(word, self.target):
                        self.stats["already_target"] += 1
                        out.append(word)
                    else:
                        surface = self.map.surface_for(token, self.target)
                        if surface is not None:
                            self.stats["translated"] += 1
                            out.append(apply_case(surface, self.case_style))
                        else:
                            out.append(word)
                else:
                    out.append(word)
                continue
            out.append(ch)
            i += 1
        return "".join(out)

    def translate_notebook(self, text: str) -> str:
        """Translate code cells of an .ipynb; markdown and outputs untouched."""
        nb = json.loads(text)
        for cell in nb.get("cells", []):
            if cell.get("cell_type") != "code":
                continue
            src = cell.get("source", [])
            if isinstance(src, str):
                cell["source"] = self.translate_source(src)
                continue
            joined = "".join(src)
            translated = self.translate_source(joined)
            # Split back preserving the one-string-per-line convention
            lines = translated.splitlines(keepends=True)
            cell["source"] = lines if lines else [""]
        return json.dumps(nb, ensure_ascii=False, indent=1) + "\n"

    @staticmethod
    def _scan_string(source: str, start: int, quote: str) -> int:
        i = start + 1
        n = len(source)
        while i < n:
            if source[i] == quote:
                if i + 1 < n and source[i + 1] == quote:  # doubled-quote escape
                    i += 2
                else:
                    return i + 1
            else:
                i += 1
        return n  # unterminated — pass the rest through

    @staticmethod
    def _scan_block_comment(source: str, start: int) -> int:
        end = source.find("*/", start + 2)
        return len(source) if end == -1 else end + 2


def main() -> int:
    ap = argparse.ArgumentParser(
        description="Translate Jenner program keywords between natural languages.")
    ap.add_argument("input", nargs="?", help="input file (.jenner, .sas, or .ipynb)")
    ap.add_argument("-t", "--to", dest="to_lang", help="target language code (required)")
    ap.add_argument("-f", "--from", dest="from_langs", default="",
                    help="comma-separated source language(s); default: auto-detect")
    ap.add_argument("-o", "--output", help="output file; default: stdout")
    ap.add_argument("--case", choices=["upper", "lower", "title"], default="upper",
                    help="case style for translated keywords (default: upper)")
    ap.add_argument("--list-languages", action="store_true",
                    help="list supported language codes and exit")
    args = ap.parse_args()

    with open(KEYWORDS_JSON, encoding="utf-8") as f:
        lang_map = LanguageMap(json.load(f))

    if args.list_languages:
        for code in lang_map.order:
            print(f"{code:4} {lang_map.names[code]:12} "
                  f"{len(lang_map.forward[code])} keywords")
        return 0

    if not args.input or not args.to_lang:
        ap.error("an input file and --to <LANG> are required")
    if args.to_lang not in lang_map.forward:
        ap.error(f"unknown target language '{args.to_lang}' "
                 f"(see --list-languages)")
    source_langs = [s for s in args.from_langs.split(",") if s]
    for code in source_langs:
        if code not in lang_map.forward:
            ap.error(f"unknown source language '{code}' (see --list-languages)")

    text = Path(args.input).read_text(encoding="utf-8")
    tr = Translator(lang_map, source_langs, args.to_lang, args.case)
    if args.input.endswith(".ipynb"):
        result = tr.translate_notebook(text)
    else:
        result = tr.translate_source(text)

    if args.output:
        Path(args.output).write_text(result, encoding="utf-8")
        print(f"Translated '{args.input}' -> '{args.output}'", file=sys.stderr)
        print(f"  {tr.stats['translated']} keywords translated", file=sys.stderr)
    else:
        sys.stdout.write(result)
    return 0


if __name__ == "__main__":
    sys.exit(main())

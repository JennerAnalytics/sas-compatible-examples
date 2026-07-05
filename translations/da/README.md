# SAS-kompatible eksempler (Jenner)

🌐 [English](../../README.md) · [Čeština](../cs/README.md) · [Deutsch](../de/README.md) · [Ελληνικά](../el/README.md) · [Español](../es/README.md) · [Suomi](../fi/README.md) · [Français](../fr/README.md) · [Italiano](../it/README.md) · [日本語](../ja/README.md) · [한국어](../ko/README.md) · [Nederlands](../nl/README.md) · [Polski](../pl/README.md) · [Português](../pt/README.md) · [Svenska](../sv/README.md) · [中文](../zh/README.md)

En kurateret, **valideret** samling af analytiske eksempel-notebooks, der kører
på [Jenner](https://jenneranalytics.com) — en SAS-kompatibel DATA step- og
PROC-motor.

Hver notebook, der udgives her, har gennemgået en **indholdsgennemgang med fokus
på sandfærdighed**, ikke blot et tjek af, at den kan køre:

- Den kører fejlfrit i Jenners Jupyter-kernel, og **de udførte outputs (tabeller
  og grafer) er indlejret** — læs resultaterne direkte på GitHub uden at
  downloade eller genkøre noget.
- Hvert tal og hver konklusion i fortællingen er **forankret i notebookens
  faktiske output** — ingen forudskrevne eller opdigtede resultater.
- Hvert genereret billede er **visuelt gennemgået**.
- Den annoncerede SAS-procedure er den, der faktisk udføres.

Notebooks, der ikke levede op til denne standard, blev udeladt frem for
udgivet. Det er et bevidst lille sæt med høj troværdighed; det vokser,
efterhånden som flere eksempler består gennemgangen.

## Notebooks på dansk

Denne mappe indeholder de danske versioner af notebooks: både
markdown-fortællingen **og** kodens nøgleord er oversat (`SÆT`, `KØR`, …).
Jenner kører disse programmer, som de er — motoren registrerer sproget
automatisk. Variabelnavne og dataværdier er uændrede, så de matcher de
indlejrede outputs.

- `procs/<procedure>/<emne>/` — eksempler ordnet efter SAS-procedure.
- `<branche>/<emne>/` — eksempler ordnet efter domæne.

## Kør et eksempel

```bash
jenner jupyter install
jupyter lab
```

Vælg **Jenner**-kernen og kør "Run All". Da outputs allerede er indlejret, kan
du også bare læse hver notebook, som den er.

## Oversæt programmer

Brug [`tools/translate.py`](../../tools/README.md) til at konvertere ethvert
program eller enhver notebook mellem sprog — i begge retninger:

```bash
python3 tools/translate.py --to da program.jenner   # engelsk → dansk
python3 tools/translate.py --to en program.jenner   # dansk → engelsk
```

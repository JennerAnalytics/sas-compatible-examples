# SAS-compatibele voorbeelden (Jenner)

🌐 [English](../../README.md) · [Čeština](../cs/README.md) · [Dansk](../da/README.md) · [Deutsch](../de/README.md) · [Ελληνικά](../el/README.md) · [Español](../es/README.md) · [Suomi](../fi/README.md) · [Français](../fr/README.md) · [Italiano](../it/README.md) · [日本語](../ja/README.md) · [한국어](../ko/README.md) · [Polski](../pl/README.md) · [Português](../pt/README.md) · [Svenska](../sv/README.md) · [中文](../zh/README.md)

Een samengestelde, **gevalideerde** verzameling analytische voorbeeldnotebooks
die draaien op [Jenner](https://jenneranalytics.com) — een SAS-compatibele DATA
step- en PROC-engine.

Elk notebook dat hier wordt gepubliceerd, heeft een **inhoudelijke controle op
waarheidsgetrouwheid** ondergaan, niet slechts een controle of het draait:

- Het draait foutloos in de Jupyter-kernel van Jenner, en **de uitgevoerde
  uitvoer (tabellen en grafieken) is ingesloten** — lees de resultaten direct
  op GitHub zonder iets te downloaden of opnieuw uit te voeren.
- Elk getal en elke conclusie in het verhaal is **gefundeerd op de werkelijke
  uitvoer van het notebook** — geen vooraf geschreven of verzonnen bevindingen.
- Elke gegenereerde afbeelding is **visueel beoordeeld**.
- De aangekondigde SAS-procedure is de procedure die daadwerkelijk wordt
  uitgevoerd.

Notebooks die deze lat niet haalden, zijn uitgesloten in plaats van
gepubliceerd. Het is een bewust kleine, zeer betrouwbare set; hij groeit
naarmate meer voorbeelden de beoordeling doorstaan.

## Notebooks in het Nederlands

Deze map bevat de Nederlandse versies van de notebooks: zowel het
markdown-verhaal **als** de trefwoorden van de code zijn vertaald
(`GEGEVENS`, `INSTELLEN`, `UITVOEREN`, …). Jenner voert deze programma's
ongewijzigd uit — de engine detecteert de taal automatisch. Variabelenamen en
gegevenswaarden blijven onveranderd, zodat ze overeenkomen met de ingesloten
uitvoer.

- `procs/<procedure>/<onderwerp>/` — voorbeelden geordend per SAS-procedure.
- `<sector>/<onderwerp>/` — voorbeelden geordend per domein.

## Een voorbeeld uitvoeren

```bash
jenner jupyter install
jupyter lab
```

Selecteer de **Jenner**-kernel en voer "Run All" uit. Omdat de uitvoer al is
ingesloten, kunt u elk notebook ook gewoon lezen zoals het is.

## Programma's vertalen

Gebruik [`tools/translate.py`](../../tools/README.md) om elk programma of
notebook tussen talen om te zetten — in beide richtingen:

```bash
python3 tools/translate.py --to nl programma.jenner   # Engels → Nederlands
python3 tools/translate.py --to en programma.jenner   # Nederlands → Engels
```

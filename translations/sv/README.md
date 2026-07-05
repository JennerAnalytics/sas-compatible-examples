# SAS-kompatibla exempel (Jenner)

🌐 [English](../../README.md) · [Čeština](../cs/README.md) · [Dansk](../da/README.md) · [Deutsch](../de/README.md) · [Ελληνικά](../el/README.md) · [Español](../es/README.md) · [Suomi](../fi/README.md) · [Français](../fr/README.md) · [Italiano](../it/README.md) · [日本語](../ja/README.md) · [한국어](../ko/README.md) · [Nederlands](../nl/README.md) · [Polski](../pl/README.md) · [Português](../pt/README.md) · [中文](../zh/README.md)

En kurerad, **validerad** samling analytiska exempel-notebooks som körs på
[Jenner](https://jenneranalytics.com) — en SAS-kompatibel DATA step- och
PROC-motor.

Varje notebook som publiceras här har genomgått en **innehållsgranskning med
fokus på sanningshalt**, inte bara en kontroll av att den kan köras:

- Den körs felfritt i Jenners Jupyter-kärna, och **körningens utdata (tabeller
  och diagram) är inbäddade** — läs resultaten direkt på GitHub utan att ladda
  ner eller köra om något.
- Varje siffra och slutsats i berättelsen är **förankrad i notebookens verkliga
  utdata** — inga förskrivna eller påhittade resultat.
- Varje genererad bild har **granskats visuellt**.
- Den utannonserade SAS-proceduren är den som faktiskt körs.

Notebooks som inte nådde denna nivå uteslöts i stället för att publiceras. Det
är en medvetet liten samling med högt förtroende; den växer i takt med att fler
exempel klarar granskningen.

## Notebooks på svenska

Denna katalog innehåller de svenska versionerna av notebooks: både
markdown-berättelsen **och** kodens nyckelord är översatta (`STÄLL_IN`, `KÖR`,
…). Jenner kör dessa program som de är — motorn känner igen språket
automatiskt. Variabelnamn och datavärden är oförändrade så att de matchar de
inbäddade utdata.

- `procs/<procedur>/<ämne>/` — exempel ordnade efter SAS-procedur.
- `<bransch>/<ämne>/` — exempel ordnade efter domän.

## Köra ett exempel

```bash
jenner jupyter install
jupyter lab
```

Välj **Jenner**-kärnan och kör "Run All". Eftersom utdata redan är inbäddade
kan du också bara läsa varje notebook som den är.

## Översätta program

Använd [`tools/translate.py`](../../tools/README.md) för att konvertera vilket
program eller vilken notebook som helst mellan språk — i båda riktningarna:

```bash
python3 tools/translate.py --to sv program.jenner   # engelska → svenska
python3 tools/translate.py --to en program.jenner   # svenska → engelska
```

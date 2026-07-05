# Příklady kompatibilní se SAS (Jenner)

🌐 [English](../../README.md) · [Dansk](../da/README.md) · [Deutsch](../de/README.md) · [Ελληνικά](../el/README.md) · [Español](../es/README.md) · [Suomi](../fi/README.md) · [Français](../fr/README.md) · [Italiano](../it/README.md) · [日本語](../ja/README.md) · [한국어](../ko/README.md) · [Nederlands](../nl/README.md) · [Polski](../pl/README.md) · [Português](../pt/README.md) · [Svenska](../sv/README.md) · [中文](../zh/README.md)

Pečlivě vybraná a **ověřená** sbírka ukázkových analytických notebooků, které
běží na [Jenneru](https://jenneranalytics.com) — enginu DATA stepů a procedur
kompatibilním se SAS.

Každý zde zveřejněný notebook prošel **obsahovou kontrolou pravdivosti**, nejen
ověřením, že se spustí:

- Běží bez chyb v Jupyter kernelu Jenneru a **výstupy z běhu (tabulky a grafy)
  jsou vložené** — výsledky si přečtete přímo na GitHubu, bez stahování a bez
  opětovného spouštění.
- Každé číslo a každý závěr ve výkladu je **podložen skutečným výstupem
  notebooku** — žádné předem napsané ani smyšlené výsledky.
- Každý vygenerovaný obrázek byl **vizuálně zkontrolován**.
- Uvedená procedura SAS je ta, která se skutečně vykonává.

Notebooky, které tuto laťku nesplnily, byly vyřazeny, nikoli zveřejněny. Jde o
záměrně malou a vysoce důvěryhodnou sadu; roste s tím, jak další příklady
procházejí kontrolou.

## Notebooky v češtině

Tento adresář obsahuje české verze notebooků: přeložen je výklad v markdownu
**i** klíčová slova kódu (`NASTAVIT`, `SPUSTIT`, …). Jenner tyto programy
spouští tak, jak jsou — engine jazyk rozpozná automaticky. Názvy proměnných a
hodnoty dat zůstávají beze změny, aby odpovídaly vloženým výstupům.

- `procs/<procedura>/<téma>/` — příklady uspořádané podle procedury SAS.
- `<odvětví>/<téma>/` — příklady uspořádané podle oboru.

## Spuštění příkladu

```bash
jenner jupyter install
jupyter lab
```

Vyberte kernel **Jenner** a spusťte „Run All". Protože výstupy jsou už vložené,
můžete si každý notebook také jen přečíst.

## Překlad programů

K převodu libovolného programu nebo notebooku mezi jazyky — oběma směry —
použijte [`tools/translate.py`](../../tools/README.md):

```bash
python3 tools/translate.py --to cs program.jenner   # angličtina → čeština
python3 tools/translate.py --to en program.jenner   # čeština → angličtina
```

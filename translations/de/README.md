# SAS-kompatible Beispiele (Jenner)

🌐 [English](../../README.md) · [Čeština](../cs/README.md) · [Dansk](../da/README.md) · [Ελληνικά](../el/README.md) · [Español](../es/README.md) · [Suomi](../fi/README.md) · [Français](../fr/README.md) · [Italiano](../it/README.md) · [日本語](../ja/README.md) · [한국어](../ko/README.md) · [Nederlands](../nl/README.md) · [Polski](../pl/README.md) · [Português](../pt/README.md) · [Svenska](../sv/README.md) · [中文](../zh/README.md)

Eine kuratierte, **validierte** Sammlung analytischer Beispiel-Notebooks, die auf
[Jenner](https://jenneranalytics.com) laufen — einer SAS-kompatiblen DATA-Step-
und PROC-Engine.

Jedes hier veröffentlichte Notebook wurde **inhaltlich auf Wahrhaftigkeit
geprüft**, nicht nur auf Lauffähigkeit:

- Es läuft fehlerfrei im Jupyter-Kernel von Jenner, und **die erzeugten Ausgaben
  (Tabellen und Grafiken) sind eingebettet** — lesen Sie die Ergebnisse direkt
  auf GitHub, ohne etwas herunterzuladen oder erneut auszuführen.
- Jede Zahl und jede Schlussfolgerung im Text ist **in der tatsächlichen Ausgabe
  des Notebooks verankert** — keine vorgefertigten oder erfundenen Befunde.
- Jedes erzeugte Bild wurde **visuell geprüft**.
- Die angekündigte SAS-Prozedur ist diejenige, die tatsächlich ausgeführt wird.

Notebooks, die diesen Anspruch nicht erfüllten, wurden ausgeschlossen statt
veröffentlicht. Es ist eine bewusst kleine, vertrauenswürdige Sammlung; sie
wächst, sobald weitere Beispiele die Prüfung bestehen.

## Notebooks auf Deutsch

Dieses Verzeichnis enthält die deutschen Fassungen der Notebooks: Sowohl der
Markdown-Text **als auch** die Schlüsselwörter des Codes sind übersetzt
(`DATEN`, `FESTLEGEN`, `AUSFÜHREN`, …). Jenner führt diese Programme unverändert
aus — die Engine erkennt die Sprache automatisch. Variablennamen und Datenwerte
bleiben unverändert, damit sie zu den eingebetteten Ausgaben passen.

- `procs/<Prozedur>/<Thema>/` — Beispiele nach SAS-Prozedur geordnet.
- `<Branche>/<Thema>/` — Beispiele nach Fachgebiet geordnet.

## Ein Beispiel ausführen

```bash
jenner jupyter install
jupyter lab
```

Wählen Sie den **Jenner**-Kernel und führen Sie „Run All" aus. Da die Ausgaben
bereits eingebettet sind, können Sie jedes Notebook auch einfach so lesen.

## Programme übersetzen

Um ein Programm oder Notebook zwischen Sprachen zu konvertieren — in beide
Richtungen — verwenden Sie [`tools/translate.py`](../../tools/README.md):

```bash
python3 tools/translate.py --to de programm.jenner   # Englisch → Deutsch
python3 tools/translate.py --to en programm.jenner   # Deutsch → Englisch
```

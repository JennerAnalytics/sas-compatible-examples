# Esempi compatibili SAS (Jenner)

🌐 [English](../../README.md) · [Čeština](../cs/README.md) · [Dansk](../da/README.md) · [Deutsch](../de/README.md) · [Ελληνικά](../el/README.md) · [Español](../es/README.md) · [Suomi](../fi/README.md) · [Français](../fr/README.md) · [日本語](../ja/README.md) · [한국어](../ko/README.md) · [Nederlands](../nl/README.md) · [Polski](../pl/README.md) · [Português](../pt/README.md) · [Svenska](../sv/README.md) · [中文](../zh/README.md)

Una raccolta curata e **validata** di notebook di esempi analitici che girano su
[Jenner](https://jenneranalytics.com) — un motore DATA step e PROC compatibile
con SAS.

Ogni notebook pubblicato qui è stato sottoposto a una **revisione dei contenuti
incentrata sulla veridicità**, non solo a una verifica di esecuzione:

- Gira senza errori nel kernel Jupyter di Jenner, e **gli output eseguiti
  (tabelle e grafici) sono incorporati** — leggi i risultati direttamente su
  GitHub senza scaricare né rieseguire nulla.
- Ogni numero e ogni conclusione della narrazione è **fondato sull'output reale
  del notebook** — nessun risultato prescritto o inventato.
- Ogni immagine generata è stata **revisionata visivamente**.
- La procedura SAS annunciata è quella effettivamente eseguita.

I notebook che non hanno raggiunto questo standard sono stati esclusi anziché
pubblicati. È un insieme volutamente piccolo e ad alta affidabilità; cresce man
mano che altri esempi superano la revisione.

## Notebook in italiano

Questa directory contiene le versioni italiane dei notebook: la narrazione in
markdown **e** le parole chiave del codice sono tradotte (`DATI`, `IMPOSTARE`,
`ESEGUIRE`, …). Jenner esegue questi programmi così come sono — il motore rileva
automaticamente la lingua. I nomi delle variabili e i valori dei dati restano
invariati, per corrispondere agli output incorporati.

- `procs/<procedura>/<tema>/` — esempi organizzati per procedura SAS.
- `<settore>/<tema>/` — esempi organizzati per dominio.

## Eseguire un esempio

```bash
jenner jupyter install
jupyter lab
```

Seleziona il kernel **Jenner** ed esegui "Run All". Poiché gli output sono già
incorporati, puoi anche semplicemente leggere ogni notebook così com'è.

## Tradurre i programmi

Per convertire qualsiasi programma o notebook tra le lingue — in entrambe le
direzioni — usa [`tools/translate.py`](../../tools/README.md):

```bash
python3 tools/translate.py --to it programma.jenner   # inglese → italiano
python3 tools/translate.py --to en programma.jenner   # italiano → inglese
```

# SAS-yhteensopivat esimerkit (Jenner)

🌐 [English](../../README.md) · [Čeština](../cs/README.md) · [Dansk](../da/README.md) · [Deutsch](../de/README.md) · [Ελληνικά](../el/README.md) · [Español](../es/README.md) · [Français](../fr/README.md) · [Italiano](../it/README.md) · [日本語](../ja/README.md) · [한국어](../ko/README.md) · [Nederlands](../nl/README.md) · [Polski](../pl/README.md) · [Português](../pt/README.md) · [Svenska](../sv/README.md) · [中文](../zh/README.md)

Kuratoitu ja **validoitu** kokoelma analyyttisiä esimerkkimuistikirjoja, jotka
toimivat [Jennerillä](https://jenneranalytics.com) — SAS-yhteensopivalla DATA
step- ja PROC-moottorilla.

Jokainen täällä julkaistu muistikirja on käynyt läpi **sisällön
totuudenmukaisuustarkastuksen**, ei pelkkää suoritettavuuden varmistusta:

- Se toimii virheettä Jennerin Jupyter-ytimessä, ja **suoritetut tulosteet
  (taulukot ja kuvaajat) on upotettu** — lue tulokset suoraan GitHubissa
  lataamatta tai ajamatta mitään uudelleen.
- Jokainen kertomuksen luku ja johtopäätös **perustuu muistikirjan todelliseen
  tulosteeseen** — ei ennalta kirjoitettuja tai keksittyjä tuloksia.
- Jokainen tuotettu kuva on **tarkastettu silmämääräisesti**.
- Ilmoitettu SAS-proseduuri on se, joka todella suoritetaan.

Muistikirjat, jotka eivät yltäneet tälle tasolle, jätettiin pois julkaisematta.
Kyseessä on tarkoituksella pieni ja luotettava kokoelma; se kasvaa sitä mukaa,
kun uusia esimerkkejä läpäisee tarkastuksen.

## Muistikirjat suomeksi

Tämä hakemisto sisältää muistikirjojen suomenkieliset versiot: sekä
markdown-kertomus **että** koodin avainsanat on käännetty (`TIEDOT`, `ASETA`,
`SUORITA`, …). Jenner suorittaa nämä ohjelmat sellaisenaan — moottori
tunnistaa kielen automaattisesti. Muuttujien nimet ja data-arvot on jätetty
ennalleen, jotta ne vastaavat upotettuja tulosteita.

- `procs/<proseduuri>/<aihe>/` — esimerkit SAS-proseduureittain.
- `<toimiala>/<aihe>/` — esimerkit toimialoittain.

## Esimerkin suorittaminen

```bash
jenner jupyter install
jupyter lab
```

Valitse **Jenner**-ydin ja suorita "Run All". Koska tulosteet on jo upotettu,
voit myös vain lukea kunkin muistikirjan sellaisenaan.

## Ohjelmien kääntäminen

Muunna mikä tahansa ohjelma tai muistikirja kielestä toiseen — kumpaankin
suuntaan — työkalulla [`tools/translate.py`](../../tools/README.md):

```bash
python3 tools/translate.py --to fi ohjelma.jenner   # englanti → suomi
python3 tools/translate.py --to en ohjelma.jenner   # suomi → englanti
```

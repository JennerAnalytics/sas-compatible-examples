# Przykłady zgodne z SAS (Jenner)

🌐 [English](../../README.md) · [Čeština](../cs/README.md) · [Dansk](../da/README.md) · [Deutsch](../de/README.md) · [Ελληνικά](../el/README.md) · [Español](../es/README.md) · [Suomi](../fi/README.md) · [Français](../fr/README.md) · [Italiano](../it/README.md) · [日本語](../ja/README.md) · [한국어](../ko/README.md) · [Nederlands](../nl/README.md) · [Português](../pt/README.md) · [Svenska](../sv/README.md) · [中文](../zh/README.md)

Starannie dobrana i **zweryfikowana** kolekcja analitycznych notatników z
przykładami, działających na [Jennerze](https://jenneranalytics.com) — silniku
DATA step i PROC zgodnym z SAS.

Każdy opublikowany tu notatnik przeszedł **przegląd treści pod kątem
prawdziwości**, a nie tylko sprawdzenie, czy się uruchamia:

- Działa bezbłędnie w jądrze Jupyter Jennera, a **wyniki wykonania (tabele i
  wykresy) są osadzone** — czytaj rezultaty bezpośrednio na GitHubie, bez
  pobierania i ponownego uruchamiania.
- Każda liczba i każdy wniosek w narracji jest **ugruntowany w rzeczywistym
  wyniku notatnika** — żadnych z góry napisanych ani sfabrykowanych ustaleń.
- Każdy wygenerowany obraz został **zweryfikowany wzrokowo**.
- Deklarowana procedura SAS jest tą, która faktycznie jest wykonywana.

Notatniki, które nie spełniły tych wymagań, zostały odrzucone, a nie
opublikowane. To celowo mały, wysoce wiarygodny zbiór; rośnie, w miarę jak
kolejne przykłady przechodzą przegląd.

## Notatniki po polsku

Ten katalog zawiera polskie wersje notatników: przetłumaczona jest narracja w
markdownie **oraz** słowa kluczowe kodu (`DANE`, `USTAW`, `WYKONAJ`, …).
Jenner wykonuje te programy bez zmian — silnik automatycznie wykrywa język.
Nazwy zmiennych i wartości danych pozostają niezmienione, aby odpowiadały
osadzonym wynikom.

- `procs/<procedura>/<temat>/` — przykłady uporządkowane według procedury SAS.
- `<branża>/<temat>/` — przykłady uporządkowane według dziedziny.

## Uruchamianie przykładu

```bash
jenner jupyter install
jupyter lab
```

Wybierz jądro **Jenner** i uruchom „Run All". Ponieważ wyniki są już osadzone,
możesz też po prostu przeczytać każdy notatnik w obecnej postaci.

## Tłumaczenie programów

Aby przekonwertować dowolny program lub notatnik między językami — w obu
kierunkach — użyj [`tools/translate.py`](../../tools/README.md):

```bash
python3 tools/translate.py --to pl program.jenner   # angielski → polski
python3 tools/translate.py --to en program.jenner   # polski → angielski
```

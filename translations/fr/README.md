# Exemples compatibles SAS (Jenner)

🌐 [English](../../README.md) · [Čeština](../cs/README.md) · [Dansk](../da/README.md) · [Deutsch](../de/README.md) · [Ελληνικά](../el/README.md) · [Español](../es/README.md) · [Suomi](../fi/README.md) · [Italiano](../it/README.md) · [日本語](../ja/README.md) · [한국어](../ko/README.md) · [Nederlands](../nl/README.md) · [Polski](../pl/README.md) · [Português](../pt/README.md) · [Svenska](../sv/README.md) · [中文](../zh/README.md)

Une collection organisée et **validée** de notebooks d'exemples analytiques qui
s'exécutent sur [Jenner](https://jenneranalytics.com) — un moteur DATA step et
PROC compatible SAS.

Chaque notebook publié ici a fait l'objet d'une **revue de contenu portant sur sa
véracité**, et pas seulement d'une vérification d'exécution :

- Il s'exécute sans erreur dans le noyau Jupyter de Jenner, et **les sorties
  produites (tableaux et graphiques) sont intégrées** — lisez les résultats
  directement sur GitHub, sans rien télécharger ni ré-exécuter.
- Chaque nombre et chaque conclusion du récit est **fondé sur la sortie réelle du
  notebook** — aucun résultat pré-rédigé ou fabriqué.
- Chaque image générée a été **revue visuellement**.
- La procédure SAS annoncée est bien celle réellement exécutée.

Les notebooks qui ne satisfaisaient pas à ces exigences ont été écartés plutôt que
publiés. C'est un ensemble volontairement restreint et digne de confiance ; il
s'agrandit à mesure que de nouveaux exemples passent la revue.

## Notebooks en français

Ce répertoire contient les versions françaises des notebooks : le récit en
markdown **et** les mots-clés du code sont traduits (`DONNÉES`, `DÉFINIR`,
`EXÉCUTER`, …). Jenner exécute ces programmes tels quels — le moteur détecte
automatiquement la langue. Les noms de variables et les valeurs des données
restent inchangés afin de correspondre aux sorties intégrées.

- `procs/<procédure>/<sujet>/` — exemples organisés par procédure SAS.
- `<secteur>/<sujet>/` — exemples organisés par domaine.

## Exécuter un exemple

```bash
jenner jupyter install
jupyter lab
```

Sélectionnez le noyau **Jenner** puis « Run All ». Les sorties étant déjà
intégrées, vous pouvez aussi simplement lire chaque notebook tel quel.

## Traduire des programmes

Pour convertir n'importe quel programme ou notebook d'une langue vers une autre
— dans les deux sens — utilisez [`tools/translate.py`](../../tools/README.md) :

```bash
python3 tools/translate.py --to fr programme.jenner   # anglais → français
python3 tools/translate.py --to en programme.jenner   # français → anglais
```

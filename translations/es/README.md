# Ejemplos compatibles con SAS (Jenner)

🌐 [English](../../README.md) · [Čeština](../cs/README.md) · [Dansk](../da/README.md) · [Deutsch](../de/README.md) · [Ελληνικά](../el/README.md) · [Suomi](../fi/README.md) · [Français](../fr/README.md) · [Italiano](../it/README.md) · [日本語](../ja/README.md) · [한국어](../ko/README.md) · [Nederlands](../nl/README.md) · [Polski](../pl/README.md) · [Português](../pt/README.md) · [Svenska](../sv/README.md) · [中文](../zh/README.md)

Una colección curada y **validada** de notebooks de ejemplos analíticos que se
ejecutan en [Jenner](https://jenneranalytics.com), un motor DATA step y PROC
compatible con SAS.

Cada notebook publicado aquí ha pasado una **revisión de contenido centrada en su
veracidad**, no solo una comprobación de que se ejecuta:

- Se ejecuta sin errores en el kernel de Jupyter de Jenner, y **las salidas
  generadas (tablas y gráficos) están incrustadas**: lea los resultados
  directamente en GitHub sin descargar ni volver a ejecutar nada.
- Cada número y cada conclusión de la narrativa está **fundamentado en la salida
  real del notebook**: sin hallazgos preescritos ni fabricados.
- Cada imagen generada ha sido **revisada visualmente**.
- El procedimiento SAS anunciado es el que realmente se ejecuta.

Los notebooks que no alcanzaron este nivel se excluyeron en lugar de publicarse.
Es un conjunto deliberadamente pequeño y de alta confianza; crece a medida que
más ejemplos superan la revisión.

## Notebooks en español

Este directorio contiene las versiones en español de los notebooks: la narrativa
en markdown **y** las palabras clave del código están traducidas (`DATOS`,
`ESTABLECER`, `EJECUTAR`, …). Jenner ejecuta estos programas tal cual: el motor
detecta el idioma automáticamente. Los nombres de variables y los valores de los
datos no se modifican, para que coincidan con las salidas incrustadas.

- `procs/<procedimiento>/<tema>/` — ejemplos organizados por procedimiento SAS.
- `<sector>/<tema>/` — ejemplos organizados por dominio.

## Ejecutar un ejemplo

```bash
jenner jupyter install
jupyter lab
```

Seleccione el kernel **Jenner** y ejecute «Run All». Como las salidas ya están
incrustadas, también puede simplemente leer cada notebook tal como está.

## Traducir programas

Para convertir cualquier programa o notebook de un idioma a otro —en ambas
direcciones— use [`tools/translate.py`](../../tools/README.md):

```bash
python3 tools/translate.py --to es programa.jenner   # inglés → español
python3 tools/translate.py --to en programa.jenner   # español → inglés
```

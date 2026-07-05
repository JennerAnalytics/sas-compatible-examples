# Exemplos compatíveis com SAS (Jenner)

🌐 [English](../../README.md) · [Čeština](../cs/README.md) · [Dansk](../da/README.md) · [Deutsch](../de/README.md) · [Ελληνικά](../el/README.md) · [Español](../es/README.md) · [Suomi](../fi/README.md) · [Français](../fr/README.md) · [Italiano](../it/README.md) · [日本語](../ja/README.md) · [한국어](../ko/README.md) · [Nederlands](../nl/README.md) · [Polski](../pl/README.md) · [Svenska](../sv/README.md) · [中文](../zh/README.md)

Uma coleção curada e **validada** de notebooks de exemplos analíticos que rodam
no [Jenner](https://jenneranalytics.com) — um motor DATA step e PROC compatível
com SAS.

Cada notebook publicado aqui passou por uma **revisão de conteúdo focada em
veracidade**, e não apenas por uma verificação de execução:

- Ele roda sem erros no kernel Jupyter do Jenner, e **as saídas executadas
  (tabelas e gráficos) estão incorporadas** — leia os resultados diretamente no
  GitHub, sem baixar nem reexecutar nada.
- Cada número e cada conclusão da narrativa está **fundamentado na saída real do
  notebook** — nada de resultados pré-escritos ou fabricados.
- Cada imagem gerada foi **revisada visualmente**.
- O procedimento SAS anunciado é o que de fato é executado.

Notebooks que não atingiram esse padrão foram excluídos em vez de publicados.
É um conjunto deliberadamente pequeno e de alta confiança; ele cresce à medida
que mais exemplos passam pela revisão.

## Notebooks em português

Este diretório contém as versões em português dos notebooks: a narrativa em
markdown **e** as palavras-chave do código estão traduzidas (`DADOS`,
`DEFINIR`, `EXECUTAR`, …). O Jenner executa esses programas como estão — o
motor detecta o idioma automaticamente. Os nomes de variáveis e os valores dos
dados permanecem inalterados, para corresponder às saídas incorporadas.

- `procs/<procedimento>/<tema>/` — exemplos organizados por procedimento SAS.
- `<setor>/<tema>/` — exemplos organizados por domínio.

## Executar um exemplo

```bash
jenner jupyter install
jupyter lab
```

Selecione o kernel **Jenner** e execute "Run All". Como as saídas já estão
incorporadas, você também pode simplesmente ler cada notebook como está.

## Traduzir programas

Para converter qualquer programa ou notebook entre idiomas — em ambas as
direções — use [`tools/translate.py`](../../tools/README.md):

```bash
python3 tools/translate.py --to pt programa.jenner   # inglês → português
python3 tools/translate.py --to en programa.jenner   # português → inglês
```

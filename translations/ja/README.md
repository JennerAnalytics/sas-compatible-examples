# SAS互換サンプル集（Jenner）

🌐 [English](../../README.md) · [Čeština](../cs/README.md) · [Dansk](../da/README.md) · [Deutsch](../de/README.md) · [Ελληνικά](../el/README.md) · [Español](../es/README.md) · [Suomi](../fi/README.md) · [Français](../fr/README.md) · [Italiano](../it/README.md) · [한국어](../ko/README.md) · [Nederlands](../nl/README.md) · [Polski](../pl/README.md) · [Português](../pt/README.md) · [Svenska](../sv/README.md) · [中文](../zh/README.md)

[Jenner](https://jenneranalytics.com)（SAS互換の DATA ステップ・PROC エンジン）で
動作する、厳選され**検証済み**の分析サンプルノートブック集です。

ここに公開されている各ノートブックは、単に実行できることの確認だけでなく、
**内容の真実性についてレビュー**されています。

- Jenner の Jupyter カーネルでエラーなく実行でき、**実行結果（表とグラフ）が
  埋め込まれています** — ダウンロードや再実行なしに、GitHub 上でそのまま結果を
  読めます。
- 本文中のすべての数値と結論は**ノートブックの実際の出力に基づいています** —
  事前に書かれた結果や捏造された知見はありません。
- 生成された画像はすべて**目視でレビュー済み**です。
- 表題に掲げた SAS プロシジャが、実際に実行されているものと一致します。

この基準を満たせなかったノートブックは、公開せずに除外しました。意図的に小さく
信頼性の高いセットであり、レビューを通過した例が増えるたびに拡充されます。

## 日本語のノートブック

このディレクトリには、ノートブックの日本語版が入っています。markdown の解説文
**および**コードのキーワードの両方が翻訳されています（`データ`、`設定`、
`実行` など）。Jenner はこれらのプログラムをそのまま実行できます — エンジンが
言語を自動検出します。変数名とデータ値は、埋め込まれた出力と一致するよう
変更していません。

- `procs/<プロシジャ>/<テーマ>/` — SAS プロシジャ別のサンプル。
- `<業種>/<テーマ>/` — 業務ドメイン別のサンプル。

## サンプルの実行方法

```bash
jenner jupyter install
jupyter lab
```

**Jenner** カーネルを選択して「Run All」を実行してください。出力は既に埋め込まれて
いるため、ノートブックをそのまま読むだけでも構いません。

## プログラムの翻訳

プログラムやノートブックを言語間で（双方向に）変換するには
[`tools/translate.py`](../../tools/README.md) を使います。

```bash
python3 tools/translate.py --to ja program.jenner   # 英語 → 日本語
python3 tools/translate.py --to en program.jenner   # 日本語 → 英語
```

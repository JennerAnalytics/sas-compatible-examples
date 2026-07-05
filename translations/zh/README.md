# SAS 兼容示例集（Jenner）

🌐 [English](../../README.md) · [Čeština](../cs/README.md) · [Dansk](../da/README.md) · [Deutsch](../de/README.md) · [Ελληνικά](../el/README.md) · [Español](../es/README.md) · [Suomi](../fi/README.md) · [Français](../fr/README.md) · [Italiano](../it/README.md) · [日本語](../ja/README.md) · [한국어](../ko/README.md) · [Nederlands](../nl/README.md) · [Polski](../pl/README.md) · [Português](../pt/README.md) · [Svenska](../sv/README.md)

一套经过精选并**验证**的分析示例笔记本，运行于
[Jenner](https://jenneranalytics.com) —— 一个兼容 SAS 的 DATA 步和 PROC 引擎。

这里发布的每个笔记本都经过了**内容真实性审查**，而不仅仅是确认能够运行：

- 它在 Jenner 的 Jupyter 内核中干净地运行，并且**已嵌入执行输出（表格和图形）**
  —— 无需下载或重新运行，直接在 GitHub 上阅读结果。
- 叙述中的每个数字和结论都**基于笔记本的真实输出** —— 没有预先写好或捏造的
  结果。
- 每张生成的图片都经过**人工目视审查**。
- 标题所述的 SAS 过程就是实际执行的过程。

未能达到这一标准的笔记本被排除而非发布。这是一个刻意保持精炼、高度可信的
集合；随着更多示例通过审查，它会不断扩充。

## 中文笔记本

本目录包含笔记本的中文版本：markdown 叙述**和**代码关键字均已翻译（`数据`、
`设置`、`运行` 等）。Jenner 可以直接运行这些程序 —— 引擎会自动检测语言。
变量名和数据值保持不变，以与嵌入的输出保持一致。

- `procs/<过程>/<主题>/` —— 按 SAS 过程组织的示例。
- `<行业>/<主题>/` —— 按业务领域组织的示例。

## 运行示例

```bash
jenner jupyter install
jupyter lab
```

选择 **Jenner** 内核并点击「Run All」。由于输出已经嵌入，你也可以直接阅读每个
笔记本。

## 翻译程序

要在语言之间（双向）转换任何程序或笔记本，请使用
[`tools/translate.py`](../../tools/README.md)：

```bash
python3 tools/translate.py --to zh program.jenner   # 英语 → 中文
python3 tools/translate.py --to en program.jenner   # 中文 → 英语
```

# 论文排版规则

默认采用 IEEE PES Transactions 适用的 IEEEtran 双栏期刊格式。本文档维护正文、公式、图表和参考文献的常见排版约定；目标期刊的明确要求优先。

## 默认模板与来源

| 项目 | 配置 |
| --- | --- |
| 主文件 | `latex/main.tex` |
| 文档类型 | `\documentclass[letterpaper,10pt,journal]{IEEEtran}` |
| 文档类 | `latex/IEEEtran.cls`，官方模板包内的 V1.8b，2015-08-26 |
| 文献样式 | `latex/IEEEtran.bst`，维护者发布的 V1.14，2015-08-26 |
| 文献库 | `latex/references.bib` |
| 图片目录 | `latex/figures/` |
| 默认编译 | pdfLaTeX；启用文献库后使用 pdfLaTeX → BibTeX → pdfLaTeX → pdfLaTeX |
| 下载日期 | 2026-10-21 |

IEEE PES 的[期刊排版说明](https://ieee-pes.org/publications/authors-kit/preparation-of-a-formatted-technical-work/)指定使用 IEEEtran 的期刊模板。由 [PES 模板入口](https://ieee-pes.org/publications/authors-kit/templates-and-sample-of-pes-technical-papers/)进入 IEEE Template Selector，选择 IEEE Transactions on Power Systems、Original research and Brief、LaTeX，下载[官方模板包](https://template-selector.ieee.org/api/ieee-template-selector/template/269/download)。本项目的 `main.tex` 依据其中的 `bare_jrnl_new_sample4.tex` 保留期刊文档类和基础结构，正文由作者填写。

`IEEEtran.cls` 从该官方压缩包原样提取；`IEEEtran.bst` 来自 [CTAN 上的 IEEEtran 维护者软件包](https://ctan.org/pkg/ieeetran)，[直接下载地址](https://mirrors.ctan.org/macros/latex/contrib/IEEEtran/bibtex/IEEEtran.bst)。保留这两个文件的版权与许可说明，使用时保持原文件内容。完整下载包保存在本地 `cache/IEEE-Transactions-LaTeX2e-templates-and-instructions.zip`；独立编译所需的类文件和文献样式已放入 `latex/`。

## 公式标点与段落衔接

公式是句子的一部分，末尾标点由句意决定。同一句在公式后继续时，按语法使用逗号或其他适当标点；句子在公式处结束时使用句号。不要给所有公式统一添加逗号。

公式以逗号结尾、后文继续同一句时，后文不作首行缩进。公式与后文之间不留空行，也不插入 `\par`。例如：

```latex
The nodal complex power injection is
\begin{equation}
  S_i = V_i I_i^{*},
  \label{eq:nodal-power}
\end{equation}
where $V_i$ and $I_i$ denote the nodal voltage and injected current, respectively.
```

`where` 小写，紧接公式续写。保持同一段落通常即可得到正确缩进；遇到特殊环境确实产生缩进时，在续接文字前使用 `\noindent`。

公式后的文字确实开始新段落时，才插入空行，并保留模板的正常首行缩进。句号结束一个句子，并不自动要求另起一段。不要全局取消 `\parindent`，也不要在每个公式后统一添加 `\noindent`。

多行推导根据语义在中间行使用逗号、在句子终止处使用句号。标点写在数学环境内的表达式末尾。使用 `equation`、`aligned`、`align` 或 `IEEEeqnarray` 组织公式，按等号或关系符号排列；避免 `$$...$$` 和手动空格排列。

## 编号、符号与单位

- 公式通过 `\label{eq:...}` 和 `\eqref{eq:...}` 自动编号、引用。英文句中使用 `(1)`，句首使用 `Equation (1)`；不手写公式编号。
- 在公式前或紧随公式的文字中定义首次出现的符号，单位和维度与 `01_IDEA/symbols.md` 一致。
- 变量使用数学斜体；单位和说明性下标使用正体，如 `$P_{\mathrm{loss}}$`、`$V_{\mathrm{base}}$`。索引下标保留变量形式，如 `$V_i$`。
- 数值与单位之间保留不可断行空格，如 `10~MW`。标幺值说明所用基准，全文统一使用 `p.u.`。三角函数、指数、对数等使用 `\sin`、`\exp`、`\log` 等命令。

## 图表与文献

- 图题放在图片下方，表题放在表格上方。图、表和公式均通过 `\label`、`\ref` 或 `\eqref` 引用，标签紧随对应的 `\caption` 或放在公式环境内。
- 正文先引用图表，再安排相应浮动体。默认采用单栏图，使用 `\columnwidth` 控制宽度；确需跨栏时使用 `figure*` 或 `table*`，并检查双栏排版结果。
- 图例、坐标轴、单位、方法名称与计算导出图保持一致。图表文件更新后，核对正文描述和定量比较。
- 双栏论文中的单栏图和跨栏图，正常情况下全部图中文字使用 `10 pt`，包括坐标轴刻度、轴标签、图内标注、色条和图例。按照稿件最终显示尺寸检查，所有图中文字最小为 `8 pt`；缩放图片时同步核对实际字号。
- 使用 `\cite{引用键}` 和 `IEEEtran.bst` 生成数字引用与文献列表。引用顺序和编号交给 BibTeX；标点通常位于引用之后。
- 缩略语在摘要和正文首次出现时分别定义，标题中避免未定义的缩略语。关键词采用期刊规定的格式。

## 版面检查

- 保留模板中的 `\markboth` 页眉及默认页码。左侧填写目标期刊名称，右侧填写作者简称和论文短标题；转稿或修改正文时继续保留。卷期和出版日期在确认后填写。
- 保留 IEEEtran 的栏宽、页边距、字号、标题和图题设置。不要通过负间距、缩小正文或修改页边距压缩页数。
- 区分文字中的特殊字符与 LaTeX 命令，正确处理 `%`、`&`、`_`、`#` 等字符。正文换段使用空行，不用 `\\` 代替段落。
- 编译后检查未定义引用、公式越栏、文字溢出、图片清晰度和浮动体位置，并核对公式后续句的缩进。
- 投稿前按目标期刊当前要求核对页数、摘要、作者信息和提交文件；已确认的具体要求记录在论文配置或本文档中。

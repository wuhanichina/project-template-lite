# 02_PAPER

本目录保存面向论文的草稿、图注、审稿回复和作者侧材料。论文文字从证据承载材料提炼，不从对外叙事文案直接复制。

## 写作目录与流程

| 路径 | 内容 |
| --- | --- |
| `manuscript/paper.md` | Markdown 论文草稿 |
| `latex/main.tex` | LaTeX 正式稿入口，默认采用 IEEE PES Transactions 适用的 IEEEtran 模板 |
| `latex/references.bib` | 当前论文引用的 BibTeX 条目 |
| `latex/figures/` | 正式稿实际使用的图片 |
| `latex/` 下的 `.cls`、`.sty`、`.bst` 等文件 | 正式稿需要的期刊模板与排版文件 |
| `formatting_rules.md` | 默认模板来源、公式标点、段落衔接和常见排版规则 |
| `config/`、`revision/`、`submission_consistency.md` | 论文配置、返修材料与投稿检查 |

先在 `manuscript/paper.md` 中组织完整论文。转入 Overleaf 后，以 `latex/main.tex` 及其引用的章节文件作为正式文字的主要修改对象，Markdown 保留转稿时的草稿版本。重要模型、公式、符号和结论变化同步到研究笔记与 `01_IDEA/` 中的对应材料。默认使用一个 Markdown 文件和一个 LaTeX 主文件，按实际篇幅或协作需要拆分章节。

`latex/` 包含独立编译所需的正文、参考文献、图片及模板文件。引用路径相对于该目录，避免依赖本机绝对路径或目录外文件。默认使用官方 `IEEEtran.cls` 的期刊模式及 `IEEEtran.bst` 文献样式，主文件为 `main.tex`，默认编译器为 pdfLaTeX。模板来源及排版约定见 [formatting_rules.md](formatting_rules.md)，写作和转稿时一并读取。目标期刊有明确的其他要求时，采用其模板与编译设置。

Git 跟踪 Markdown、LaTeX、BibTeX、模板文件和稿件用图，忽略 LaTeX 编译中间文件。与 Overleaf 同步的文件范围为 `latex/` 内的稿件材料；建立同步时明确本地该目录与 Overleaf 项目根目录的对应关系。同步前获取对方最新修改并处理冲突，确认后再提交和推送。

正式用图从 `result/<case>/figures/` 导出后复制到 `latex/figures/`，保留可核查的文件名，并在 `01_IDEA/evidence_map.md` 的对应图表记录中注明来源路径与稿件图片路径。更新图表时同时更新稿件副本。计算数据、FIG、manifest 和检查报告继续保存在结果目录。

`03_REFERENCE/` 保存文献原文、阅读记录和收集的引用信息；`latex/references.bib` 维护当前论文使用的条目。Markdown 草稿中的引用键与该文件一致，转稿时沿用。

## 材料分层

| 层级 | 文件或目录 | 用途 |
| --- | --- | --- |
| 研究论述 | `ProjectName_note.md` | 当前工程缺口的需求、紧迫性、现有方法的后果、方法机理和结果 |
| 研究版本 | `ProjectName_changelog.md` | 研究内容的实质修改及版本依据 |
| 结论与推导 | `01_IDEA/claims.md`、`derivation.md`、`symbols.md` | 结论编号、公式、假设、单位和代码映射 |
| 证据与边界 | `01_IDEA/evidence_map.md`、`research_trace.yaml`、`result/` | 登记结果、run manifest、失败路线和适用边界 |
| 文献材料 | `03_REFERENCE/Powerlit相关论文本地地址.md` | 至少 40 篇已核查的高水平非中文相关文献、完整书目信息、本地地址及本文用途 |
| 专业术语 | `03_REFERENCE/专业术语表.md` | 中英文表达、定义、适用条件和来源 |
| 对外叙事参考 | `ProjectName_blog.md` | 只参考与创新轴、技术对象和 `narrativeArc` 匹配的叙事顺序，不作为证据或论文现成措辞 |
| 论文档案 | `02_PAPER/config/paper-profile.yaml` | 保存已确认的创新四轴、叙事路由、生命周期与证据边界 |
| 投稿终检 | `02_PAPER/submission_consistency.md` | 保存最近一次检查版本、问题位置、修复状态与放行结论 |
| 返修工件 | `02_PAPER/revision/` | 保存审稿意见、真实缺口、修改动作、证据需求与回复状态 |

Introduction 和 Contributions 必须从研究档案、结论、推导、登记结果和已核查文献重新组织。`ProjectName_blog.md` 中的项目判断即使表达完整，也要再次核对适用范围、证据来源和证据状态；不能轻量改写后直接进入稿件。作者经验、工程直觉和未登记观察只能作为 `仅为当前假设`、`尚未验证` 或 `文献待核查` 的研究问题。

AI 生成的正文、图注、审稿回复和作者侧说明遵守根目录 `AGENTS.md` 的表达规范及本目录 `AGENTS.md` 的写作与返修约定。

正式论文图来自 `result/<case>/figures/`，并由 `ProjectName_utils.plotting.save_figure` 导出 FIG、PNG、SVG、可选格式、绘图数据、manifest 和检查报告。图表成为论文证据前，应在 `01_IDEA/evidence_map.md` 登记。

## 作者配置

仓库只跟踪示例文件：

```text
02_PAPER/config/author-profile.example.yaml
```

本地使用时复制为 `02_PAPER/config/author-profile.yaml`。真实文件可能含个人信息，应继续由 `.gitignore` 排除。

## 论文档案

复制 `02_PAPER/config/paper-profile.example.yaml` 为
`02_PAPER/config/paper-profile.yaml` 并纳入项目版本控制。该文件不保存
作者隐私，而是 Skill 与模板共享的确认状态。`contractVersion` 必须与
`.cursor/contracts/project-template-handoff.schema.yaml` 一致。PowerLit 负责解释
创新与写作政策；模板只保存确认值、运行事实和审计工件。

# project-template-lite

> 📌 面向电力系统方向的科研论文，帮助研究者把代码、数据、结果、图表和论文材料整理成一套可复现、可追溯、可交接的研究档案。

`project-template-lite` 是轻量级 MATLAB 科研论文项目模板。它面向电力系统、优化、仿真和数据实验类论文项目，目标是让作者、学生、合作者和 AI 助手第一次打开仓库时，就能判断代码从哪里运行、研究思路写在哪里、结果证据存在哪里、论文材料如何更新。

模板的核心判断是：`data/` 保存复现实验所需的输入；`cache/` 只保存可以重新生成的中间结果；论文里的重要结论应能追溯到运行脚本、结果文件和证据状态。

[📝 版本更新记录](#版本更新记录) · [📌 使用场景](#使用场景) · [🚀 三分钟上手](#三分钟上手) · [🧩 模板管理哪些材料](#模板管理哪些材料) · [🛠️ 常见任务怎么做](#常见任务怎么做) · [🔁 推荐使用流程](#推荐使用流程) · [📂 目录结构](#目录结构) · [✅ 提交前检查清单](#提交前检查清单) · [🔒 使用边界](#使用边界)

---

## 版本更新记录

- 2026-06-30：将版本更新记录改为倒序，并补充参数图绘制前的 SOTA 参数调研规则。
- 2026-06-28：细化正式论文图规则，默认使用 IEEE 双栏论文的一栏宽度和 10 pt 字号，复杂小图可显式使用 8 pt，并明确算例分析中物理复现优先的强制图组顺序、SOTA 对比图例、本文方法消融图例、中英文图例转换口径、折线图/柱状图图内图例建议，以及生成绘图代码前的文献图表调研步骤。
- 2026-06-27：看完了《MATLAB×AI：科研绘图与学术图表智能绘制一本通》这本书，强化了模板的绘图功能，统一正式论文图的尺寸、字体、分辨率和导出配置。
- 2026-06-14：重写 README 为中文上手入口，按使用场景、三分钟上手、常见任务、推荐流程和提交前检查组织模板说明。
- 2026-06-08：增加项目约定入口和正式算例流程脚手架，覆盖输入读取、方法运行、指标汇总、结果写出、图表导出和步骤跟踪。
- 2026-06-05：补充从 `data/` 冷启动复现、`cache/` 使用边界、跨平台兼容、包目录职责和写作表达边界。
- 2026-06-04：区分给人看的研究材料和项目约定，并增加符号表来统一论文符号、单位、维度和代码变量名。
- 2026-06-02：完善研究笔记、想法文件、证据索引和图表证据包说明，让合作者能从问题、结论、结果和图表路径继续推进。
- 2026-06-01：创建轻量 MATLAB 论文项目模板，并补齐数据、缓存、测试、论文材料、参考文献和结果目录的占位说明。

---

## 使用场景

本模板适合刚开始成形、需要持续推进的 MATLAB 论文项目：

- 研究主要用 MATLAB 完成，包含建模、仿真、优化、数据分析或算例验证。
- 项目会反复修改，需要把代码、数据、结果、图表和论文材料放在同一套目录中维护。
- 研究结论需要有明确来源，读者能看到它由哪个脚本、哪份结果和哪条记录支撑。
- 项目需要交给师弟师妹、合作者或 AI 助手继续推进。

---

## 三分钟上手

1. 从 GitHub 使用这个模板创建新仓库，或复制本目录作为项目起点。
2. 把 `ProjectName` 替换为项目简称：
   - `ProjectName.m`
   - `ProjectName_case33bw.m`
   - `ProjectName_case123.m`
   - `ProjectName_note.md`
   - `+ProjectName_core/`
   - `+ProjectName_utils/`
   - `+ProjectName_sota/`
3. 先填 `01_IDEA/story.md`，写清楚论文回答的科学或工程问题。
4. 再填 `01_IDEA/claims.md`，把想验证的结论绑定到算例、证据编号和验证标准。
5. 在 `01_IDEA/symbols.md` 登记符号、单位、维度和代码变量映射。
6. 把完整复现输入放入 `data/`，包括原始数据、算例文件、参数表和必要外部输入。
7. 把正式计算写进根目录的 `ProjectName_case*.m`，把可复用函数放入对应 MATLAB 包目录。
8. 在 MATLAB 中进入项目根目录，运行一个正式算例：

```matlab
ProjectName_case33bw
```

9. 有正式结果后，同步更新：
   - `ProjectName_note.md`
   - `01_IDEA/evidence_map.md`
   - 对应的 `result/<算例名>/` 路径
10. 提交前临时移走或清空 `cache/`，确认 `ProjectName` 或正式 `ProjectName_case*.m` 能只依赖代码和 `data/` 重新开始。

如果需要作者信息配置，复制 `02_PAPER/config/author-profile.example.yaml` 为本地的 `author-profile.yaml` 后填写个人信息。真实 `author-profile.yaml` 保留在本地，不进入 Git。

---

## 模板管理哪些材料

| 对象 | 放置位置 | 交付要求 |
| --- | --- | --- |
| 研究故事线 | `01_IDEA/story.md` | 说明工程需求、现有不足、痛点问题和科学问题 |
| 待验证结论 | `01_IDEA/claims.md` | 记录结论编号、证据编号、验证标准和当前状态 |
| 数学推导 | `01_IDEA/derivation.md` | 记录变量、假设、公式、近似和适用范围 |
| 符号和单位 | `01_IDEA/symbols.md` | 统一论文符号、单位、维度和代码变量名 |
| 研究档案 | `ProjectName_note.md` | 汇总问题、路线、模型、结果、边界和写作检查 |
| 正式算例 | `ProjectName_case*.m` | 编排配置、输入检查、本文方法、对比方法、指标、结果和出图 |
| 核心代码 | `+ProjectName_core/` | 放贡献定义相关的模型、算法、求解和指标函数 |
| 支撑代码 | `+ProjectName_utils/` | 放 IO、MC、绘图、缓存、日志和流程跟踪工具 |
| 对比算法 | `+ProjectName_sota/` | 放基线方法和对比算法实现 |
| 复现输入 | `data/` | 保存正式计算从零开始运行所需的输入 |
| 中间缓存 | `cache/` | 保存可由 `data/` 和代码再生成的派生结果 |
| 结果证据 | `result/<算例名>/` | 保存正式结果、表格、日志和图表证据包 |
| 论文材料 | `02_PAPER/`、`03_REFERENCE/` | 保存稿件材料、作者配置示例、参考文献和阅读记录 |
| AI 助手规则 | `.cursor/rules/` | 约束代码组织、出图出口、证据同步和写作边界 |

---

## 常见任务怎么做

| 任务 | 先看哪里 | 应修改哪里 | 完成信号 |
| --- | --- | --- | --- |
| 开一个新项目 | `README.md`、`01_IDEA/README.md` | `ProjectName*` 文件和三个 `+ProjectName_*` 包目录 | 项目简称替换完成，根入口可运行 |
| 增加研究问题 | `01_IDEA/story.md` | `story.md`、`claims.md`、`ProjectName_note.md` | 新问题有结论记录、证据状态和后续验证路径 |
| 增加正式算例 | 现有 `ProjectName_case*.m` | 新算例入口、`result/<算例名>/`、`evidence_map.md` | 算例可从 `data/` 从零开始运行并写出结果 |
| 增加核心方法 | `01_IDEA/derivation.md` | `+ProjectName_core/+<对象或阶段>/` | 函数名表达物理对象、数学操作或求解阶段 |
| 增加对比算法 | `+ProjectName_sota/README.md` | `+ProjectName_sota/+<算法族>/` | 与本文方法共用数据、指标和约束口径 |
| 生成正式图 | `result/<算例名>/figures/README.md` | `+ProjectName_utils/+plotting/`、算例出图调用 | `.fig/.png/.svg`、CSV、追溯记录和检查报告齐全 |
| 写论文段落 | `ProjectName_note.md` | `02_PAPER/` 或外部稿件 | 重要结论能追到结论记录、公式、结果和证据状态 |
| 投稿前复核 | `01_IDEA/evidence_map.md` | `ProjectName_note.md`、结果目录、稿件材料 | 证据、模型、指标和结论边界一致 |
| 交接项目 | `ProjectName_note.md` | README、研究笔记、想法文件、结果索引 | 合作者能从根入口复现或定位待补项 |

---

## 推荐使用流程

### 从已有项目迁移到本模板

把已有 MATLAB 论文项目整理到本模板时，可以直接使用这句提示词：

```text
请严格按照 project-template-lite 模板改造当前项目。
```

迁移时优先补齐入口脚本、`01_IDEA/`、`02_PAPER/`、`03_REFERENCE/`、`data/`、`cache/`、`result/` 和 MATLAB 包目录，再按提交前检查清单确认项目能交接。

### 从研究想法到待验证结论

1. 在 `01_IDEA/story.md` 写清楚工程需求、现有不足、痛点问题和科学问题。
2. 在 `01_IDEA/claims.md` 把研究想法拆成可以验证、可以推翻的结论。
3. 在 `01_IDEA/research_trace.yaml` 记录关键决策、失败路径、路线转向和未解决问题。
4. 在 `ProjectName_note.md` 同步公开研究档案。

### 从待验证结论到正式算例

1. 在 `01_IDEA/evidence_map.md` 为待验证结论预留证据编号。
2. 在 `ProjectName_case*.m` 编排正式算例流程。
3. 在 `data/` 放入从零开始运行所需的输入。
4. 在 MATLAB 包目录中实现核心方法、支撑流程和对比算法。
5. 运行算例后写入 `result/<算例名>/`。

### 从正式算例到图表证据

1. 算例入口生成正式结果表、日志和图表输入数据。
2. 正式图通过 `ProjectName_utils.plotting.save_figure(...)` 导出。
3. 每张正式图写入源图、预览图、矢量图、绘图数据、追溯记录和检查报告。
4. `01_IDEA/evidence_map.md` 登记图表和结果对应的待验证结论。

### 从图表证据到论文文字

1. `ProjectName_note.md` 先记录结果含义、证据状态和结论边界。
2. 论文草稿只使用已登记的待验证结论、公式、结果和图表证据。
3. 图题、结果段和结论使用具体指标、算例范围和证据状态。
4. 审稿意见改变结论边界时，先更新 `claims.md` 和 `ProjectName_note.md`。

---

## 目录结构

```text
.
├── ProjectName_note.md       # 项目研究笔记：研究意义、模型、证据、论文边界
├── ProjectName.m             # 项目级入口：串联登记算例并生成跨算例汇总
├── ProjectName_case33bw.m    # case33bw 正式流程入口
├── ProjectName_case123.m     # case123 正式流程入口
├── +ProjectName_core/        # 核心模型、算法、求解和指标函数
├── +ProjectName_utils/       # IO、MC、绘图、缓存、日志和流程工具
├── +ProjectName_sota/        # 对比方法和基线实现
├── data/                     # 完整复现输入：原始数据、算例、参数表和必要外部输入
├── cache/                    # 可删除中间缓存，不作为从零开始运行的必需输入
├── result/                   # 结果、表格、图表和日志
│   ├── case33bw/
│   │   └── figures/          # case33bw 正式图及其配套文件
│   └── case123/
│       └── figures/          # case123 正式图及其配套文件
├── tests/                    # 调参、局部验证和临时检查
├── 01_IDEA/                  # 故事线、待验证结论、推导、符号、证据索引、研究轨迹
├── 02_PAPER/                 # 论文写作材料和作者配置示例
├── 03_REFERENCE/             # 参考文献、BibTeX、阅读材料
└── .cursor/                  # 协作规则和 AI 助手约束
```

GitHub 不保存空目录，所以模板用少量 README 文件保留关键目录。目录 README 只说明放置规则；结果证据以 `result/`、`01_IDEA/evidence_map.md` 和正式图证据包为准。

---

## 关键目录职责

`ProjectName_note.md` 是给作者和合作者看的主研究笔记。它记录项目当前认识的公开版本，包括研究问题、模型边界、关键决策、结果状态和写作检查。

`01_IDEA/` 是论文想法的结构化草稿：

- `story.md`：论文故事线和科学问题。
- `claims.md`：待验证结论、证据编号、验证标准和当前状态。
- `derivation.md`：变量、假设、公式和近似边界。
- `symbols.md`：统一符号、单位、维度和代码变量映射。
- `evidence_map.md`：待验证结论到入口脚本、结果文件和证据状态的索引。
- `research_trace.yaml`：关键决策、失败路径、路线转向和未解决问题。

`ProjectName_case33bw.m` 和 `ProjectName_case123.m` 是算例级正式入口。每个入口负责编排本算例的完整流程：配置、输入检查、终端步骤跟踪、数据加载、本文方法、对比算法、指标汇总、结果写入和正式图导出。入口文件只组织流程，具体计算、IO、指标、绘图和对比算法放入对应 MATLAB 包目录。

`ProjectName.m` 是项目级汇总入口。它串联模板登记的算例入口，并预留跨算例汇总表和全局图表出口，例如规模扩展对比、总体性能对比和跨算例结果摘要。

`+ProjectName_core/` 放定义本文贡献的核心代码，例如物理模型、数学模型、核心算法、求解器封装和论文主指标。

`+ProjectName_utils/` 放支撑代码，例如目录创建、summary 输出、随机种子、缓存读写、流程跟踪、局部长耗时进度条和绘图导出。绘图工具放在 `+ProjectName_utils/+plotting/`。

`+ProjectName_sota/` 放对比算法和基线实现。对比方法应和本文方法共用同一数据、指标和约束口径。

正式可复用代码按“核心代码、支撑代码、对比算法”三类进入对应 MATLAB 包目录，并继续放入有语义的子包。包目录根部只保留 README、短调度入口或注册表。

- 核心代码进入 `+ProjectName_core/+<物理对象或流程阶段>/`，例如网络模型、潮流模型、优化建模、风险指标、收敛诊断。
- 支撑代码进入 `+ProjectName_utils/+<支撑流程>/`，例如 `+io/`、`+mc/`、`+plotting/`、`+cache/`、`+logging/`。
- 对比算法进入 `+ProjectName_sota/+<算法族或基线名称>/`，每个基线保留自己的实现、参数说明和适配入口。

子包名和 `.m` 文件名应表达实际物理对象、数学操作或流程步骤，例如 `build_power_flow_model.m`、`solve_dispatch_subproblem.m`、`evaluate_voltage_risk.m`、`export_case_summary.m`。正式代码中应避免 `helper.m`、`utils.m`、`misc.m`、`temp.m`、`test1.m`、`new_method.m` 这类职责不清的名称。

`data/` 放完整复现项目代码所需的输入文件，包括原始数据、算例文件、参数表、外部基线输入和必要说明。提交或交接前，正式入口应能在不读取既有 `cache/` 文件的情况下，从 `data/` 重新开始计算。

`cache/` 只放由代码从 `data/`、配置和随机种子派生出来的中间结果。缓存可以加速复跑，但不能作为正式计算的启动条件。代码需要某个缓存文件才能启动时，应把该文件上溯为 `data/` 输入，或让代码从 `data/` 自动生成。

`result/<算例名>/` 放这个算例的正式结果、表格和日志。正式图统一放在 `result/<算例名>/figures/`。

---

## 文档分层

本模板区分给人看的研究材料和给 AI 助手执行的规则：

| 类型 | 文件 | 作用 |
| --- | --- | --- |
| 人类研究材料 | `ProjectName_note.md`、`01_IDEA/` | 记录问题、待验证结论、推导、证据和路线演化，便于作者、学生和合作者阅读 |
| 论文材料 | `02_PAPER/`、`03_REFERENCE/` | 沉淀论文草稿、作者配置示例、参考文献和阅读材料 |
| AI 执行规则 | `.cursor/rules/` | 约束 AI 助手的代码组织、出图出口、证据同步和写作边界 |
| AI 写作规则 | `.cursor/rules/03-public-note-and-paper-skill-bridge.mdc`、`.cursor/rules/lexicon.md` | 检查中英文 AI 生成文本中的套话、空泛词和范围过强表述 |
| 代码质量门 | `+ProjectName_utils/+plotting/save_figure.m` | 在正式出图时检查图表元信息、导出包和检查报告 |

`01_IDEA/` 不承担 AI 助手规则说明的职责。它像研究白板一样呈现故事线、待验证结论、推导、证据和路线记录。

---

## 图表证据包

正式论文图以 MATLAB 脚本作为统一出口，形成源图、预览图、矢量图、绘图数据、追溯记录和检查报告组成的证据包。截图、复制粘贴、Python/Matplotlib、Excel 或 Origin 可以用于临时讨论；正式论文图从 MATLAB 证据包中取得。投稿阶段如果需要 `.pdf`、`.eps` 或 `.tiff`，由同一 MATLAB 图窗和同一导出脚本额外生成。

出图规则的优先级固定为：

```text
数据真实性 > 可追溯性 > 黑白可辨识 > 字号可读性 > 排版尺寸 > 美观
```

数据真实性优先于视觉效果。筛选、变换、对数轴零值替代和异常点剔除应同时写入绘图数据、追溯记录和检查报告。遇到质量规则冲突时，先记录冲突原因，再决定是否生成诊断图或调整图型。

每个算例都有自己的图表目录：

```text
result/<算例名>/figures/
```

正式图统一通过：

```matlab
ProjectName_utils.plotting.save_figure(...)
```

默认图表 profile 为 `ProjectName_utils.plotting.figure_profile("ieee")`。默认字号为 10 pt，图宽按 IEEE 双栏论文中的一栏设置，不超过 `8.89 cm`。复杂小图可以显式使用 8 pt，例如 `save_figure(..., "FontSizePt", 8)`，并在 manifest 中记录实际字号。新图建议先用 `ProjectName_utils.plotting.create_figure("single-column")` 创建图窗，再调用 `save_figure` 导出证据包；默认 profile 会把更宽的 layout 请求截到一栏宽度。目标期刊给出更具体的字体、尺寸、分辨率、格式或坐标轴要求时，以目标期刊为准。

每张正式图至少生成：

- `.fig`：MATLAB 源图。
- `.png`：预览图，正式图不低于 300 dpi，诊断图不低于 200 dpi。
- `.svg`：矢量图。
- `*_plot_data.csv`：折线图、柱状图、散点图等同步导出绘图数据；概率密度图还要导出 histogram bin 和叠加 PDF 曲线采样点。
- `figure_manifest.jsonl`：每张图一行的追溯信息。
- `figure_check_report.md`：自动检查和人工复核项。

正式图导出前必须明确：

- 图要回答的科学或工程问题。
- 本文方法要复现的物理实际、参考物理行为或可信 benchmark。
- 这张图的证据角色，例如物理复现、SOTA 对比、消融、运行时间或泛化。
- 数据文件、字段含义、单位、维度和预处理状态。
- 全局视觉编码。
- 目标排版尺寸，默认使用 `single-column`，即 IEEE 双栏论文中的一栏宽度。
- 运行命令、关键参数和随机种子，或明确写 `not_applicable`。

`ProjectName_utils.plotting.save_figure` 会检查图表元信息。缺少 `claimId`、`sciQuestion`、`physicsReproduction`、`evidenceRole`、`dataFiles`、`dataDescription`、`visualEncoding`、`targetLayout`、`command`、`keyParams` 或 `randomSeed` 时，不允许导出正式图。`evidenceRole` 必须取 `scenario-setup`、`physical-reproduction`、`sota-comparison` 或 `sensitivity-ablation`；同一 claim 的 `sota-comparison` 或 `sensitivity-ablation` 图不得早于其 `physical-reproduction` 图导出。导出前先在 `01_IDEA/figure_plan.md` 完成图与指标计划，见 `.cursor/rules/04-case-figure-and-metric-plan.mdc`。

生成正式绘图代码前，先看相近论文如何展示同类结果。优先查 `03_REFERENCE/` 中已收集文献和 PowerLit 检索结果；本地材料不足时，再联网检索最近或最接近的论文。调研时记录这些信息：论文来源、图型、指标组织、baseline 分组、消融是否单独成图、坐标轴与图例写法、是否使用多 case 或运行时间对比。模板只学习展示方式和组织逻辑，不照搬其他论文的数据、结论、caption 或完整视觉样式。

绘制参数图、灵敏度图或参数扫描图前，先查 SOTA 论文一般比较哪些参数、参数范围、步长、归一化方式、默认值和横轴组织方式。参数图不能只画作者当前最方便扫的参数；若本文选择的参数和 SOTA 常用参数不同，需要在研究笔记、manifest 或 caption 草稿中写明理由。

同一方法或类别的颜色、线型、marker、灰度和 hatch 在 `ProjectName_utils.plotting.methodStyle` 中统一登记。主图和 SOTA 对比图中，本文方法默认图例写成 `本文方法`，外部方法默认只写论文来源名，例如 `Pappu2017`。消融图中，完整方法写成 `本文原始方法`，消融版本写成 `去掉网络物理约束`、`去掉源荷不确定性建模` 这类短标签。折线图优先使用 `ProjectName_utils.plotting.plot_method_line`，通过稀疏 marker 避免节点或时间点过密。折线图和柱状图优先把图例放在图内，可调用 `ProjectName_utils.plotting.place_legend(ax)` 使用自动 `best` 位置；若遮挡关键曲线、柱子、峰值或不确定性带，再手动调整。方法区分同时使用颜色、线型和 marker，方便彩色与黑白出版。

### 图组叙事和方法标注

模板的正式出图默认服务于论文的算例分析或实验结果部分，不默认生成原理说明图、机制设计图、算法流程图或理论框架图。算例介绍需要的测试系统、源荷时序、概率分布、场景集和样本特征图，可以先于结果图出现。

构思正式结果图时，强制先登记“物理复现图组”。这组图属于算例分析结果图，不是原理说明图、机制设计图或算法流程图；它用 `本文方法` 的模型输出复现真实测量、高保真仿真、解析参考、可信 benchmark 或已知物理约束下的实际物理行为，例如状态量、约束边界、源荷时序响应、概率分布、空间趋势或可行运行状态。没有这组图，不生成 SOTA 对比、运行时间、泛化、消融或多指标排名图。

进入结果分析后，第一组结果图必须先展示 `本文方法` 对算例物理实际的复现能力。核心指标只有在直接度量物理复现时才放入第一组；其他性能指标和排名型指标放到后续图组。

对比图按比较关系分组。外部 SOTA 或 baseline 对比可以覆盖主指标、其他性能指标、不同 case 泛化、运行时间和其他性能视角；图例和 caption 使用论文来源命名，例如 `Pappu2017` 或 `AuthorYear`，并在 manifest、caption 或 `01_IDEA/evidence_map.md` 中登记来源。

消融图只比较本文方法内部版本。完整方法写成 `本文原始方法`，消融版本写成 `去掉<物理模块或机制>`，并说明在本文方法上去掉了什么。转成英文稿时，再把主图和 SOTA 对比中的 `本文方法` 统一替换为 `Proposed method`。正常情况下，SOTA 对比图组和消融图组分开组织，避免在同一张图中混入外部论文方法和本文方法删减版本。

组合展示先分别输出独立子图，例如 `Fig05a`、`Fig05b`、`Fig05c`，再进入论文排版。

常见图型遵循以下边界：

- 结果值对比图：同时显示基准解和待比较方法。
- 误差图：聚焦待比较方法的误差。
- 跨数量级误差：使用对数纵轴，并在追溯记录中记录零值或负值处理阈值。
- 分布距离指标：按节点或逐点绘制，不只给平均值柱状图；带物理量纲的指标必须标单位。
- 概率密度对比图：以基准 histogram 为底，叠加各方法 PDF 曲线；每个代表点单独出图。
- 参数图：先查 SOTA 论文常比较的参数、范围、默认值和横轴组织；本文参数选择不同于 SOTA 常用设置时写明原因。

每张图生成后检查 `.fig/.png/.svg` 是否齐全、PNG 是否非空白、SVG 是否可读、CSV 是否与图中曲线一致、图例是否遮挡关键曲线、横轴标签是否过密、黑白显示是否可辨、结构化标签是否采用领域可读写法，以及异常点和对数轴处理是否已声明。

---

## 研究笔记规范

`ProjectName_note.md` 是项目研究档案，用来把研究从想法整理成可复核、可接力、可提炼为论文的材料。它应记录问题如何形成、路线如何演变、数学模型如何落地、代码如何对应、结果如何支持或修正当前判断。核心符号、单位、维度和代码变量映射以 `01_IDEA/symbols.md` 为准，并在 `derivation.md` 和本笔记中保持一致。

推荐写法是中性、客观、可验证、可追溯。优先使用“当前证据支持”“该判断仍需验证”“该路线已归档”“该结论目前仅在某算例中观察到”等表达，让读者看到证据强度。

AI 生成的研究笔记、论文草稿、审稿回复、图注、README 和代码注释应通过 `.cursor/rules/03-public-note-and-paper-skill-bridge.mdc` 中的写作风格检查，并用 `.cursor/rules/lexicon.md` 做最终词表筛查。文本应直接陈述技术对象、机制、范围、指标和证据状态。

判断性结论应标注证据状态。推荐状态包括：

- `已由理论推导支持`
- `已由数值实验支持`
- `已由代码实现支持`
- `已有 Git 版本记录`
- `仅为当前假设`
- `尚未验证`
- `结果不稳定`
- `当前证据不足`
- `已被实验排除`
- `暂时放弃`
- `文献待核查`
- `代码尚未实现`
- `结果待复核`

缺少信息时，直接使用 `【待补充】`、`【尚未验证】`、`【文献待核查】`、`【当前证据不足】`、`【Git 待提交】`、`【文档滞后】`、`【尚未实现】`、`【代码待核查】` 等标记，把后续需要补的工作显式留下。

研究笔记至少保留三条主线：

```text
问题形成主线：工程需求 -> 现有不足 -> 痛点问题 -> 科学问题
研究演化主线：初始思路 -> 暴露问题 -> 方案调整 -> 当前路线
可追溯主线：数学模型 -> 代码实现 -> Git 版本 -> 阶段性验证 -> 证据状态
```

被放弃的建模、求解、实验和对比路线也应保留，并写清楚原始设想、尝试方式、暴露问题、放弃原因和后续启示。若无法读取 Git 历史，保留 Git 字段并标注 `【Git 信息待补充】`，方便后续补齐版本关联。

---

## MATLAB 运行方式

在 MATLAB 中进入项目根目录后运行统一入口：

```matlab
ProjectName
```

也可以单独运行指定算例：

```matlab
ProjectName_case33bw
ProjectName_case123
```

每个算例入口负责创建自己的结果目录、缓存目录和图表目录，并调用包内函数完成该算例的正式流程。`ProjectName.m` 负责串联模板登记算例并生成跨算例汇总。核心算法放入 `+ProjectName_core/`，对比算法放入 `+ProjectName_sota/`，流程、IO、绘图和局部长耗时进度条放入 `+ProjectName_utils/`。

---

## 提交前检查清单

项目提交、交接或论文复核前，按这张清单检查：

| 检查项 | 通过标准 |
| --- | --- |
| 项目命名 | `ProjectName` 前缀已替换为真实项目简称，README 或研究笔记中无误导性占位语境 |
| 根入口 | `ProjectName` 或正式 `ProjectName_case*.m` 能在 MATLAB 项目根目录运行 |
| 复现输入 | 正式计算能在移走或清空 `cache/` 后，只依赖代码和 `data/` 启动 |
| 证据索引 | 正式结果已登记到 `01_IDEA/evidence_map.md` |
| 研究笔记 | `ProjectName_note.md` 同步了问题、模型、结果、证据状态和未解决项 |
| 符号一致 | `01_IDEA/symbols.md`、`derivation.md`、代码变量和论文材料口径一致 |
| 图表包 | 正式图包含 `.fig/.png/.svg`、绘图数据、追溯记录和检查报告 |
| 对比口径 | 对比方法和本文方法共用数据、指标和约束口径 |
| 作者配置 | 真实 `author-profile.yaml` 保留本地，`author-profile.example.yaml` 可提交 |
| AI 助手规则 | `.cursor/rules/` 随模板变化同步提交 |

`result/` 可以保存正式证据、表格、图和日志，但默认也不作为计算启动输入。只有在明确写成“复核既有结果”的脚本中，才可以把 `result/` 作为读取对象。

---

## 求解器选择

新建优化模型时，先从本机 MATLAB 可调用的求解工具开始：

1. `CVX + MOSEK`：SDP、SOCP、凸优化原型和 disciplined convex models。
2. `Gurobi`：LP、QP、MILP、MIQP，以及可写成 LP/QP/QCP 的 SCA 子问题。
3. `MOSEK` 直接接口：不经过 CVX 时更清晰或更快的锥规划。

新增优化模型时，优先通过 MATLAB 可见性检查确认 `cvx_begin`、`mosekopt`、`gurobi` 等接口可用。

选择软件依赖时默认考虑 Windows MATLAB 和 Apple Silicon macOS 双平台：

- 优先使用 MATLAB 原生路径、跨平台 toolbox、CVX/MOSEK/Gurobi 等在目标平台可安装的接口。
- 不把 Windows 盘符路径、`.exe`、x86-only 二进制或仅 Windows 可用的求解器写成必要启动路径。
- 若遗留复现确实需要平台限定工具，应隔离成可选适配层，并在入口、证据图或 README 中写明主流程从零开始运行时依赖哪些工具。

---

## Git 管理建议

建议跟踪：

- 模板入口和 MATLAB 包目录。
- `.cursor/rules/`。
- `01_IDEA/`、`02_PAPER/config/author-profile.example.yaml`、`03_REFERENCE/` 中的轻量文本材料。
- `data/` 中随项目提交的完整复现输入，以及 `cache/`、`tests/`、`result/` 里的 README 占位说明。

默认保留在本地或由运行时生成：

- `cache/` 中的生成文件。
- 真实运行输出。
- 大型 `.mat` 文件。
- `.fig`、日志、临时测试结果。
- 未经筛选、尚未决定是否进入提交包的大型原始数据。
- 含真实个人信息的 `02_PAPER/config/author-profile.yaml`。

公共 Git 可以因为体积或隐私暂不跟踪完整 `data/` 文件，但正式项目提交包必须包含完整 `data/` 输入。若某个必要输入尚不能随项目提供，应在 `data/README.md` 和 `01_IDEA/evidence_map.md` 中标记为未闭合复现边界。`cache/` 只保存派生中间结果。

某个结果要作为论文证据长期保存时，先确认它已经登记到 `01_IDEA/evidence_map.md`，再由项目作者决定是否纳入版本管理。

---

## 使用边界

本模板刻意保持根目录轻量。常规工作优先进入已有目录、已有 MATLAB 包目录和每个算例的 `figures/`。项目规模确实需要新的组织方式时，由项目作者明确决定，再补充相应说明。

正式研究材料和 AI 助手执行规则分开放置。`README.md`、`ProjectName_note.md` 和 `01_IDEA/*` 面向人类读者，呈现研究内容、证据状态和交接路径；`.cursor/rules/` 面向 AI 助手，保存执行约束、代码组织规则和写作检查规则。

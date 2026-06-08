# project-template-lite

轻量级 MATLAB 科研论文项目模板。它适合用来维护一个从想法、模型、算例、结果图表到论文证据都能互相追溯的研究项目。

这个模板的核心判断很简单：项目根目录就是 MATLAB 代码根目录；目录保持轻量；每个论文主张都能追到入口脚本、结果文件和证据状态。

项目提交还要满足两个边界：`data/` 是完整复现输入边界，正式计算必须能在清空 `cache/` 后只依赖代码和 `data/` 重新开始；代码和软件依赖默认要考虑 Apple Silicon macOS 兼容性，避免把 Windows-only 或 x86-only 工具变成必要路径。

## 适合谁用

适合这些场景：

- MATLAB 为主的电力系统、优化、仿真或数据实验论文项目。
- 需要长期迭代，不想让代码、结果、论文笔记分散到多个目录。
- 希望后续作者、学生或 agent 第一次打开项目时，就知道从哪里跑、哪里写、哪里查证据。

不适合这些场景：

- 已经有大型工程化软件架构，需要完整 `src/`、`scripts/`、`docs/`、CI/CD 分层。
- 只想临时跑一个一次性实验，不准备维护论文证据链。

## 三分钟上手

1. 从 GitHub 使用这个模板创建新仓库，或复制这个目录。
2. 把 `ProjectName` 替换成你的项目简称：
   - `ProjectName.m`
   - `ProjectName_case33bw.m`
   - `ProjectName_case123.m`
   - `ProjectName_note.md`
   - `+ProjectName_core/`
   - `+ProjectName_utils/`
   - `+ProjectName_sota/`
3. 先填 `01_IDEA/story.md`，写清楚论文到底要回答什么问题。
4. 再填 `01_IDEA/claims.md`，把每个主张绑定到将来要运行的 case 和证据编号。
5. 在 `01_IDEA/symbols.md` 登记核心符号、维度、单位和代码变量映射。
6. 把完整复现所需的原始数据、算例文件、参数表和必要外部输入放入 `data/`，把正式计算写进根目录的 `ProjectName_case*.m`。
7. 提交前临时移走或清空 `cache/`，确认 `ProjectName` 或每个正式 `ProjectName_case*.m` 能只依赖 `data/` 开始完整计算。
8. 如果需要作者信息配置，复制 `02_PAPER/config/author-profile.example.yaml` 为本地的 `author-profile.yaml`，再填写个人信息。真实 `author-profile.yaml` 不进入 Git。
9. 在 MATLAB 里进入项目根目录，运行：

```matlab
ProjectName_case33bw
```

10. 有正式结果后，同步更新：
   - `ProjectName_note.md`
   - `01_IDEA/evidence_map.md`
   - 对应的 `result/<case>/` 路径

## 目录地图

```text
.
├── ProjectName_note.md       # 项目研究笔记：研究意义、模型、证据、论文边界
├── ProjectName.m             # 项目级入口：串联模板登记 case 并生成跨 case 汇总
├── ProjectName_case33bw.m    # case33bw 正式流程入口
├── ProjectName_case123.m     # case123 正式流程入口
├── +ProjectName_core/        # 核心模型、算法、求解和指标函数
├── +ProjectName_utils/       # IO、MC、绘图、缓存等非核心工具
├── +ProjectName_sota/        # 对比方法和基线实现
├── data/                     # 完整复现输入：原始数据、算例、参数表和必要外部输入
├── cache/                    # 可删除中间缓存；不得作为冷启动必需输入
├── result/                   # 结果、表格、图表和日志
│   ├── case33bw/
│   │   └── figures/          # case33bw 正式图及其配套文件
│   └── case123/
│       └── figures/          # case123 正式图及其配套文件
├── tests/                    # 调参、局部验证和临时检查
├── 01_IDEA/                  # 故事线、主张、推导、符号、证据索引、研究轨迹
├── 02_PAPER/                 # 论文写作材料和作者配置示例
├── 03_REFERENCE/             # 参考文献、BibTeX、阅读材料
└── .cursor/                  # 协作规则和 agent 约束
```

GitHub 不保存空目录，所以模板用少量 README 文件保留关键目录。这些 README 是目录说明；结果证据以 `result/`、`evidence_map.md` 和正式图证据包为准。

## 每个目录放什么

`ProjectName_note.md` 是给作者和合作者看的主研究笔记，呈现项目当前认识的公开版本。研究问题、模型边界、关键决策、结果状态和写作检查都应该能在这里找到。

`01_IDEA/` 是论文想法的结构化草稿：

- `story.md`：论文故事线和科学问题。
- `claims.md`：每个主张、证据编号、判伪标准和当前状态。
- `derivation.md`：变量、假设、公式和近似边界。
- `symbols.md`：全文统一符号、单位、维度和代码变量映射。
- `evidence_map.md`：claim 到入口脚本、结果文件和证据状态的索引。
- `research_trace.yaml`：关键决策、失败路径、路线转向和未解决问题。

`ProjectName_case33bw.m` 和 `ProjectName_case123.m` 是算例级正式入口。每个入口负责本 case 的完整流程编排：配置、输入检查、终端步骤跟踪、数据加载、本文方法、对比算法、指标汇总、结果写入和正式图导出。入口文件只组织流程，具体计算、IO、指标、绘图和对比算法放入对应 package。

`ProjectName.m` 是项目级汇总入口。它串联模板登记的 case 入口，并预留跨 case 汇总表和全局图表出口，例如规模扩展对比、总体性能对比和跨 case 结果摘要。

`+ProjectName_core/` 放真正定义本文贡献的核心代码，例如物理模型、数学模型、核心算法、求解器封装和论文主指标。

`+ProjectName_utils/` 放附属代码，即不定义贡献但项目会复用的支撑工具，例如目录创建、summary 输出、随机种子、缓存读写、流程跟踪、局部长耗时进度条和绘图导出。绘图工具放在 `+ProjectName_utils/+plotting/`。

`+ProjectName_sota/` 放对比算法和基线实现。对比方法应和本文方法共用同一数据、指标和约束口径。

正式可复用代码必须按“核心代码、附属代码、对比算法”三类进入对应 package，并继续放入有语义的子包。package 根目录只保留 README、很短的 package 级调度入口或注册表，不堆放一批松散函数。

- 核心代码进入 `+ProjectName_core/+<物理对象或流程阶段>/`，例如网络模型、潮流模型、优化建模、风险指标、收敛诊断等。
- 附属代码进入 `+ProjectName_utils/+<支撑流程>/`，例如 `+io/`、`+mc/`、`+plotting/`、`+cache/`、`+logging/`。
- 对比算法进入 `+ProjectName_sota/+<算法族或基线名称>/`，每个基线保持自己的实现、参数说明和适配入口。

子包名和 `.m` 文件名必须表达实际物理对象、数学操作或流程步骤，例如 `build_power_flow_model.m`、`solve_dispatch_subproblem.m`、`evaluate_voltage_risk.m`、`export_case_summary.m`。正式代码中避免 `helper.m`、`utils.m`、`misc.m`、`temp.m`、`test1.m`、`new_method.m` 这类无法说明职责的名称。

`data/` 放完整复现项目代码所需的输入文件，包括原始数据、算例文件、参数表、外部基线输入和必要的轻量说明。提交或交接前，正式入口必须能在不读取既有 `cache/` 文件的情况下，从 `data/` 重新开始计算。

`cache/` 只放由代码从 `data/`、配置和随机种子派生出来的中间结果。缓存可以用于加速复跑，但不能是正式计算的启动条件。如果代码需要某个缓存文件才能启动，应把它上溯为 `data/` 输入，或修改代码让它由 `data/` 自动生成。

`result/<case>/` 放这个 case 的正式结果、表格和日志。正式图统一放在 `result/<case>/figures/`。

## 文档分层

这个模板区分给人看的研究材料和给 AI/agent 执行的规则：

| 类型 | 文件 | 作用 |
| --- | --- | --- |
| 人类研究材料 | `ProjectName_note.md`; `01_IDEA/` | 记录问题、主张、推导、证据和路线演化，便于作者、学生和合作者阅读 |
| 论文材料 | `02_PAPER/`; `03_REFERENCE/` | 沉淀论文草稿、作者配置示例、参考文献和阅读材料 |
| AI 执行规则 | `.cursor/rules/` | 约束 agent 的代码组织、出图出口、证据同步和写作边界 |
| AI 写作规则 | `.cursor/rules/03-public-note-and-paper-skill-bridge.mdc`; `.cursor/rules/lexicon.md` | 统一检查中英文 AI 生成文本中的套话、空泛词和范围过强表述 |
| 代码质量门 | `+ProjectName_utils/+plotting/save_figure.m` | 在正式出图时检查 metadata、导出包和检查报告 |

`01_IDEA/` 不承担 agent 规则说明的职责。它应像研究白板一样，直接呈现故事线、claim、推导、证据和路线记录。

## 目录组织原则

这个模板有意保持根目录很小。常规工作优先放入已有目录和每个 case 的 `figures/`。

常用放置方式：

- 可复用 MATLAB 函数放入已有 package。
- 核心代码、附属代码和对比算法分别放入 `+ProjectName_core/`、`+ProjectName_utils/`、`+ProjectName_sota/`，并继续按物理对象或流程阶段拆到子包。
- 临时验证放入 `tests/`。
- 正式 case orchestration 放在根目录的 `ProjectName_case*.m`，每个入口用步骤注释写清楚完整流程。
- 绘图工具放在 `+ProjectName_utils/+plotting/`。

如果项目规模确实需要新的组织方式，由项目作者明确决定，再补充相应说明。

## 结果和图表规范

正式论文图以 MATLAB 脚本作为统一出口，形成源图、预览图、矢量图、绘图数据、manifest 和检查报告组成的证据包。截图、复制粘贴、Python/Matplotlib、Excel 或 Origin 可以用于临时讨论，但正式论文图从 MATLAB 证据包中取得。投稿阶段如果需要 `.pdf`、`.eps` 或 `.tiff`，由同一 MATLAB 图窗和同一导出脚本额外生成。

出图规则的优先级固定为：

```text
数据真实性 > 可追溯性 > 黑白可辨识 > 字号可读性 > 排版尺寸 > 美观
```

数据真实性优先于视觉效果。任何筛选、变换、对数轴零值替代、异常点剔除都同时写入绘图数据、manifest 和检查报告。遇到质量规则冲突时，先记录冲突原因，再决定是否生成诊断图或调整图型。

每个 case 都有自己的图表目录：

```text
result/<case>/figures/
```

正式图统一通过：

```matlab
ProjectName_utils.plotting.save_figure(...)
```

每张正式图至少应生成：

- `.fig`：MATLAB 源图。
- `.png`：预览图，正式图不低于 300 dpi，诊断图不低于 200 dpi。
- `.svg`：矢量图。
- `*_plot_data.csv`：折线图、柱状图、散点图等必须同步导出绘图数据；概率密度图还要导出 histogram bin 和叠加 PDF 曲线采样点。
- `figure_manifest.jsonl`：每图一行的追溯信息。
- `figure_check_report.md`：自动检查和人工复核项。

正式图导出前必须明确：

- 图要回答的科学或工程问题。
- 数据文件、字段含义、单位、维度和预处理状态。
- 全局视觉编码。
- 目标排版尺寸，例如 `single-column`、`double-column` 或目标期刊指定尺寸。
- 运行命令、关键参数和随机种子，或明确写 `not_applicable`。

`ProjectName_utils.plotting.save_figure` 会检查 metadata。缺少 `sciQuestion`、`dataFiles`、`dataDescription`、`visualEncoding`、`targetLayout`、`command`、`keyParams` 或 `randomSeed` 时，不允许导出正式图。

同一方法或类别的颜色、线型、marker、灰度和 hatch 在 `ProjectName_utils.plotting.methodStyle` 中统一登记。折线图优先使用 `ProjectName_utils.plotting.plot_method_line`，通过稀疏 marker 避免节点或时间点过密。方法区分同时使用颜色、线型和 marker，方便彩色与黑白出版。

组合展示先分别输出独立子图，例如 `Fig05a`、`Fig05b`、`Fig05c`，再进入论文排版。

常见图型遵循以下边界：

- 结果值对比图：同时显示基准解和待比较方法。
- 误差图：聚焦待比较方法的误差。
- 跨数量级误差：使用对数纵轴，并在 manifest 中记录零值或负值处理阈值。
- 分布距离指标：按节点或逐点绘制，不只给平均值柱状图；带物理量纲的指标必须标单位。
- 概率密度对比图：以基准 histogram 为底，叠加各方法 PDF 曲线；每个代表点单独出图。

每张图生成后必须检查 `.fig/.png/.svg` 是否齐全、PNG 是否非空白、SVG 是否可读、CSV 是否与图中曲线一致、图例是否遮挡关键曲线、横轴标签是否过密、黑白显示是否可辨、结构化标签是否采用领域可读写法，以及异常点和对数轴处理是否已声明。

## 研究笔记规范

`ProjectName_note.md` 是项目研究档案，用来把研究从想法整理成可复核、可接力、可提炼为论文的材料。它应记录问题如何形成、路线如何演变、数学模型如何落地、代码如何对应、结果如何支持或修正当前判断。核心符号、单位、维度和代码变量映射以 `01_IDEA/symbols.md` 为准，并在 `derivation.md` 和本笔记中保持一致。

推荐写法是中性、客观、可验证、可追溯。优先使用“当前证据支持”“该判断仍需验证”“该路线已归档”“该结论目前仅在某算例中观察到”等表达，让读者清楚看到证据强度。

AI 生成的研究笔记、论文草稿、审稿回复、图注、README 和代码注释应通过 `.cursor/rules/03-public-note-and-paper-skill-bridge.mdc` 中的写作风格检查，并用 `.cursor/rules/lexicon.md` 做最终词表筛查。文本应直接陈述技术对象、机制、范围、指标和证据状态。

每个判断性结论必须标注证据状态。推荐状态包括：

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

如果缺少信息，直接使用 `【待补充】`、`【尚未验证】`、`【文献待核查】`、`【当前证据不足】`、`【Git 待提交】`、`【文档滞后】`、`【尚未实现】`、`【代码待核查】` 等标记，把后续需要补的工作显式留下。

研究笔记至少保留三条主线：

```text
问题形成主线：工程需求 -> 现有不足 -> 痛点问题 -> 科学问题
研究演化主线：初始思路 -> 暴露问题 -> 方案调整 -> 当前路线
可追溯主线：数学模型 -> 代码实现 -> Git 版本 -> 阶段性验证 -> 证据状态
```

被放弃的建模、求解、实验和对比路线也应保留，并写清楚原始设想、尝试方式、暴露问题、放弃原因和后续启示。若无法读取 Git 历史，保留 Git 字段并标注 `【Git 信息待补充】`，方便后续补齐版本关联。

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

每个 case 入口负责创建自己的结果目录、缓存目录和图表目录，并调用包内函数完成该 case 的正式流程。`ProjectName.m` 负责串联模板登记 case 并生成跨 case 汇总。核心算法放入 `+ProjectName_core/`，对比算法放入 `+ProjectName_sota/`，流程、IO、绘图和局部长耗时进度条放入 `+ProjectName_utils/`。

## 提交前复现检查

项目提交、交接或论文复核前，先把 `cache/` 临时重命名或清空，只保留代码和 `data/` 中的文件，然后运行 `ProjectName` 或所有正式 `ProjectName_case*.m`。如果计算必须读取既有缓存才能启动，说明数据边界还没有闭合；应补齐 `data/`，或让代码从 `data/` 自动重建缓存。

`result/` 可以保存正式证据、表格、图和日志，但默认也不作为计算启动输入。只有在明确写成“复核既有结果”的脚本中，才可以把 `result/` 作为读取对象。

## 优化器策略

默认优先使用本机 MATLAB 工具链，不优先调用 GAMS：

1. `CVX + MOSEK`：SDP、SOCP、凸优化原型和 disciplined convex models。
2. `Gurobi`：LP、QP、MILP、MIQP，以及可写成 LP/QP/QCP 的 SCA 子问题。
3. `MOSEK` 直接接口：不经过 CVX 更清晰或更快的锥规划。
4. `GAMS`：遗留模型复现、外部作者基线或尚未改写模型的备选路径。

新增优化模型时，优先通过 MATLAB 可见性检查确认 `cvx_begin`、`mosekopt`、`gurobi` 等接口可用。

选择软件依赖时默认考虑 Windows MATLAB 和 Apple Silicon macOS 双平台：

- 优先使用 MATLAB 原生路径、跨平台 toolbox、CVX/MOSEK/Gurobi 等在目标平台可安装的接口。
- 不把 Windows 盘符路径、`.exe`、x86-only 二进制、仅 Windows 可用的求解器或 GAMS 许可写成必要启动路径。
- 若遗留复现确实需要平台限定工具，应隔离成可选 adapter，并在入口、证据图或 README 中写明主流程冷启动依赖范围。

## Git 管理建议

建议跟踪：

- 模板入口和 MATLAB package。
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

如果某个结果要作为论文证据长期保存，应先确认它已经登记到 `01_IDEA/evidence_map.md`，再由项目作者决定是否纳入版本管理。

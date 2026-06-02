# project-template-lite

轻量级 MATLAB 科研论文项目模板。它适合用来维护一个从想法、模型、算例、结果图表到论文证据都能互相追溯的研究项目。

这个模板的核心判断很简单：项目根目录就是 MATLAB 代码根目录；不要为了整理而不断新增文件夹；每个论文主张都要能追到入口脚本、结果文件和证据状态。

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
5. 把原始数据放入 `data/`，把正式计算写进根目录的 `ProjectName_case*.m`。
6. 如果需要作者信息配置，复制 `02_PAPER/config/author-profile.example.yaml` 为本地的 `author-profile.yaml`，再填写个人信息。真实 `author-profile.yaml` 不进入 Git。
7. 在 MATLAB 里进入项目根目录，运行：

```matlab
ProjectName_case33bw
```

8. 有正式结果后，同步更新：
   - `ProjectName_note.md`
   - `01_IDEA/evidence_map.md`
   - 对应的 `result/<case>/` 路径

## 目录地图

```text
.
├── ProjectName_note.md       # 项目研究笔记：研究意义、模型、证据、论文边界
├── ProjectName.m             # 统一入口：组织本文方法和 SOTA 对比
├── ProjectName_case33bw.m    # case33bw 算例入口
├── ProjectName_case123.m     # case123 算例入口
├── +ProjectName_core/        # 核心模型、算法、求解和指标函数
├── +ProjectName_utils/       # IO、MC、绘图、缓存等非核心工具
├── +ProjectName_sota/        # 对比方法和基线实现
├── data/                     # 原始数据和算例输入
├── cache/                    # 中间缓存，不作为论文证据
├── result/                   # 结果、表格、图表和日志
│   ├── case33bw/
│   │   └── figures/          # case33bw 正式图及其配套文件
│   └── case123/
│       └── figures/          # case123 正式图及其配套文件
├── tests/                    # 调参、局部验证和临时检查
├── 01_IDEA/                  # 故事线、主张、推导、证据索引、研究轨迹
├── 02_PAPER/                 # 论文写作材料和作者配置示例
├── 03_REFERENCE/             # 参考文献、BibTeX、阅读材料
└── .cursor/                  # 协作规则和 agent 约束
```

GitHub 不保存空目录，所以模板用少量 README 文件保留关键目录。不要把这些 README 当成结果证据。

## 每个目录放什么

`ProjectName_note.md` 是给作者和合作者看的主研究笔记。它不是随手日志，而是项目当前认识的公开版本：研究问题、模型边界、关键决策、结果状态和写作检查都应该能在这里找到。

`01_IDEA/` 是论文想法的结构化草稿：

- `story.md`：论文故事线和科学问题。
- `claims.md`：每个主张、证据编号、判伪标准和当前状态。
- `derivation.md`：变量、假设、公式和近似边界。
- `evidence_map.md`：claim 到入口脚本、结果文件和证据状态的索引。
- `research_trace.yaml`：关键决策、失败路径、路线转向和未解决问题。

`+ProjectName_core/` 放真正定义本文贡献的模型、算法、求解器封装和指标函数。

`+ProjectName_utils/` 放不定义贡献但项目会复用的工具，例如目录创建、summary 输出、随机种子、绘图导出。绘图工具放在 `+ProjectName_utils/+plotting/`。

`+ProjectName_sota/` 放对比方法和基线实现。对比方法应和本文方法共用同一数据、指标和约束口径。

`result/<case>/` 放这个 case 的正式结果、表格和日志。正式图统一放在 `result/<case>/figures/`。

## 不要默认新增目录

这个模板有意保持根目录很小。除已有目录和每个 case 的 `figures/` 外，默认不要新增目录。

尤其不要因为“整理脚本”而新建：

- `scripts/`
- `tools/`
- `utils/`
- 新的阶段式外壳目录

如果确实需要新的组织方式，应由项目作者明确决定。一般情况下：

- 可复用 MATLAB 函数放入已有 package。
- 临时验证放入 `tests/`。
- 正式 case orchestration 放在根目录的 `ProjectName_case*.m`。
- 绘图工具放在 `+ProjectName_utils/+plotting/`。

## 结果和图表规范

正式论文图必须由 MATLAB 脚本生成，不使用截图、复制粘贴、Python/Matplotlib、Excel 或 Origin 作为正式图出口。投稿阶段如果需要 `.pdf`、`.eps` 或 `.tiff`，也必须由同一 MATLAB 图窗和同一导出脚本额外生成。

出图规则的优先级固定为：

```text
数据真实性 > 可追溯性 > 黑白可辨识 > 字号可读性 > 排版尺寸 > 美观
```

不得为了“好看”而修改数据、删除异常点、压缩坐标范围、平滑曲线或改写字段。任何筛选、变换、对数轴零值替代、异常点剔除都必须同时写入绘图数据、manifest 和检查报告。无法在不牺牲高优先级规则的前提下解决冲突时，停止出图并说明原因。

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

同一方法或类别的颜色、线型、marker、灰度和 hatch 必须在 `ProjectName_utils.plotting.methodStyle` 中统一登记。折线图优先使用 `ProjectName_utils.plotting.plot_method_line`，通过稀疏 marker 避免节点或时间点过密。不得只靠颜色区分方法。

正式论文不得直接交付 MATLAB 原生组合图、`subplot` 或 `tiledlayout`。若需要组合展示，先分别输出独立子图，例如 `Fig05a`、`Fig05b`、`Fig05c`，再进入论文排版。

常见图型遵循以下边界：

- 结果值对比图：同时显示基准解和待比较方法。
- 误差图：不显示基准自身的零误差。
- 跨数量级误差：使用对数纵轴，并在 manifest 中记录零值或负值处理阈值。
- 分布距离指标：按节点或逐点绘制，不只给平均值柱状图；带物理量纲的指标必须标单位。
- 概率密度对比图：以基准 histogram 为底，叠加各方法 PDF 曲线；每个代表点单独出图，不用组合图作为正式交付。

每张图生成后必须检查 `.fig/.png/.svg` 是否齐全、PNG 是否非空白、SVG 是否可读、CSV 是否与图中曲线一致、图例是否遮挡关键曲线、横轴标签是否过密、黑白显示是否可辨、结构化标签是否采用领域可读写法，以及异常点和对数轴处理是否已声明。

## 研究笔记规范

`ProjectName_note.md` 是项目研究档案，不是论文初稿、宣传材料、答辩稿或投稿文稿。它应记录问题如何形成、路线如何演变、数学模型如何落地、代码如何对应、结果如何支持或否定当前判断。

写作时必须保持中性、客观、可验证、可追溯。不要写“突破性”“彻底解决”“全面优于”“首次实现”等强表述，除非已经有充分文献检索、理论证明和定量实验支撑。

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

如果缺少信息，不得补写成事实。使用 `【待补充】`、`【尚未验证】`、`【文献待核查】`、`【当前证据不足】`、`【Git 待提交】`、`【文档滞后】`、`【尚未实现】`、`【代码待核查】` 等标记。

研究笔记至少保留三条主线：

```text
问题形成主线：工程需求 -> 现有不足 -> 痛点问题 -> 科学问题
研究演化主线：初始思路 -> 暴露问题 -> 方案调整 -> 当前路线
可追溯主线：数学模型 -> 代码实现 -> Git 版本 -> 阶段性验证 -> 证据状态
```

被放弃的建模、求解、实验和对比路线必须保留，并写清楚原始设想、尝试方式、暴露问题、放弃原因和后续启示。若无法读取 Git 历史，保留 Git 字段并标注 `【Git 信息待补充】`，不要删除版本关联结构。

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

每个入口负责创建自己的结果目录、缓存目录和图表目录。核心算法不要写成入口脚本里的大段过程，应放入 `+ProjectName_core/`。

## 优化器策略

默认优先使用本机 MATLAB 工具链，不优先调用 GAMS：

1. `CVX + MOSEK`：SDP、SOCP、凸优化原型和 disciplined convex models。
2. `Gurobi`：LP、QP、MILP、MIQP，以及可写成 LP/QP/QCP 的 SCA 子问题。
3. `MOSEK` 直接接口：不经过 CVX 更清晰或更快的锥规划。
4. `GAMS`：遗留模型复现、外部作者基线或尚未改写模型的备选路径。

新增优化模型时，先检查 MATLAB 能否直接看到 `cvx_begin`、`mosekopt`、`gurobi`，不要只根据安装目录判断求解器可用。

## Git 管理建议

建议跟踪：

- 模板入口和 MATLAB package。
- `.cursor/rules/`。
- `01_IDEA/`、`02_PAPER/config/author-profile.example.yaml`、`03_REFERENCE/` 中的轻量文本材料。
- `data/`、`cache/`、`tests/`、`result/` 里的 README 占位说明。

默认不要跟踪：

- `cache/` 中的生成文件。
- 真实运行输出。
- 大型 `.mat` 文件。
- `.fig`、日志、临时测试结果。
- 未经筛选的大型原始数据。
- 含真实个人信息的 `02_PAPER/config/author-profile.yaml`。

如果某个结果要作为论文证据长期保存，应先确认它已经登记到 `01_IDEA/evidence_map.md`，再由项目作者决定是否纳入版本管理。

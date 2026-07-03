# Figure Plan

## 图表计划的产出方式

本文件的 figure plan 默认由 `$powerlit-power-systems-paper-writing` 技能生成或修订。该技能的 `references/figures-tables-results.md` 内置「Project-Template Figure Plan Bridge」：检测到 `01_IDEA/figure_plan.md`、`.cursor/rules/04-case-figure-and-metric-plan.mdc` 或 `save_figure` 时，先用 PowerLit 检索目标期刊和问题近邻论文的图表证据实践（该 claim 类通常展示哪些图、每类图回答什么审稿问题、使用哪些公认指标、baseline 如何分组、参数/灵敏度图比较哪些范围和横轴组织），再结合本模板规则 `.cursor/rules/04` 的证据角色顺序（`scenario-setup → physical-reproduction → sota-comparison → sensitivity-ablation`）、按数据形状选图型和指标纪律，逐字段产出模板就绪的 case/图表计划。

分工是：PowerLit 提出计划，规则 04 提供结构与强制顺序，`save_figure` 在导出时强制校验元信息与顺序。

产出的计划必须能直接服务 `ProjectName_utils.plotting.save_figure`：每张正式图至少明确 `claim`、`evidenceRole`、`sciQuestion`、`physicsReproduction`、指标定义与单位、图形类型、数据文件、视觉编码和缺失结果 blocker。PowerLit 不可用时，在本节记录 fallback 来源，并只依据 `03_REFERENCE/`、用户提供文献或已有结果做保守规划。

本文件在导出任何正式算例图之前，先确认创新点、再决定每张图的证据角色、指标和图形类型。
它对应执行规则 `.cursor/rules/04-case-figure-and-metric-plan.mdc`。

填写顺序：先填「创新点锚定」，再按 case 填「图清单」。没有 claim 绑定的图不是正式算例图，应作为诊断图导出（`save_figure(..., "IsDiagnostic", true)`）。

## 创新点锚定

| 项目 | 当前内容 |
| --- | --- |
| 对应 claim 编号 | 【待补充：如 C1】 |
| 真正的创新结构 | 【待补充：本文新建模/新算法/新约束的物理或数学结构】 |
| 必须复现的物理场景 | 【待补充：本方法应当还原的真实或可信参照行为】 |
| 证伪条件 | 【待补充：什么结果会推翻该 claim】 |

## 证据角色顺序

每张正式图声明一个 `evidenceRole`，按 claim 维持以下顺序。`save_figure` 对非诊断图强制该顺序，
`sota-comparison` 与 `sensitivity-ablation` 不得早于同一 claim 的 `physical-reproduction` 图。

| 角色 | 作用 | 参照对象 |
| --- | --- | --- |
| `scenario-setup` | 展示网架、运行工况、输入数据和待复现场景 | 算例自身定义 |
| `physical-reproduction` | 证明本方法输出能复现真实测量或可信参照解 | 外部或独立可信数据，不得用本文自定义分数 |
| `sota-comparison` | 在匹配工况下对比最近基线 | 同口径基线方法 |
| `sensitivity-ablation` | 灵敏度、消融、规模、运行时间、外推 | 变体或参数扫描 |

## 填写示例（勿作正式计划）

下表是一行合格 `physical-reproduction` 图的示例，用来锚定填写标准，展示各字段应有的具体程度。它使用虚构的配电网电压场景，仅供参考，正式计划请删除或忽略本节。

| Fig 编号 | claim | evidenceRole | 科学问题 | 物理复现目标 / 参照数据 | 指标（定义 + 为何是公认指标） | 图形类型 | 数据文件 | 状态 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| FigX（示例） | C1 | physical-reproduction | 本文方法重构的节点电压幅值能否复现全网潮流参照解？ | 参照数据为 MATPOWER 全网 AC 潮流解的各节点电压幅值 | 各节点电压幅值绝对误差 MAE（p.u.，定义见 `symbols.md`；电压幅值误差是配电网状态复现的公认一致性度量） | 叠加折线（本文方法 vs 参照）+ 独立残差子图 | `result/case33bw/voltage_profile.csv` | 示例 |

说明：物理复现图的参照必须是外部/独立可信量（此处为 AC 潮流解），不能用本文自定义分数；指标要有单位、在 `symbols.md`/`derivation.md` 有定义，并说明为何公认。

## 图清单（按 case 填写）

### case33bw（支撑 C1）

| Fig 编号 | claim | evidenceRole | 科学问题 | 物理复现目标 / 参照数据 | 指标（定义 + 为何是公认指标） | 图形类型 | 数据文件 | 状态 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 【待补充】 | C1 | scenario-setup | 【待补充】 | 【待补充】 | 【待补充】 | 【待补充】 | `result/case33bw/figures/` | scaffold |
| 【待补充】 | C1 | physical-reproduction | 【待补充】 | 【待补充：真实/参照解】 | 【待补充：对参照的绝对或相对误差】 | 【待补充】 | `result/case33bw/figures/` | scaffold |
| 【待补充】 | C1 | sota-comparison | 【待补充】 | 【待补充】 | 【待补充】 | 【待补充】 | `result/case33bw/figures/` | scaffold |

### case123（支撑 C2）

| Fig 编号 | claim | evidenceRole | 科学问题 | 物理复现目标 / 参照数据 | 指标（定义 + 为何是公认指标） | 图形类型 | 数据文件 | 状态 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 【待补充】 | C2 | scenario-setup | 【待补充】 | 【待补充】 | 【待补充】 | 【待补充】 | `result/case123/figures/` | scaffold |
| 【待补充】 | C2 | physical-reproduction | 【待补充】 | 【待补充：真实/参照解】 | 【待补充：对参照的绝对或相对误差】 | 【待补充】 | `result/case123/figures/` | scaffold |
| 【待补充】 | C2 | sota-comparison | 【待补充】 | 【待补充】 | 【待补充】 | 【待补充】 | `result/case123/figures/` | scaffold |

### 跨 case 汇总（支撑 C3）

| Fig 编号 | claim | evidenceRole | 科学问题 | 物理复现目标 / 参照数据 | 指标（定义 + 为何是公认指标） | 图形类型 | 数据文件 | 状态 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 【待补充】 | C3 | sota-comparison | 【待补充】 | 【待补充】 | 【待补充】 | 【待补充】 | `result/project/figures/` | scaffold |
| 【待补充】 | C3 | sensitivity-ablation | 【待补充】 | 【待补充】 | 【待补充】 | 【待补充】 | `result/project/figures/` | scaffold |

## 指标白名单约束

- 每个指标都绑定到一个 claim 编号。
- 每个指标在 `01_IDEA/symbols.md` 或 `01_IDEA/derivation.md` 有定义、单位、量纲和物理含义。
- 指标是本问题类公认指标，或在使用前已写下定义的推导量。
- 禁止仅为「声称复现了物理场景」而新造复合指标。
- 禁止在 `physical-reproduction` 图中用自定义分数代替外部或可信参照。
- 禁止在与创新点无关的指标上对方法排名。

## 与其他文件的同步

- 图变为论文证据后，在 `01_IDEA/evidence_map.md` 登记。
- 若 `physical-reproduction` 图未能匹配参照，先在 `01_IDEA/claims.md` 和 `ProjectName_note.md` 修正 claim，再导出该 claim 的 `sota-comparison` 图。
- 保持 `save_figure` manifest 中的 `evidenceRole`、`claimId` 和指标定义与本计划一致。

# Figure Plan

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

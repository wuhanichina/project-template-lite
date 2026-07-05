# Evidence Map

本文件记录可验证研究结论与原始结果之间的对应关系。它回答一个问题：每个结论编号由哪个入口、哪份结果、哪组指标支撑。

## 证据登记表

| 证据编号 | 支撑结论编号 | 生成入口 | 原始结果文件 | 证据类型 | 关键指标/数值 | 求解器与配置 | 状态 | 备注 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| E01 | C1 | `ProjectName_case33bw.m` | `result/case33bw/summary.txt`; `result/case33bw/run_manifest.json`; `result/case33bw/figures/` | 主算例 | 待填 | 待填 | scaffold | case33bw 主场景 |
| E02 | C2 | `ProjectName_case123.m` | `result/case123/summary.txt`; `result/case123/run_manifest.json`; `result/case123/figures/` | 扩展算例 | 待填 | 待填 | scaffold | case123 扩展网架 |
| E03 | C3 | `ProjectName.m`; `+ProjectName_utils/+plotting/export_project_figures.m` | `result/project_summary.txt`; `result/project/figures/` | 跨 case 汇总与对比证据 | 待填 | 待填 | scaffold | 模板登记 case 的同口径汇总 |

## 图表证据包

每个正式算例先写出 `result/<case>/run_manifest.json`，记录入口命令、Git、MATLAB/平台、求解器可见性、配置、输入文件、缓存快照、summary、图表证据路径和证据登记提示。图表证据包记录单张图的科学问题、数据和导出质量；运行 manifest 记录整个 case 的复现输入、运行配置和输出文件。

正式图在导出前先在 `figure_plan.md` 完成计划：锚定正向创新点、绑定结论编号（导出 metadata 字段为 `claimId`）、确定证据角色（`scenario-setup` → `physical-reproduction` → `sota-comparison` → `sensitivity-ablation`）、指标和图形类型。

正式图按 case 保存到 `result/<case>/figures/`。每张图对应一个完整证据包：

| 文件 | 作用 |
| --- | --- |
| `.fig` | MATLAB 源图，便于复查和微调 |
| `.png` | 预览图 |
| `.svg` | 论文排版用矢量图 |
| `*_plot_data.csv` | 与图中曲线、柱状或散点对应的绘图数据 |
| `figure_manifest.jsonl` | 科学问题、数据文件、字段/单位/维度、视觉编码、目标尺寸、命令、参数和随机种子 |
| `figure_check_report.md` | 自动检查项和人工复核项 |

## 结果解释

| 证据编号 | 支持的具体判断 | 工程场景和证据口径 | 论文中可使用的图表或数字 | 需要同步更新的文件 |
| --- | --- | --- | --- | --- |
| E01 | 【待补充】 | 【待补充】 | 【待补充】 | `claims.md`; `ProjectName_note.md` |
| E02 | 【待补充】 | 【待补充】 | 【待补充】 | `claims.md`; `ProjectName_note.md` |
| E03 | 【待补充】 | 【待补充】 | 【待补充】 | `claims.md`; `ProjectName_note.md` |

## 状态约定

| 状态 | 含义 |
| --- | --- |
| scaffold | 模板占位，还没有真实计算 |
| running | 正在计算或等待补充输出 |
| supported | 当前证据支撑对应结论 |
| weakened | 证据只支撑较弱版本的结论 |
| revised | 证据促使结论表述、工程场景或证据状态被修正 |
| archived | 曾经有用，但不再支撑当前论文主线 |

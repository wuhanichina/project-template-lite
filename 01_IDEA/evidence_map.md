# Evidence Map

本文件是轻量证据索引。它不替代 `result/` 中的原始输出，也不替代 `ProjectName_note.md` 中的研究叙述；它只回答一个问题：每个论文 claim 到底由哪个入口、哪份结果、哪组指标支撑。

## 证据登记表

| 证据编号 | 支撑 claim | 生成入口 | 原始结果文件 | 证据类型 | 关键指标/数值 | 求解器与配置 | 状态 | 备注 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| E01 | C1 | `ProjectName_case33bw.m` | `result/case33bw/summary.txt`; `result/case33bw/figures/` | 主算例 | 待填 | 待填 | scaffold | case33bw 主场景 |
| E02 | C2 | `ProjectName_case123.m` | `result/case123/summary.txt`; `result/case123/figures/` | 扩展算例 | 待填 | 待填 | scaffold | case123 扩展网架 |
| E03 | C3 | `ProjectName.m` / `+ProjectName_sota/` | `result/...` | 对比证据 | 待填 | 待填 | 待验证 | 同数据、同指标、同约束下比较 |

## 登记规则

- 只有能改变论文判断、支撑公开主张或说明失败边界的结果才登记。
- 原始表格、图像数据和日志保留在 `result/`；正式图按 case 保留在 `result/<case>/figures/`，并同步保留绘图数据、manifest 和检查报告。本文件只写路径、指标摘要和状态。
- 数值进入论文前要从原始结果复制，不能凭记忆改写或四舍五入后反推。
- 如果从原始表格中截取子集，状态或备注里必须标明 `derived subset`，不要把子集冒充为原始表格。
- 修改模型形式、求解器、容差、随机种子、输入数据或对比基线后，重新登记对应证据状态。
- 某个结果削弱原 claim 时，优先修改 `claims.md` 和 `ProjectName_note.md`，不要只在论文文字中弱化。
- 正式图必须能追溯到同目录下的 `.fig`、`.png`、`.svg`、`*_plot_data.csv`、`figure_manifest.jsonl` 和 `figure_check_report.md`。
- 图表证据登记前，确认 manifest 中已经写明科学问题、数据文件、字段/单位/维度、视觉编码、目标排版尺寸、运行命令、关键参数、随机种子或 `not_applicable`。
- 不登记为了视觉效果改过数据但未声明的图。任何筛选、剔除、平滑、坐标变换、对数轴零值替代或诊断图，都必须在备注中写清楚。
- 组合图不作为原始正式图证据登记；先登记独立子图，再在论文排版中组合。

## 状态约定

| 状态 | 含义 |
| --- | --- |
| scaffold | 模板占位，还没有真实计算 |
| running | 正在计算或等待补充输出 |
| supported | 当前证据支撑对应 claim |
| weakened | 证据只支撑较弱版本的 claim |
| refuted | 证据反驳原 claim，需要改写路线 |
| archived | 曾经有用，但不再支撑当前论文主线 |

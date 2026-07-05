# 01_IDEA

本目录保存论文想法的结构化研究材料。这里的文件面向作者、学生和合作者，直接记录最小可辨识研究对象、工程痛点、可验证结论、推导、符号、证据和路线演化；执行规则和 agent 约束放在 `.cursor/rules/`。

## 文件说明

```text
01_IDEA/
├── story.md              # 最小可辨识研究对象、工程痛点、科学问题和文章主线
├── claims.md             # 可验证研究结论、证据编号、判据和当前状态
├── derivation.md         # 数学模型、假设、推导和代码对应关系
├── symbols.md            # 全文统一符号表和代码变量映射
├── evidence_map.md       # 结论编号、入口脚本、run manifest、结果文件和证据状态索引
├── figure_plan.md        # 算例图与指标计划：创新点锚定、证据角色顺序和图形类型
└── research_trace.yaml   # 关键决策、分叉探索、保留思路、归档路线和未解决问题
```

## 维护顺序

1. 先在 `story.md` 判定最小可辨识研究对象、研究领域、具体工程对象和研究方向，写清工程需求、现有不足、核心痛点和科学问题。
2. 再在 `claims.md` 用正向技术句写出可验证研究结论、工程场景和证据编号。
3. 在 `symbols.md` 登记核心符号、维度、单位和代码变量。
4. 在 `derivation.md` 写推导、假设和代码位置。
5. 导出正式算例图前，默认先用 `$powerlit-power-systems-paper-writing` 生成或修订 `figure_plan.md`，锚定正向创新点，并确定每张图的证据角色、指标、图形类型和 `save_figure` metadata。
6. 运行 case 后，把 `result/<case>/run_manifest.json` 和正式结果登记到 `evidence_map.md`。
7. 路线调整、分叉探索、失败方案和未解决问题同步写入 `research_trace.yaml`。

如果公式、变量、可验证结论或证据状态发生变化，应同步更新 `ProjectName_note.md` 和 `ProjectName_changelog.md`，使根目录研究笔记保持为当前最小可辨识研究对象、结论和证据状态，并让研究内容版本记录可追溯。

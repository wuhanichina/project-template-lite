# 01_IDEA

本目录保存论文想法的结构化研究材料。这里的文件面向作者、学生和合作者，直接记录最小可辨识研究对象、工程痛点、可验证结论、推导、符号、证据和路线演化；执行规则和 agent 约束放在 `.cursor/rules/`。

## 文件说明

```text
01_IDEA/
├── story.md              # 项目研究目的基线、最小可辨识研究对象、工程痛点、科学问题和文章主线
├── claims.md             # 可验证研究结论、证据编号、判据和当前状态
├── derivation.md         # 数学模型、假设、推导和代码对应关系
├── symbols.md            # 全文统一符号表和代码变量映射
├── evidence_map.md       # 结论编号、入口脚本、run manifest、结果文件和证据状态索引
├── figure_plan.md        # 算例图故事：工程问题、方法作用、直接对比、工程效果和导出审计字段
└── research_trace.yaml   # 关键决策、分叉探索、保留思路、归档路线和未解决问题
```

## 维护顺序

1. 先在 `story.md` 确认项目研究目的的立项基线，再判定最小可辨识研究对象、研究领域、具体工程对象和研究方向，确认创新轴、技术对象、叙事路线与重点解释关系，并写清工程需求、现有不足、核心痛点和科学问题。
2. 再在 `claims.md` 用正向技术句写出可验证研究结论、工程场景和证据编号。
3. 在 `symbols.md` 登记核心符号、维度、单位和代码变量。
4. 在 `derivation.md` 写推导、假设和代码位置。
5. 导出正式算例图前，默认先用 `$powerlit-power-systems-paper-writing` 检查近邻论文的物理量、代表性方法和直接对比方式，再在 `figure_plan.md` 写清算例的完整工程故事，确定每张图让读者直接看到的问题、本文方法作用、方法差异或工程效果，并单独填写 `save_figure` 审计字段。
6. 运行 case 后，把 `result/<case>/run_manifest.json` 和正式结果登记到 `evidence_map.md`。
7. 路线调整、分叉探索、失败方案和未解决问题同步写入 `research_trace.yaml`。
8. `ProjectName_blog.md` 根据已确认的创新轴、技术对象和叙事路线，从上述材料提取有范围的对外说明；它不能替代结论、推导、证据索引、结果或参考文献，也不能轻量改写后直接进入 Introduction 或 Contributions。

项目研究目的发生实质变化时，先更新 `story.md` 的立项基线，再同步 `02_PAPER/config/paper-profile.yaml`、`ProjectName_note.md` 和 `ProjectName_changelog.md`。如果公式、变量、可验证结论或证据状态发生变化，应同步更新 `ProjectName_note.md` 和 `ProjectName_changelog.md`，使根目录研究笔记保持为当前最小可辨识研究对象、结论和证据状态，并让研究内容版本记录可追溯。

`story.md`、`claims.md` 和 `figure_plan.md` 的创新点正文使用领域通用术语、工程对象、物理量、模型关系和可查证算例名称。内部实验配置代号、临时参数组名、分支名或脚本缩写只写入证据编号、入口文件、结果路径、run manifest、Git 记录或配置字段。

判断性结论的默认证据状态使用 `尚未验证`。其他状态使用 `.cursor/rules/03-public-note-and-paper-skill-bridge.mdc` 的闭合词表；缺失信息使用 `【待补充】`、`【文献待核查】`、`【当前证据不足】`、`【尚未实现】` 或 `【结果待复核】` 等显式占位。

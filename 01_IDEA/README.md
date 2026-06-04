# 01_IDEA

本目录保存论文想法的结构化研究材料。这里的文件面向作者、学生和合作者，直接记录故事线、主张、推导、符号、证据和路线演化；执行规则和 agent 约束放在 `.cursor/rules/`。

## 文件说明

```text
01_IDEA/
├── story.md              # 论文故事线、科学问题和技术矛盾
├── claims.md             # 可投稿主张、证据编号、判据和当前状态
├── derivation.md         # 数学模型、假设、推导和代码对应关系
├── symbols.md            # 全文统一符号表和代码变量映射
├── evidence_map.md       # claim、入口脚本、结果文件和证据状态索引
└── research_trace.yaml   # 关键决策、保留思路、归档路线和未解决问题
```

## 维护顺序

1. 先在 `story.md` 收窄工程需求、现有不足和科学问题。
2. 再在 `claims.md` 写出可判伪的主张和证据编号。
3. 在 `symbols.md` 登记核心符号、维度、单位和代码变量。
4. 在 `derivation.md` 写推导、假设和代码位置。
5. 运行 case 后，把正式结果登记到 `evidence_map.md`。
6. 路线调整、失败方案和未解决问题同步写入 `research_trace.yaml`。

如果公式、变量、主张或证据状态发生变化，应同步更新 `ProjectName_note.md`，使根目录研究笔记保持为当前公开研究边界。

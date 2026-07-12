# 02_PAPER

本目录保存面向论文的草稿、图注、审稿回复和作者侧材料。论文文字从证据承载材料提炼，不从对外叙事文案直接复制。

## 材料分层

| 层级 | 文件或目录 | 用途 |
| --- | --- | --- |
| 研究档案 | `ProjectName_note.md`、`ProjectName_changelog.md` | 当前问题、路线、模型、版本和证据状态 |
| 结论与推导 | `01_IDEA/claims.md`、`derivation.md`、`symbols.md` | 结论编号、公式、假设、单位和代码映射 |
| 证据与边界 | `01_IDEA/evidence_map.md`、`research_trace.yaml`、`result/` | 登记结果、run manifest、失败路线和适用边界 |
| 文献材料 | `03_REFERENCE/` | 已核查文献、最近竞争者和引用信息 |
| 对外叙事参考 | `ProjectName_blog.md` | 只参考与创新轴、技术对象和 `narrativeArc` 匹配的叙事顺序，不作为证据或论文现成措辞 |
| 论文档案 | `02_PAPER/config/paper-profile.yaml` | 保存已确认的创新四轴、叙事路由、生命周期与证据边界 |
| 投稿终检 | `02_PAPER/submission_consistency.md` | 保存最近一次检查版本、问题位置、修复状态与放行结论 |
| 返修工件 | `02_PAPER/revision/` | 保存审稿意见、真实缺口、修改动作、证据需求与回复状态 |

Introduction 和 Contributions 必须从研究档案、结论、推导、登记结果和已核查文献重新组织。`ProjectName_blog.md` 中的项目判断即使表达完整，也要再次核对适用范围、证据来源和证据状态；不能轻量改写后直接进入稿件。作者经验、工程直觉和未登记观察只能作为 `仅为当前假设`、`尚未验证` 或 `文献待核查` 的研究问题。

AI 生成的正文、图注、审稿回复和作者侧说明在发布前应通过 `.cursor/rules/03-public-note-and-paper-skill-bridge.mdc` 的写作检查和 `.cursor/rules/lexicon.md` 的词表检查。

正式论文图来自 `result/<case>/figures/`，并由 `ProjectName_utils.plotting.save_figure` 导出 FIG、PNG、SVG、可选格式、绘图数据、manifest 和检查报告。图表成为论文证据前，应在 `01_IDEA/evidence_map.md` 登记。

## 作者配置

仓库只跟踪示例文件：

```text
02_PAPER/config/author-profile.example.yaml
```

本地使用时复制为 `02_PAPER/config/author-profile.yaml`。真实文件可能含个人信息，应继续由 `.gitignore` 排除。

## 论文档案

复制 `02_PAPER/config/paper-profile.example.yaml` 为
`02_PAPER/config/paper-profile.yaml` 并纳入项目版本控制。该文件不保存
作者隐私，而是 Skill 与模板共享的确认状态。`contractVersion` 必须与
`.cursor/contracts/project-template-handoff.schema.yaml` 一致。PowerLit 负责解释
创新与写作政策；模板只保存确认值、运行事实和审计工件。

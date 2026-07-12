# tests

本目录保存临时验证、调参检查、smoke test 和本地调试入口。测试可以支持开发，但结果只有通过正式算例或已说明的验证入口生成，并登记到 `01_IDEA/evidence_map.md` 后，才可作为论文证据。

## 最低环境

- 目标最低兼容版本为 MATLAB R2020a。图形导出路径使用 R2020a 引入的 `exportgraphics`；当前本地终检使用 R2025b，CI 使用官方托管 runner 可选的最低版本 R2021a，因此不要把这两项结果表述成 R2020a 实机验证。
- `smoke_figure_profile.m`、`smoke_figure_contracts.m`、`smoke_run_contracts.m` 与 `smoke_handoff_contracts.m` 依赖基础 MATLAB、标准 JVM、可用的本地图形环境和命令行可调用的 Git，不依赖 CVX、MOSEK、Gurobi 或项目 `data/`。
- 具体研究模型需要的 toolbox、求解器和数据由项目入口另行声明。

## 运行 smoke test

在项目根目录执行：

```powershell
matlab -batch "addpath(fullfile(pwd,'tests')); run_template_smoke_tests"
```

完整 suite 检查默认 IEEE 图形 profile、FIG/PNG/SVG/PDF/CSV 事务提交与异常回滚、并发锁、figure manifest 当前登记、正式 claim 绑定、证据角色顺序、override 原因、递归输入 SHA-256 指纹、Git porcelain 状态、两个正式 case 入口的成功与失败 manifest，以及 vendored handoff 版本/哈希、paper profile 必填字段、生命周期、Figure-first 计划字段和返修状态枚举。命令以非零状态退出表示 smoke test 未通过。

`.github/workflows/matlab-smoke.yml` 使用 MATLAB R2021a 在 push、pull request 和手动触发时运行同一套测试。R2021a 是官方托管 MATLAB Actions 当前支持的最低 release；公开仓库由 MATLAB Actions 自动许可，私有仓库需把 batch licensing token 保存为仓库 secret `MATLAB_BATCH_TOKEN`，workflow 会映射到 `MLM_LICENSE_TOKEN`。本地交接前仍应运行同一命令。

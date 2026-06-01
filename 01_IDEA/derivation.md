# Derivation

## 符号表

| 符号 | 含义 | 代码变量 |
| --- | --- | --- |
| $x$ | 待定义的状态、决策或估计对象 | `x` |
| $\theta$ | 模型参数或校准参数 | `theta` |
| $f(x,\theta)$ | 核心目标、约束或评价函数 | `objective` / `metric` |

## 基本假设

1. 写清楚数据、物理模型或随机变量的适用条件。
2. 写清楚哪些近似是为了计算可行，哪些近似是论文主张的一部分。
3. 写清楚与对比方法共享的假设，避免把不公平设定写成性能提升。

## 核心推导

从最小可验证形式开始：

$$
\text{input} \rightarrow \text{model} \rightarrow \text{solution} \rightarrow \text{metric}.
$$

后续把关键公式逐步替换为真实模型。例如：

$$
\min_x f(x,\theta)
$$

subject to

$$
g_i(x,\theta) \le 0,\quad i=1,\ldots,m.
$$

## 与代码的对应关系

| 推导对象 | 代码位置 | 说明 |
| --- | --- | --- |
| 统一运行 | `ProjectName.m` | 汇总本文方法和 SOTA 对比，支撑论文图表 |
| case33bw 数据输入 | `ProjectName_case33bw.m` | case33bw 算例数据入口 |
| case123 数据输入 | `ProjectName_case123.m` | case123 算例数据入口 |
| 模型构建 | `+ProjectName_core/` | 核心模型、算法和求解函数 |
| 非核心工具 | `+ProjectName_utils/` | MC、IO、绘图、缓存读写等工程支撑函数 |
| 对比方法 | `+ProjectName_sota/` | 基线方法、共同指标和对比逻辑 |

## 推导检查

- 公式中的每个变量是否能在代码中找到对应变量？
- 代码中的每个核心指标是否能在公式或 claim 中找到位置？
- 近似是否会改变结论方向？
- 如果审稿人要求复现，是否能从入口文件追到结果表？

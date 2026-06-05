# +ProjectName_core

Put reusable model formulation, contribution-defining algorithms, solver
wrappers, and paper metrics here.

Organize implementation code into semantic subpackages instead of leaving many
loose functions in this package root. Subpackage names should describe the
physical object, mathematical component, or workflow stage they own, for example
`+network_model/`, `+power_flow/`, `+optimization/`, `+risk_metrics/`, or
`+diagnostics/`.

File names should say what the function physically or procedurally does, such as
`build_power_flow_model.m`, `solve_dispatch_subproblem.m`, or
`evaluate_voltage_risk.m`. Avoid generic names such as `helper.m`, `utils.m`,
`misc.m`, `temp.m`, or `new_method.m` for formal code.

Keep case orchestration in the root `ProjectName_case*.m` files and keep
plotting, IO, cache, and Monte Carlo helpers in `+ProjectName_utils/`.

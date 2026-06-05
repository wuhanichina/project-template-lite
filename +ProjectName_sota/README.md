# +ProjectName_sota

Put reusable comparison-method and baseline implementations here.

Organize comparison code into semantic subpackages, usually one subpackage per
algorithm family, baseline, or reproduced external method. Subpackage and file
names should identify the method or workflow step, for example
`+dcopf_baseline/`, `+saa_monte_carlo/`, `+linearized_power_flow/`, or
`solve_reference_baseline.m`.

Keep fairness controls, shared metrics, and data loading aligned with the
proposed-method case entries before using a comparison result as paper evidence.

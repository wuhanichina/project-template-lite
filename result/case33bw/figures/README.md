# result/case33bw/figures

Case-specific folder for formal case33bw figures.

Use `ProjectName_utils.plotting.save_figure(fig, caseConfig.figureDir, figName, ...)`.
Each formal figure should include complete metadata, exported plot data, a
manifest row, and a quality-check report.

Minimum metadata: scientific question, data files, field/unit/dimension
description, visual encoding, target layout, command, key parameters, and random
seed/status.

Keep original data unchanged. Diagnostic exclusions, log-axis zero handling, or
other transforms must be recorded in `figure_manifest.jsonl` and
`figure_check_report.md`.

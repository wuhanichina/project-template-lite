# result

Generated numerical evidence stays under one case folder per runnable case.

```text
result/
├── case33bw/
│   ├── summary.txt
│   ├── run_manifest.json
│   └── figures/
└── case123/
    ├── summary.txt
    ├── run_manifest.json
    └── figures/
```

Each formal case run writes `run_manifest.json` during finalization. The
manifest records the entry command, Git state, MATLAB/platform information,
solver visibility, case configuration, input files, cache snapshot, output
files, formal figure manifest paths, and evidence-registration reminder.

Formal paper figures must be written to `result/<case>/figures/` through
`ProjectName_utils.plotting.save_figure`. That helper exports the MATLAB source
figure, preview image, vector image, plot data CSV when provided, a JSONL
manifest, and a check report.

Before a figure is treated as formal evidence, its metadata must include the
scientific/engineering question, data files, field/unit/dimension description,
global visual encoding, target layout size, command, key parameters, and random
seed or `not_applicable`.

Do not alter, smooth, crop, or relabel data for visual appeal. If a diagnostic
figure excludes points or changes log-axis zero handling, the original full-data
figure should still be kept and the diagnostic choice must be declared in the
manifest and check report.

Do not use screenshots, copy/paste, Python/Matplotlib, Excel, Origin, or
MATLAB `subplot`/`tiledlayout` composites as the formal figure export path.

Do not add extra generated-output subfolders unless a specific case needs them
and the author chooses that layout.

Do not commit generated result files unless the project owner explicitly decides
that a specific artifact is curated evidence.

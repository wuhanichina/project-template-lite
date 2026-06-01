# result

Generated numerical evidence stays under one case folder per runnable case.

```text
result/
├── case33bw/
│   ├── summary.txt
│   └── figures/
└── case123/
    ├── summary.txt
    └── figures/
```

Formal paper figures must be written to `result/<case>/figures/` through
`ProjectName_utils.plotting.save_figure`. That helper exports the MATLAB source
figure, preview image, vector image, plot data CSV when provided, a JSONL
manifest, and a check report.

Do not add extra generated-output subfolders unless a specific case needs them
and the author chooses that layout.

Do not commit generated result files unless the project owner explicitly decides
that a specific artifact is curated evidence.

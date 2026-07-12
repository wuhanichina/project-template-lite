# AGENTS.md

## Project Rules

Before editing code, documentation, comments, generated prose, or template
structure in this repository, read and follow:

- `.cursor/rules/00-lightweight-research-coding.mdc`
- `.cursor/rules/01-matlab-code-style.mdc`
- `.cursor/rules/02-local-optimizer-first.mdc`
- `.cursor/rules/03-public-note-and-paper-skill-bridge.mdc`
- `.cursor/rules/04-case-figure-and-metric-plan.mdc`
- `.cursor/rules/lexicon.md`

Treat these files as repository policy for Codex, Gemini CLI, Antigravity, and
other coding-agent work in this template. Antigravity compatibility is routed
through `GEMINI.md`.

For PowerLit writing/review handoff, also read
`contracts/project-template-handoff.schema.yaml` and the active
`02_PAPER/config/paper-profile.yaml` (or its example). Keep reasoning policy in
the Skill and persistent state, MATLAB execution, manifests, and audit artifacts
in this template.

## Sync Policy

Commit and push `.cursor/`, `AGENTS.md`, `GEMINI.md`, and `CLAUDE.md` changes
together with template changes. Do not treat agent rule files as editor-only
local state.

## Validation

After template code, rules, or documentation changes, run:

```text
matlab -batch "addpath(fullfile(pwd,'tests')); run_template_smoke_tests"
```

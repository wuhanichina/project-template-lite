# GEMINI.md

## Project Rules

This file is the compatibility entry for Gemini CLI and Google Antigravity
contexts that read `GEMINI.md` at the workspace root. Antigravity should use
this file to load the shared `.cursor/` policy and handoff contract; this
template does not maintain separate `.agents/`, `.agent/`, `.codex/`, or
root-level `contracts/` directories.

Before editing code, documentation, comments, generated prose, or template
structure in this repository, read and follow:

- `AGENTS.md`
- `.cursor/rules/00-lightweight-research-coding.mdc`
- `.cursor/rules/01-matlab-code-style.mdc`
- `.cursor/rules/02-local-optimizer-first.mdc`
- `.cursor/rules/03-public-note-and-paper-skill-bridge.mdc`
- `.cursor/rules/04-case-figure-and-metric-plan.mdc`
- `.cursor/rules/lexicon.md`

Treat `AGENTS.md` and `.cursor/` as the shared source of truth. Keep this
file short so Antigravity, Gemini, Codex, and Claude entrypoints do not drift.

## Sync Policy

Commit and push `.cursor/`, `AGENTS.md`, `GEMINI.md`, and `CLAUDE.md` changes
together with template changes. Do not treat agent rule files as editor-only
local state. Do not recreate `.agents/` or `.agent/` unless the project owner
explicitly reintroduces those Antigravity paths. Keep AI contracts under
`.cursor/contracts/`, not in a root-level `contracts/` directory.

## Validation

After template code, rules, or documentation changes, run:

```text
matlab -batch "addpath(fullfile(pwd,'tests')); run_template_smoke_tests"
```

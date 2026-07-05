# Writing Lexicon

This rule file defines wording checks for AI-generated research notes,
manuscript drafts, README text, code comments, review responses, and figure
captions in this template.

## Preferred Style

- State the technical conclusion directly.
- Write innovation points as positive statements about the minimum identifiable
  research object, concrete engineering object, physical mechanism,
  mathematical model, engineering setting, measurable result, and evidence
  source.
- Use complete declarative sentences.
- Start with the system object, model term, constraint, data source, metric, or
  numerical result.
- Name the mechanism, affected object, case set, metric, and evidence state.
- In Chinese power-system prose, name the physical object first: bus, branch,
  feeder, source/load process, operating scenario, voltage, power flow, current,
  constraint, probability distribution, violation event, or recovery action.
- Use plain technical verbs such as compute, estimate, solve, bound, compare,
  validate, export, register, update, and test.
- Attach an intensifier to a number, tolerance, scale, or explicit evidence
  source.

## Rewrite Checks

Before releasing AI-generated text, scan for these patterns:

- The technical statement is missing the minimum identifiable research object,
  model relation, measurable result, or evidence source. Add those elements
  directly.
- Human-facing notes, story files, and manuscript prose should organize
  innovation points as minimum identifiable research object, model, result,
  engineering setting, evidence source, and next experiment.
- Negative buildup and fragmentary emphasis. Replace them with one complete
  sentence.
- Rhetorical question setup. Replace it with the technical condition or result.
- Prompting phrases that introduce an explanation. Start with the object or
  formulation.
- Meta commentary about the section, future explanation, or authorial process.
- Business jargon and promotional verbs.
- Over-mathematized or programming-shaped carriers. If the reader-facing point
  is about a power-system object, rewrite the sentence around the physical
  object and its equation, constraint, state, or metric.
- Vague consequence statements. Name the concrete implication.
- Scope-free extreme terms. State the case set, time window, model class, solver,
  dataset, or assumption range.
- Reader-facing over-mathematized or code-like labels. Keep terms such as
  operator, certificate, differentiable, nullspace, paradigm, and estimator only
  when the paragraph defines or uses that exact mathematical object; otherwise
  rewrite them as power-system quantities, equations, feasibility checks,
  information carried by measurements, calculation procedures, or model
  parameters.
- Em dashes. Use commas or periods.
- Empty intensifiers. Delete them or attach a number.

## Avoid Terms

Use these tokens only when quoting source material or documenting a writing rule:

- navigate
- unpack
- landscape
- deep dive
- game-changer
- at its core
- it is worth noting
- it turns out
- as we will see
- in this section
- when it comes to
- think about it
- here is what I mean
- significant
- structural
- fundamentally
- inherently
- simply
- really
- every
- always
- never
- all
- 算子
- 证书
- 可微
- 零空间
- 范式
- 估计器

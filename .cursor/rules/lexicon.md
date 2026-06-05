# Writing Lexicon

This rule file defines wording checks for AI-generated research notes,
manuscript drafts, README text, code comments, review responses, and figure
captions in this template.

## Preferred Style

- State the technical claim directly.
- Use complete declarative sentences.
- Start with the system object, model term, constraint, data source, metric, or
  numerical result.
- Name the mechanism, affected object, case scope, metric, and evidence state.
- Use plain technical verbs such as compute, estimate, solve, bound, compare,
  validate, export, register, update, and test.
- Attach an intensifier to a number, tolerance, scale, or explicit evidence
  source.

## Rewrite Checks

Before releasing AI-generated text, scan for these patterns:

- Binary negative contrast. Replace it with the positive technical statement.
- Negative buildup and fragmentary emphasis. Replace them with one complete
  sentence.
- Rhetorical question setup. Replace it with the technical condition or result.
- Prompting phrases that introduce an explanation. Start with the object or
  formulation.
- Meta commentary about the section, future explanation, or authorial process.
- Business jargon and promotional verbs.
- Vague consequence statements. Name the concrete implication.
- Scope-free extreme terms. State the case set, time window, model class, solver,
  dataset, or assumption range.
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

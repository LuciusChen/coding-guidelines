## Core Principles

- **Question every abstraction**: Before adding a layer, file, or indirection, ask whether it solves a current problem. If the answer is hypothetical, do not add it. A refactor should remove duplication, centralize a rule, or make callers simpler; wrappers around a single use site rarely pay for themselves.
- **Refactor for net value**: A refactor must produce a concrete improvement in architecture, implementation simplicity, code size, robustness, extensibility, or test value. Moving code, renaming layers, or adding wrappers without making the system easier to understand or maintain is not enough.
- **Root out helper stacking**: A pile of small helpers, one-use wrappers, accessors, and pass-through functions is structural debt, not just naming noise. When you find it, identify the missing owner or duplicated rule and remove the stack at that level: inline trivial one-use helpers, collapse wrapper ladders into one direct path, or extract a coherent workflow module that owns the state, commands, and formatting together.
- **Simplify relentlessly**: Three similar lines are better than a premature abstraction. A single large file is better than several tiny files with unclear boundaries.
- **Reduce code by improving the model**: Prefer slimming through simpler state, data flow, control flow, and ownership. Do not treat deduplication or file extraction as the primary route to code-size reduction.
- **Fewer files, clearer boundaries**: Split only when a file has a genuinely distinct responsibility. Never split for cosmetic reasons.
- **Delete, don't deprecate**: Remove unused code entirely. No backward-compatibility shims, re-exports, or "removed" comments.
- **Prefer boring code**: A straightforward conditional chain is easier to debug than a clever polymorphic dispatch hierarchy.
- **Converge UX**: Prefer one clear entry point and one consistent behavior model over overlapping commands or branchy mode-specific behavior.

## Diagnosis and Change Discipline

- **Find the root cause before changing behavior**: Do not patch timing, caching, or control flow until you can name the failing layer and explain why it is responsible.
- **One failed fix narrows the hypothesis**: If the first attempted fix does not hold, reduce the hypothesis space and gather evidence. Do not stack another speculative patch on top.
- **Two failed fixes stop the patching loop**: After two failed fixes on the same issue, stop changing behavior and switch to diagnosis only.
- **Fix the right layer**: Move the fix to the layer that actually owns the problem instead of compensating elsewhere.
- **Stabilize workflow changes before coding**: For changes to a primary entry point, default action, or action menu, write down the intended resolution path and default behavior before implementation.
- **Keep experiments narrow**: Start new directions with the smallest slice that proves the approach is worth having. Do not expand scope before the first slice shows real value.
- **Audit the whole surface for broad refactors**: For project-wide cleanup, review the affected modules, tests, documentation, and relevant sibling repositories or integration points before choosing changes. Do not optimize one visible subsystem and call the architecture done.
- **Record wrong-layer compensation as design debt**: When touching code, look for silent fallbacks, timing hacks, duplicate lookups, swallowed internal errors, or other code that compensates for a problem owned elsewhere. Do not let that discovery expand the current change; record the debt in the project's decision or postmortem log when it matters.

## Module Boundary Discipline

- **Split by stable responsibilities**: Extract modules around durable workflows, state ownership, external boundaries, or lifecycle boundaries. Do not split by vague labels like `common`, `utils`, or `helpers`.
- **Move whole responsibilities, not leftovers**: A useful extraction takes the state, operations, validation, and formatting/rendering helpers that belong to one responsibility. If the original module still owns the behavior and the new file only adds glue, the split is not done.
- **Stop before glue takes over**: If a proposed extraction mostly adds cross-file declarations, pass-through wrappers, and navigation overhead without clearer ownership, keep the code together.
- **Do not patch boundaries with declarations**: Imports, forward declarations, adapter interfaces, or protocol stubs should make real ownership explicit. If a new declaration mainly lets a lower-level module call upward, or lets code reach into a dependency's internals, move the interface to the owner instead.
- **Do not call dependency internals**: Treat another package's private or internal API as out of bounds. If a dependency does not expose the needed behavior, add or request a public API and depend on the version that provides it.
- **Modularize incrementally**: Move the smallest coherent slice first, then compile and run focused tests before attempting the next extraction.

## Error Handling and Testing Discipline

- **Errors must surface, not hide**: Do not add fallback/default returns that silently swallow failures. Let errors propagate immediately.
- **Catch at the boundary, nowhere else**: Only the outermost API layer (process loop, top-level command handler) should catch and convert exceptions to error responses. Business logic must not catch around internal calls.
- **Robustness is not defensive programming**: Prefer clear ownership, fewer states and branches, explicit error boundaries, and verifiable invariants over broad fallback paths or compatibility scaffolding.
- **Tests must fail when the code is wrong**: If deleting or breaking the function under test does not turn the test red, the test is worthless. Assert specific, distinguishable output values.
- **Test the real dispatch path for dispatch bugs**: When a bug is in completion, hooks, command routing, async callbacks, or another dispatcher, include a test that drives the installed or public entry path. Helper-level tests are fine, but they must use the same filtering and input shape as the real caller; do not assert only against an unfiltered candidate collection unless the test is explicitly about candidate construction.
- **Match test weight to change size**: Use the smallest test that proves the intended behavior. Do not turn documentation edits or message-only changes into heavy red/green exercises.
- **Treat tests as part of the architecture budget**: Keep tests that prove public workflows, real invariants, and meaningful edge cases. Remove or simplify tests that only lock in implementation details, duplicate another assertion, or cannot fail when product behavior is wrong.
- **No hard-coded expectations**: Use diverse inputs — multiple data sets, random values, boundary cases — so that a hard-coded return cannot satisfy all assertions.
- **Red before green for real bug fixes**: When fixing a user-visible bug, correctness issue, regression, or timing-sensitive behavior, first write a failing test that reproduces it. Confirm it fails, then fix the code. If an existing test already proves the path and the change only updates a small expectation, updating that test is enough.

## Structured Rewrite Discipline

- Do not transform structured languages or protocols by brittle raw string insertion when syntax boundaries matter.
- Prefer parser-backed, token-aware, or top-level-clause-aware transformations with safe fallback behavior.
- For complex constructs, prioritize semantic correctness over aggressive rewriting. Do not force a full parser or AST framework into a small fix unless the change truly needs it.

## Function and Method Design

- Keep functions under ~30 lines. Extract a helper when a function exceeds this.
- Name helpers after what they compute, not where they are called from.
- Separate pure computation from side effects (I/O, display mutation, state changes).
- Interactive entry points should be thin wrappers: validate input, call internal function, show feedback.

## Workflow Consistency

- Use one vocabulary for the same workflow across UI labels, help text, errors, tests, and documentation.
- A preview command must show the payload or state that would actually be executed, saved, sent, or applied.
- Validate before destroying user context. When local validation fails, keep the user where they can correct the problem.
- UI symmetry must follow domain semantics. Do not copy controls, metadata, or layout between nearby workflows unless the underlying operation really matches.

## Documentation Discipline

- **User-visible changes must update docs in the same commit**: any change to key bindings, defaults, configuration, or user-facing workflow must update the project's user documentation (README, PRD, etc.) in the same change.
- **Code is source of truth**: if code and docs diverge, fix docs immediately.
- **Optimize docs for rendered reading, not source-width aesthetics**: do not rewrap unchanged Markdown, Org, or similar prose just to fit a column. Rendered documents already wrap naturally.
- **Fix structure before line breaks**: when documentation feels hard to read, use a clearer heading, table, shorter bullets, or focused rewrite. Avoid changes whose only effect is different source line breaks.

## Version Baseline Discipline

- Keep runtime, language, and dependency baselines explicit.
- Do not silently raise a baseline. If a change requires a newer runtime, compiler, language version, or dependency version, update build metadata, release metadata, user documentation, and the decision record that explains why.
- When in doubt, verify when an API was introduced before using it.

## Release Artifact Discipline

- Treat published artifacts as content-addressed even when the hosting platform allows replacement. If the bytes change, update checksums and install metadata immediately.
- Prefer a new version for changed released content. Replacing an existing artifact in place should be an exceptional repair path, not normal workflow.
- Any release-asset change that affects installation, startup, compatibility, or user workflow must update user documentation and, when the tradeoff is non-obvious, the decision record.

## Pre-Commit Discipline

- **Read the full diff** before committing. Every changed line.
- **Compile clean**: zero warnings from the project's compiler or linter.
- **Run all tests**: the full suite must pass, not just the tests you think are related.
- **Scan for boundary violations**: when the project has private naming conventions or forbidden dependency internals, run a targeted search before committing and remove accidental private API usage.
- **Update tests when behavior changes**: search all test files for existing tests of the changed function and update them in the same commit. Add a new failing test only when the current suite does not already prove the regression or changed behavior.
- **No heuristic shortcuts**: if a fix feels "good enough for now", document why the rest is deferred. Do not leave silent partial implementations.
- **No redundancy**: remove duplicated logic or dead code introduced by the change.

## Postmortem Conventions

The `postmortem/` directory records design decisions and lessons learned. **Read relevant records before significant changes.**

Write a postmortem when:
- Adding or changing a user-visible workflow
- Choosing between non-obvious architectural approaches
- Integrating an optional dependency or external system
- Reverting or abandoning an approach — especially document *why* it was wrong
- Deliberately deferring a known limitation

Postmortems are historical records, not current product documentation. Do not rewrite old records just to match current behavior; write a new record for the later design and optionally add a short superseded note to the old one.

Postmortems must explain **why**, not restate the code. A record that only describes what was done adds no value.

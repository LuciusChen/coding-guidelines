## Core Principles

- **Question every abstraction**: Before adding a layer, file, or indirection, ask whether it solves a current problem. If the answer is hypothetical, do not add it.
- **Simplify relentlessly**: Three similar lines are better than a premature abstraction. A single large file is better than several tiny files with unclear boundaries.
- **Fewer files, clearer boundaries**: Split only when a file has a genuinely distinct responsibility. Never split for cosmetic reasons.
- **Delete, don't deprecate**: Remove unused code entirely. No backward-compatibility shims, re-exports, or "removed" comments.
- **Prefer boring code**: A straightforward conditional chain is easier to debug than a clever polymorphic dispatch hierarchy.

## Diagnosis and Change Discipline

- **Find the root cause before changing behavior**: Do not patch timing, caching, or control flow until you can name the failing layer and explain why it is responsible.
- **One failed fix narrows the hypothesis**: If the first attempted fix does not hold, reduce the hypothesis space and gather evidence. Do not stack another speculative patch on top.
- **Two failed fixes stop the patching loop**: After two failed fixes on the same issue, stop changing behavior and switch to diagnosis only.
- **Fix the right layer**: Move the fix to the layer that actually owns the problem instead of compensating elsewhere.
- **Keep experiments narrow**: Start new directions with the smallest slice that proves the approach is worth having. Do not expand scope before the first slice shows real value.

## Error Handling and Testing Discipline

- **Errors must surface, not hide**: Do not add fallback/default returns that silently swallow failures. Let errors propagate immediately.
- **Catch at the boundary, nowhere else**: Only the outermost API layer (process loop, top-level command handler) should catch and convert exceptions to error responses. Business logic must not catch around internal calls.
- **Tests must fail when the code is wrong**: If deleting or breaking the function under test does not turn the test red, the test is worthless. Assert specific, distinguishable output values.
- **No hard-coded expectations**: Use diverse inputs — multiple data sets, random values, boundary cases — so that a hard-coded return cannot satisfy all assertions.
- **Red before green**: When fixing a bug, first write a failing test that reproduces it. Confirm it fails. Then fix the code. A test written after the fix has never been proven to catch the bug.

## Function and Method Design

- Keep functions under ~30 lines. Extract a helper when a function exceeds this.
- Name helpers after what they compute, not where they are called from.
- Separate pure computation from side effects (I/O, display mutation, state changes).
- Interactive entry points should be thin wrappers: validate input, call internal function, show feedback.

## Pre-Commit Discipline

- **Read the full diff** before committing. Every changed line.
- **Compile clean**: zero warnings from the project's compiler or linter.
- **Run all tests**: the full suite must pass, not just the tests you think are related.
- **Update tests when behavior changes**: search all test files for existing tests of the changed function and update them in the same commit.
- **No heuristic shortcuts**: if a fix feels "good enough for now", document why the rest is deferred. Do not leave silent partial implementations.
- **No redundancy**: remove duplicated logic or dead code introduced by the change.

## Postmortem Conventions

The `postmortem/` directory records design decisions and lessons learned. **Read relevant records before significant changes.**

Write a postmortem when:
- Adding or changing a user-visible workflow
- Choosing between non-obvious architectural approaches
- Reverting or abandoning an approach — especially document *why* it was wrong
- Deliberately deferring a known limitation

Postmortems must explain **why**, not restate the code. A record that only describes what was done adds no value.

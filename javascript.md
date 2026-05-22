## JavaScript Best Practices

### Tooling and Runtime Baseline

- Use a formatter and linter for formatting and mechanical safety rules. Do not spend code review time on whitespace, quote style, import ordering, or other auto-fixable choices.
- Declare the runtime targets the project supports: browser versions, Node version, module format, and available Web APIs. Do not introduce newer syntax or APIs without a build step, polyfill, or documented baseline change.
- Prefer standard ECMAScript modules in new code. Mix CommonJS, dynamic imports, or globals only at explicit compatibility boundaries.
- Keep generated files, build output, and vendored code out of hand-written style requirements unless the project explicitly owns them.

### Names and Modules

- Use `camelCase` for variables and functions, `PascalCase` for classes and constructor-like values, and `UPPER_SNAKE_CASE` only for module-level constants whose value is fixed and primitive-like.
- Name functions after what they return or cause, not after the framework event that happens to call them.
- Prefer named exports for project-owned modules so import sites use consistent names. Use default exports only when a framework, external convention, or interop boundary makes that clearer.
- Export only the behavior intended for other modules. Keep module-local helpers private by default.
- Avoid circular dependencies. If two modules need each other, extract the shared rule or data shape into a third owner rather than relying on import timing.
- Make side-effect imports rare and explicit. A module imported only for registration or initialization should be named and documented as such.

### Variables and Data

- Use `const` by default, `let` for reassignment, and no `var`.
- Prefer object and array literals over constructors for ordinary values.
- Prefer spread/rest, destructuring, and small mapping functions when they make data movement explicit. Avoid clever transformations that hide validation or mutation.
- Treat object and array mutation as local by default. When mutation crosses a module boundary, make ownership obvious through the API name or return value.
- Use `??` and `?.` when `0`, `false`, or `""` are valid values. Do not use `||` as a defaulting operator unless all falsy values are invalid.
- Avoid relying on implicit coercion. Convert at the boundary with `Number`, `String`, `Boolean`, parsing functions, or explicit predicates.

### Functions and Control Flow

- Keep functions focused and shallow. Prefer early returns for invalid or completed cases over nested conditional blocks.
- Separate pure computation from I/O, DOM mutation, network calls, storage, timers, and logging.
- Prefer direct conditionals or table-driven dispatch over inheritance-like object graphs for simple branching.
- Do not use a class when a function plus plain data is enough. Use classes for stable stateful abstractions with invariants, not as a default file shape.
- Avoid callback APIs in new code when promises or `async` functions are available. When adapting callbacks, isolate the adapter.

### Async and Errors

- Await or return every promise. Floating promises must be deliberate and locally documented.
- Catch errors at process, request, job, or UI action boundaries. Do not catch in business logic just to return a plausible default.
- Preserve the original error when adding context. Use `cause` or equivalent wrapping instead of replacing the failure with a vague message.
- Use timeouts, cancellation, or `AbortSignal` for network and long-running operations when the caller can abandon the work.
- Do not mix success values and error values in the same return shape unless the API consistently uses a result object.

### Boundaries and Inputs

- Treat data from JSON, forms, URLs, storage, environment variables, and external APIs as untrusted. Parse and validate it before using it as application state.
- Keep DOM lookup and event wiring at the edge. Core behavior should accept ordinary values and return ordinary values so it can be tested without a browser.
- Avoid storing application truth only in the DOM. The DOM is a rendering target, not a reliable state model.

### Testing

- Test public module APIs and real event or dispatch paths for behavior bugs. Helper-level tests should mirror the same input shape as production callers.
- Inject clocks, randomness, network clients, and storage handles when behavior depends on them.
- Assert outcomes that distinguish the intended behavior from a hard-coded implementation.

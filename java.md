## Java Best Practices

### Source Files and Tooling

- Use the project's formatter and static analysis tools for formatting, imports, nullness, and bug-prone patterns. Do not settle style arguments manually when a tool can enforce them.
- Keep source files UTF-8 and line endings consistent with the project.
- Use one public top-level type per file. Keep nested types only when they are tightly owned by the enclosing type.
- Avoid wildcard imports, including static wildcard imports, unless the project explicitly allows them for a narrow test assertion style.
- Remove unused imports, dead private members, and obsolete comments in the same change that makes them unused.

### Naming

- **Classes**: `PascalCase`. Name after what they *are*, not what they *do* (`CursorManager`, not `CursorManagementService`).
- **Methods**: `camelCase`. Name after what they *return or produce* (`getSchemas`, `fetch`), not implementation details.
- **Private fields**: `camelCase`, no Hungarian prefix.
- **Constants**: `UPPER_SNAKE_CASE`.
- **Visibility**: prefer package-private over `public` when a class is not part of an external API.
- **Packages**: lowercase, stable, and aligned with ownership. Do not move public types between packages without treating it as an API change.

### Types and API Shape

- Make public APIs small and intentional. Start with package-private classes and methods until another package genuinely needs them.
- Prefer immutable value objects for data that crosses threads, layers, or API boundaries.
- Use `record` for transparent data carriers whose identity is their fields. Do not add lifecycle or resource ownership behavior to a record.
- Use enums for closed sets of named values. Avoid stringly typed mode flags when Java can model the set directly.
- Return `Optional<T>` for possibly absent results when absence is expected. Do not use `Optional` for fields, parameters, or collection elements unless the project has a strong convention for it.
- Defensively copy mutable inputs and outputs at API boundaries, or document that ownership transfers.

### Control Flow

- Prefer flat, linear control flow. Extract a helper method rather than adding another indent level.
- Use `switch ->` expressions, records, and `instanceof` pattern matching where they improve clarity.
- Prefer guard clauses for invalid or completed cases.
- Avoid returning `null` from new APIs. If a legacy API can return `null`, normalize it at the boundary.
- Keep streams readable. A clear loop is better than a pipeline with hidden side effects, complex collectors, or difficult exception handling.

### Error Handling

- **Resource cleanup**: always use try-with-resources for `ResultSet`, `Statement`, `Connection` and similar `AutoCloseable` resources when the scope is local. For long-lived resources, ensure `close()` is called in `finally` or on shutdown.
- Error messages should state what is wrong specifically: `"Unknown connection id: 5"`, not `"Connection operation failed"`.
- Do not expose stack traces to external consumers. Return structured error information.
- Catch the narrowest exception type that the code can actually handle. Do not catch `Exception` or `Throwable` to continue with a default value.
- Preserve causes when wrapping exceptions.
- Do not swallow interrupts. Restore the interrupt flag with `Thread.currentThread().interrupt()` or propagate the interruption.
- Use checked exceptions for recoverable API-level failures only when callers can make a meaningful recovery decision.

### Logging and Output

- Never use `System.out.println` for logging. Reserve stdout for protocol/structured output only.
- All diagnostic logging goes to `System.err` or a proper logging framework.
- Log at the boundary that owns the operation. Do not log and rethrow the same failure at every layer.
- Include stable context such as ids, operation names, and remote endpoints. Do not log secrets, credentials, tokens, or full payloads by default.

### Concurrency and Resources

- Make ownership of threads, executors, timers, sockets, files, and database connections explicit.
- Shut down executors and close long-lived resources through a lifecycle owner.
- Prefer timeouts for blocking calls that cross process, network, or database boundaries.
- Keep synchronized regions small and do not call external code while holding a lock.
- Prefer immutable messages and thread-safe queues over shared mutable state.

### Version Baseline Discipline

- Do not silently introduce APIs or syntax from a newer JDK than the project baseline.
- If a change requires raising the baseline, document the reason first, then update build config and documentation together.

### Quality Checks

- Build must produce zero warnings.
- All `public` methods and classes must have Javadoc.
- Tests should cover public behavior, boundary failures, and resource cleanup paths.

## Java Best Practices

### Naming

- **Classes**: `PascalCase`. Name after what they *are*, not what they *do* (`CursorManager`, not `CursorManagementService`).
- **Methods**: `camelCase`. Name after what they *return or produce* (`getSchemas`, `fetch`), not implementation details.
- **Private fields**: `camelCase`, no Hungarian prefix.
- **Constants**: `UPPER_SNAKE_CASE`.
- **Visibility**: prefer package-private over `public` when a class is not part of an external API.

### Control Flow

- Prefer flat, linear control flow. Extract a helper method rather than adding another indent level.
- Use `switch ->` expressions, records, and `instanceof` pattern matching where they improve clarity.
- Use `record` for simple data carriers. Do not add behavior to records beyond accessor methods.

### Error Handling

- **Resource cleanup**: always use try-with-resources for `ResultSet`, `Statement`, `Connection` and similar `AutoCloseable` resources when the scope is local. For long-lived resources, ensure `close()` is called in `finally` or on shutdown.
- Error messages should state what is wrong specifically: `"Unknown connection id: 5"`, not `"Connection operation failed"`.
- Do not expose stack traces to external consumers. Return structured error information.

### Logging and Output

- Never use `System.out.println` for logging. Reserve stdout for protocol/structured output only.
- All diagnostic logging goes to `System.err` or a proper logging framework.

### Version Baseline Discipline

- Do not silently introduce APIs or syntax from a newer JDK than the project baseline.
- If a change requires raising the baseline, document the reason first, then update build config and documentation together.

### Quality Checks

- Build must produce zero warnings.
- All `public` methods and classes must have Javadoc.

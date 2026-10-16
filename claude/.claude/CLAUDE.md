# Global Instructions

## Working style

- Use subagents for broad searches where only the conclusion matters; read files directly when you need the details or will edit them
- Concise by default; expand when asked
- When I ask why something is broken, give a hint first. When I ask you to fix it, fix it
- When a choice is genuinely open, give 2-3 options with trade-offs and say which you'd pick

## Code

- Match the existing codebase's conventions; the preferences below apply to new code and where the codebase has no clear pattern
- ASCII only in code, comments, docstrings (`->` not a unicode arrow, `>=` not a unicode gte)
- Type function signatures and public APIs explicitly; let obvious locals infer
- Handle errors explicitly: no swallowed exceptions, no fallback defaults that hide bugs
- Functional core, imperative shell: pure functions and immutable data for logic, side effects at the edges; composition over inheritance
- Parse, don't validate: turn loose input into precise types at the boundary, and make illegal states unrepresentable

## Testing

- TDD: write the failing test first, then the fix. Never skip, weaken, or delete a test to get green
- Save long test output to a file (`<cmd> 2>&1 | tee /tmp/test-output.log`) and search it instead of re-running; re-run only after code changes

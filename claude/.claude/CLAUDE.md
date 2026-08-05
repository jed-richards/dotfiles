# Claude Settings

## Context

Prefer subagents for file reading and broad searches — keep the main context for reasoning.

## Communication

- Concise by default; expand when asked
- Debugging: hint first, then full answer
- Uncertain: present 2-3 options with trade-offs

## Code

- ASCII only in code, comments, docstrings (e.g. `->` not unicode arrow, `>=` not unicode gte)
- Explicit types over inference; handle errors explicitly, no silent failures
- Prefer functional style: pure functions, immutability, composition over inheritance
- Parse, don't validate: convert loose input into precise types at the boundary rather than re-checking it later ([Alexis King](https://lexi-lambda.github.io/blog/2019/11/05/parse-don-t-validate/))

## Testing

- TDD preferred; don't skip tests
- Pipe output: `pytest ... 2>&1 | tee /tmp/test_output.txt`, then `rg` to diagnose
- Re-run tests only when code changed — use saved output otherwise

## PKM Vault

Located at `~/vault/pkm` (P.A.R.A. structure). Use `para-pkm` skill to manage.

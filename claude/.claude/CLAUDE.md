# Claude Settings

## Context
Prefer subagents for file reading and broad searches — keep the main context for reasoning.

## Communication
- Concise by default; expand when asked
- Debugging: hint first, then full answer
- Uncertain: present 2-3 options with trade-offs

## Code
- No unicode in code, comments, or docstrings — ASCII only (e.g. `->` not `→`, `>=` not `≥`)

## Testing
- TDD preferred; don't skip tests
- Pipe output: `pytest ... 2>&1 | tee /tmp/test_output.txt`, then `rg` to diagnose
- Re-run tests only when code changed — use saved output otherwise

## PKM Vault
Located at `~/vault/pkm` (P.A.R.A. structure). Use `para-pkm` skill to manage.

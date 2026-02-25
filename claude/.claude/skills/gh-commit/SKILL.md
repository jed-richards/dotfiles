---
name: gh-commit
description: Use when committing code changes, staging files, or writing commit messages. Use when the user says "commit", "save changes", or after completing implementation work.
---

# Committing Changes

## Overview

Every commit should be atomic (one logical change), properly staged (explicit file selection), and well-described (conventional commit format).

## Before Committing

1. **Read the diff** - Run `git diff` and `git diff --staged` to understand ALL changes
2. **Identify logical units** - Group related changes; split unrelated ones into separate commits

## Staging Rules

**NEVER use `git add -A` or `git add .`** - Always stage files explicitly by name.

```bash
# WRONG
git add .
git add -A

# RIGHT
git add src/auth/refresh.ts src/auth/middleware.ts
```

**Never stage:**

- `.env*` files
- Lock files (`package-lock.json`, `Cargo.lock`, etc.)
- Generated files (`logs/`, `dist/`, `target/`, `node_modules/`)
- Temporary/scratch files

If unsure whether a file should be committed, ask.

## Atomic Commits

One commit = one logical change. If you changed unrelated things, make separate commits.

```bash
# WRONG: Monolithic commit mixing concerns
git add README.md src/auth/refresh.ts .github/workflows/ci.yml
git commit -m "feat: add JWT refresh, fix typo, update CI"

# RIGHT: Three separate commits
git add README.md
git commit -m "docs: fix authentication typo in README"

git add src/auth/refresh.ts src/auth/middleware.ts
git commit -m "feat(auth): add JWT token refresh logic"

git add .github/workflows/ci.yml
git commit -m "ci: add integration test step to pipeline"
```

**How to split:** If you can't describe the commit without "and", it should be multiple commits.

## Conventional Commit Messages

Format: `type(scope): description`

| Type       | When                                                     |
| ---------- | -------------------------------------------------------- |
| `feat`     | New functionality                                        |
| `fix`      | Bug fix                                                  |
| `docs`     | Documentation only                                       |
| `refactor` | Code change that doesn't fix a bug or add a feature      |
| `test`     | Adding or fixing tests                                   |
| `chore`    | Build, CI, tooling                                       |
| `deps`     | Dependency updates (e.g., `deps(axios): 1.6.0 -> 1.7.2`) |
| `perf`     | Performance improvement                                  |

### Message Quality

The subject line explains **what** changed. The body (if needed) explains **why**.

```bash
# WRONG: Vague, padding with meaningless bullets
git commit -m "refactor: update services

- Update user service
- Enhance logging
- Improve database config"

# RIGHT: Specific, explains the why
git commit -m "fix(auth): validate email uniqueness on registration

Concurrent registration requests could create duplicate users.
Adds UniqueValidator to UserSerializer email field.

Closes #42"
```

**Red flags for bad messages:**

- "Update files" / "Fix bug" / "Make changes"
- Bullet points that just restate filenames
- Description that could apply to any commit

Reference issues when relevant with `Closes #N`, `Fixes #N`, or `Refs #N`.

## Quick Reference

| Step                 | Command                                    |
| -------------------- | ------------------------------------------ |
| See what changed     | `git diff`                                 |
| See staged changes   | `git diff --staged`                        |
| Stage specific files | `git add <file1> <file2>`                  |
| Commit with message  | `git commit -m "type(scope): description"` |

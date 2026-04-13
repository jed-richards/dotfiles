---
name: review-pr
description: >
  Use when the user wants to look at, address, or resolve PR review comments.
  Trigger on phrases like "look at PR comments", "resolve review comments",
  "address feedback", "what comments need fixing", "let's work through the PR",
  or any time the user wants to act on GitHub pull request review feedback for
  the current branch. Guides the full loop: fetch all comment types, triage,
  fix with TDD, commit, push, and reply to threads with the resolving commit hash.
---

# PR Review Workflow

A full end-to-end loop for fetching, triaging, fixing, and closing out PR review
comments. Work through the phases in order; each phase has a clear exit condition.

---

## Phase 1 — Fetch

Get the PR number for the current branch, then run the bundled script:

```bash
PR=$(gh pr list --head $(git branch --show-current) --json number -q '.[0].number')
python ~/.claude/skills/review-pr/scripts/pr_comments.py fetch $PR
```

The script fetches all three comment layers (inline review comments, review summaries,
and issue-level comments), wires reply threads, auto-classifies severity, and prints
a triage report. `gh pr view --comments` only shows review summaries and misses inline
thread comments — always use the script instead.

---

## Phase 2 — Triage

Classify every comment into one of four buckets:

| Bucket | Definition | Action |
|--------|-----------|--------|
| **Already resolved** | Thread has a reply from you acknowledging the fix | Skip |
| **False alarm** | Copilot/bot flagging a missing file/import that actually exists post-rebase, or a concern you've already addressed in-thread | Skip (or reply to close it out) |
| **Non-blocking suggestion** | Marked `(non-blocking)` or `suggestion` — reviewer won't block merge | Your call; note it for the user |
| **Blocking / open** | Marked `(blocking)` or `issue`, or no status marker and not yet replied to | Fix it |

When unsure whether something is a false alarm, verify: check that the file/module/symbol
exists in the current tree before deciding to skip.

Present the triage result to the user before writing any code:

```
ACTIONABLE (3):
  [3074330849] asmith - service.py:132 - ext_session swallows exceptions (blocking)
  [3074330860] asmith - service.py - set iteration nondeterminism (blocking)
  [3074330870] asmith - test_service_wiring.py:1 - missing backdate test (blocking)

SKIP (2):
  [3074190082] Copilot - service.py:158 - ModuleNotFoundError (false alarm, timeline.py now exists)
  [3065438591] khendrixcsg - service.py:127 - INSERT IGNORE concern (already replied)
```

Confirm with the user before proceeding if anything is ambiguous.

---

## Phase 3 — Fix

For each actionable comment, apply the TDD workflow:

1. **Read the relevant source file** before touching anything.
2. **Write a failing test** that captures the behavior described in the comment.
   - Run it and confirm it fails for the right reason.
3. **Write the minimal implementation** to make it pass.
4. **Run the full relevant test suite** to catch regressions.

When a comment provides a suggested test body (Copilot or reviewer often does), use it
as the starting point but read it carefully — adjust variable names, fixture references,
and expected values to match the actual codebase.

Group related fixes logically. If three comments are all about the same method, fix them
together in one commit rather than three separate ones. If the fixes are independent
(e.g., one is a test addition, one is a locking change), split into separate commits.

---

## Phase 4 — Commit & Push

Stage files explicitly — never `git add .`. Write a conventional commit message that
covers all grouped fixes. Use `--no-verify` since pre-commit hooks are broken in this
repo (Python version mismatch).

```bash
git add <file1> <file2> ...
git commit --no-verify -m "type(scope): concise description

- Bullet per logical change
- Reference the reviewer's concern, not just 'address PR comments'"

git push
```

Capture the short commit hash immediately after push — you'll need it for Phase 5.

```bash
git rev-parse --short HEAD
```

---

## Phase 5 — Reply

For every comment thread you resolved, use the script to post the reply:

```bash
python ~/.claude/skills/review-pr/scripts/pr_comments.py reply \
  <pr_num> <comment_id> <commit_hash> "<one sentence description>"
```

The description should say *what* changed, not just "fixed"
(e.g., `"re-raises when ext_session is provided"`).

Reply to the **root comment** of each thread — the first comment in the thread,
not a later reply in the chain. Use the IDs from the fetch output.

---

## Tips & common pitfalls

- **Copilot false alarms**: Copilot often flags missing modules or test helpers that
  were added in a recently-merged dependency PR. Always verify existence before acting.
- **Stacked PRs**: if the branch was recently rebased, re-fetch comments — reply IDs
  don't change but line numbers in the diff may shift.
- **Already-replied threads**: check `in_reply_to_id` in the comment JSON. If a comment
  has replies from you already, skip it.
- **Non-blocking suggestions**: always present these to the user and let them decide.
  Don't silently skip or silently fix them.

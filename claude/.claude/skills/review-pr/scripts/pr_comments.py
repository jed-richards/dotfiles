#!/usr/bin/env python3
"""
pr_comments.py - Fetch, triage, and reply to GitHub PR review comments.

Usage:
    python pr_comments.py fetch <pr_num>
    python pr_comments.py reply <pr_num> <comment_id> <commit_hash> "<message>"
"""
from __future__ import annotations

import json
import subprocess
import sys
from dataclasses import dataclass, field
from typing import Optional


# ---------------------------------------------------------------------------
# GitHub API helpers
# ---------------------------------------------------------------------------

def _gh(path: str) -> list | dict:
    """Run a paginated gh api call and return parsed JSON."""
    result = subprocess.run(
        ["gh", "api", path, "--paginate"],
        capture_output=True,
        text=True,
        check=True,
    )
    return json.loads(result.stdout)


def _repo() -> str:
    """Return OWNER/REPO for the current directory."""
    result = subprocess.run(
        ["gh", "repo", "view", "--json", "nameWithOwner", "-q", ".nameWithOwner"],
        capture_output=True,
        text=True,
        check=True,
    )
    return result.stdout.strip()


# ---------------------------------------------------------------------------
# Triage logic
# ---------------------------------------------------------------------------

BLOCKING_MARKERS = ("(blocking)", "**issue", "**bug", "**error")
NON_BLOCKING_MARKERS = ("(non-blocking)", "**suggestion", "suggestion (non-blocking)")
BOT_LOGINS = ("copilot", "github-actions", "dependabot")


@dataclass
class Comment:
    id: int
    author: str
    body: str
    path: Optional[str] = None
    line: Optional[int] = None
    in_reply_to_id: Optional[int] = None
    replies: list["Comment"] = field(default_factory=list)

    @property
    def is_root(self) -> bool:
        return self.in_reply_to_id is None

    @property
    def is_bot(self) -> bool:
        return any(b in self.author.lower() for b in BOT_LOGINS)

    @property
    def severity(self) -> str:
        body_lower = self.body.lower()
        if any(m in body_lower for m in BLOCKING_MARKERS):
            return "BLOCKING"
        if any(m in body_lower for m in NON_BLOCKING_MARKERS):
            return "NON-BLOCKING"
        return "OPEN"

    def already_resolved(self, my_login: str) -> bool:
        """True if a reply from my_login contains 'Resolved by'."""
        return any(
            r.author == my_login and "resolved by" in r.body.lower()
            for r in self.replies
        )

    def snippet(self, n: int = 100) -> str:
        first_line = self.body.splitlines()[0] if self.body else ""
        return first_line[:n] + ("..." if len(first_line) > n else "")


def _my_login() -> str:
    result = subprocess.run(
        ["gh", "api", "user", "-q", ".login"],
        capture_output=True,
        text=True,
        check=True,
    )
    return result.stdout.strip()


# ---------------------------------------------------------------------------
# Fetch
# ---------------------------------------------------------------------------

def fetch(pr_num: int) -> None:
    repo = _repo()
    my_login = _my_login()

    # 1. Inline review comments
    raw_inline = _gh(f"repos/{repo}/pulls/{pr_num}/comments")
    # 2. Reviews (for overall review body)
    raw_reviews = _gh(f"repos/{repo}/pulls/{pr_num}/reviews")

    # Build comment objects
    by_id: dict[int, Comment] = {}
    roots: list[Comment] = []

    for r in raw_inline:
        c = Comment(
            id=r["id"],
            author=r["user"]["login"],
            body=r["body"],
            path=r.get("path"),
            line=r.get("line") or r.get("original_line"),
            in_reply_to_id=r.get("in_reply_to_id"),
        )
        by_id[c.id] = c

    # Wire up replies to roots
    for c in by_id.values():
        if c.in_reply_to_id and c.in_reply_to_id in by_id:
            by_id[c.in_reply_to_id].replies.append(c)
        elif c.is_root:
            roots.append(c)

    # Buckets
    actionable = []
    skip = []

    for c in roots:
        if c.already_resolved(my_login):
            skip.append((c, "already replied"))
        elif c.is_bot and c.severity == "OPEN":
            skip.append((c, "bot / verify first"))
        else:
            actionable.append(c)

    # Print triage report
    print(f"\n{'='*60}")
    print(f"  PR #{pr_num}  |  {repo}")
    print(f"{'='*60}\n")

    if actionable:
        print(f"ACTIONABLE ({len(actionable)})")
        print("-" * 60)
        for c in actionable:
            loc = f"{c.path}:{c.line}" if c.path else "(general)"
            bot_tag = " [bot]" if c.is_bot else ""
            print(f"  [{c.id}] {c.author}{bot_tag} - {loc}")
            print(f"    {c.severity}  |  {c.snippet()}")
            if c.replies:
                latest = c.replies[-1]
                print(f"    Last reply ({latest.author}): {latest.snippet(60)}")
            print()

    if skip:
        print(f"SKIP ({len(skip)})")
        print("-" * 60)
        for c, reason in skip:
            loc = f"{c.path}:{c.line}" if c.path else "(general)"
            print(f"  [{c.id}] {c.author} - {loc}  ({reason})")
            print(f"    {c.snippet()}")
            print()

    # Review summaries (non-empty bodies only)
    review_notes = [
        r for r in raw_reviews
        if r.get("body", "").strip() and r["user"]["login"] != my_login
    ]
    if review_notes:
        print(f"REVIEW SUMMARIES ({len(review_notes)})")
        print("-" * 60)
        for r in review_notes:
            print(f"  [{r['state']}] {r['user']['login']}")
            snippet = r["body"].strip()[:200]
            print(f"    {snippet}")
            print()


# ---------------------------------------------------------------------------
# Reply
# ---------------------------------------------------------------------------

def reply(pr_num: int, comment_id: int, commit_hash: str, message: str) -> None:
    repo = _repo()
    body = f"Resolved by {commit_hash} \u2014 {message}"
    result = subprocess.run(
        [
            "gh", "api",
            f"repos/{repo}/pulls/{pr_num}/comments/{comment_id}/replies",
            "--method", "POST",
            "-f", f"body={body}",
        ],
        capture_output=True,
        text=True,
        check=True,
    )
    data = json.loads(result.stdout)
    print(f"Replied (comment #{data['id']}): {body}")


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

def main() -> None:
    if len(sys.argv) < 3:
        print(__doc__)
        sys.exit(1)

    cmd = sys.argv[1]

    if cmd == "fetch":
        pr_num = int(sys.argv[2])
        fetch(pr_num)

    elif cmd == "reply":
        if len(sys.argv) < 6:
            print("Usage: pr_comments.py reply <pr_num> <comment_id> <commit_hash> <message>")
            sys.exit(1)
        pr_num = int(sys.argv[2])
        comment_id = int(sys.argv[3])
        commit_hash = sys.argv[4]
        message = sys.argv[5]
        reply(pr_num, comment_id, commit_hash, message)

    else:
        print(f"Unknown command: {cmd}")
        sys.exit(1)


if __name__ == "__main__":
    main()

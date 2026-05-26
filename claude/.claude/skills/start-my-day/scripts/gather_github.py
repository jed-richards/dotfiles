#!/usr/bin/env python3
"""
Gather GitHub PR data for the morning briefing.
Outputs structured JSON to stdout.
"""

import json
import subprocess
import sys
from datetime import datetime, timezone


def run_gh(args: list[str]) -> list[dict]:
    result = subprocess.run(
        ["gh"] + args,
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        return []
    try:
        return json.loads(result.stdout)
    except json.JSONDecodeError:
        return []


def age_days(created_at: str) -> int:
    try:
        created = datetime.fromisoformat(created_at.replace("Z", "+00:00"))
        return (datetime.now(timezone.utc) - created).days
    except Exception:
        return -1


def main() -> None:
    # PRs I authored
    authored_raw = run_gh([
        "pr", "list",
        "--author", "@me",
        "--state", "open",
        "--limit", "50",
        "--json", "number,title,url,reviewDecision,createdAt,headRepository,comments,isDraft",
    ])

    authored = []
    for pr in authored_raw:
        authored.append({
            "number": pr.get("number"),
            "title": pr.get("title"),
            "url": pr.get("url"),
            "repo": pr.get("headRepository", {}).get("nameWithOwner", ""),
            "review_decision": pr.get("reviewDecision") or "PENDING",
            "is_draft": pr.get("isDraft", False),
            "comments": pr.get("comments", 0) if isinstance(pr.get("comments"), int) else len(pr.get("comments", [])),
            "age_days": age_days(pr.get("createdAt", "")),
            "created_at": pr.get("createdAt", ""),
        })

    # PRs where my review is requested
    review_raw = run_gh([
        "search", "prs",
        "--review-requested", "@me",
        "--state", "open",
        "--limit", "50",
        "--json", "number,title,url,repository,createdAt,author",
    ])

    reviews_requested = []
    for pr in review_raw:
        reviews_requested.append({
            "number": pr.get("number"),
            "title": pr.get("title"),
            "url": pr.get("url"),
            "repo": pr.get("repository", {}).get("nameWithOwner", ""),
            "author": pr.get("author", {}).get("login", ""),
            "age_days": age_days(pr.get("createdAt", "")),
            "created_at": pr.get("createdAt", ""),
        })

    # Sort oldest first (most urgent to review)
    reviews_requested.sort(key=lambda x: x["age_days"], reverse=True)

    output = {
        "source": "github",
        "fetched_at": datetime.now(timezone.utc).isoformat(),
        "authored_prs": authored,
        "review_requested": reviews_requested,
    }

    print(json.dumps(output, indent=2))


if __name__ == "__main__":
    main()

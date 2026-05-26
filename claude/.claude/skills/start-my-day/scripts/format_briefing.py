#!/usr/bin/env python3
"""
Format morning briefing from structured JSON inputs.

Usage:
  python format_briefing.py --github github.json --jira jira.json [--calendar calendar.json]

Prints formatted markdown to stdout. Claude then:
  1. Appends the PKM journal summary and active projects it read directly
  2. Adds commentary / triage notes
  3. Files the result
"""

import argparse
import json
import sys
from datetime import datetime
from pathlib import Path


def load_json(path: str | None) -> dict:
    if not path:
        return {}
    try:
        return json.loads(Path(path).read_text())
    except Exception:
        return {}


def format_age(days: int) -> str:
    if days < 0:
        return ""
    if days == 0:
        return "today"
    if days == 1:
        return "1 day old"
    return f"{days} days old"


def stale_flag(days: int) -> str:
    return " **[STALE]**" if days >= 3 else ""


def render_github(data: dict) -> str:
    if not data:
        return "**GitHub**: unavailable\n"

    lines = ["## GitHub\n"]

    reviews = data.get("review_requested", [])
    lines.append("### Reviews Requested")
    if not reviews:
        lines.append("_No reviews requested._\n")
    else:
        for pr in reviews:
            age = pr.get("age_days", -1)
            lines.append(
                f"- [ ] [#{pr['number']} {pr['title']}]({pr['url']}) "
                f"— `{pr['repo']}` by @{pr['author']} "
                f"({format_age(age)}){stale_flag(age)}"
            )
        lines.append("")

    authored = data.get("authored_prs", [])
    lines.append("### My Open PRs")
    if not authored:
        lines.append("_No open PRs._\n")
    else:
        needs_attention = [
            p for p in authored
            if p.get("review_decision") == "CHANGES_REQUESTED"
            or p.get("comments", 0) > 0
        ]
        clean = [p for p in authored if p not in needs_attention]

        if needs_attention:
            lines.append("**Needs attention:**")
            for pr in needs_attention:
                age = pr.get("age_days", -1)
                decision = pr.get("review_decision", "")
                flag = " **[CHANGES REQUESTED]**" if decision == "CHANGES_REQUESTED" else ""
                draft = " _(draft)_" if pr.get("is_draft") else ""
                lines.append(
                    f"- [#{pr['number']} {pr['title']}]({pr['url']}) "
                    f"— {pr['repo']}{flag}{draft} ({format_age(age)}, {pr.get('comments', 0)} comments)"
                )

        if clean:
            lines.append("\n**Looking good:**")
            for pr in clean:
                age = pr.get("age_days", -1)
                draft = " _(draft)_" if pr.get("is_draft") else ""
                lines.append(
                    f"- [#{pr['number']} {pr['title']}]({pr['url']}) "
                    f"— {pr['repo']}{draft} ({format_age(age)})"
                )
        lines.append("")

    return "\n".join(lines)


def render_jira(data: dict) -> str:
    if not data:
        return "## Jira\n\n**Jira**: unavailable\n"

    lines = ["## Jira\n"]
    issues = data.get("issues", [])

    if not issues:
        lines.append("_No active tickets._\n")
        return "\n".join(lines)

    in_progress = [i for i in issues if "progress" in i.get("status", "").lower()]
    other = [i for i in issues if i not in in_progress]

    if in_progress:
        lines.append("**In Progress:**")
        for issue in in_progress:
            lines.append(f"- [{issue['key']}]({issue.get('url', '#')}) — {issue['summary']}")
        lines.append("")

    if other:
        lines.append("**Assigned / Up Next:**")
        for issue in other:
            lines.append(
                f"- [{issue['key']}]({issue.get('url', '#')}) — {issue['summary']} "
                f"_({issue.get('status', '?')})_"
            )
        lines.append("")

    return "\n".join(lines)


def render_calendar(data: dict) -> str:
    if not data:
        return "## Today's Schedule\n\n**Calendar**: unavailable — run M365 MCP auth to enable\n"

    lines = ["## Today's Schedule\n"]
    events = data.get("events", [])

    if not events:
        lines.append("_No meetings today._\n")
    else:
        for event in events:
            start = event.get("start", "")
            end = event.get("end", "")
            title = event.get("title", "(untitled)")
            time_range = f"{start}–{end}" if start and end else start or "all day"
            lines.append(f"- **{time_range}** — {title}")
        lines.append("")

    return "\n".join(lines)


def main() -> None:
    parser = argparse.ArgumentParser(description="Format morning briefing from JSON inputs")
    parser.add_argument("--github", help="Path to github.json from gather_github.py")
    parser.add_argument("--jira", help="Path to jira.json (Claude-generated from MCP)")
    parser.add_argument("--calendar", help="Path to calendar.json (Claude-generated from MCP)")
    args = parser.parse_args()

    github = load_json(args.github)
    jira = load_json(args.jira)
    calendar = load_json(args.calendar)

    today = datetime.today()
    header = today.strftime("# Morning Briefing -- %A, %B %-d")

    sections = [
        header,
        "",
        render_calendar(calendar),
        "---",
        "",
        render_github(github),
        "---",
        "",
        render_jira(jira),
        "---",
        "",
        "## From Yesterday",
        "",
        "<!-- Claude: insert summary of yesterday's journal here -->",
        "",
        "---",
        "",
        "## Active Projects",
        "",
        "<!-- Claude: insert active projects + this week's focus from index.md here -->",
    ]

    print("\n".join(sections))


if __name__ == "__main__":
    main()

---
name: start-my-day
description: Morning briefing skill for Jed. Use when the user says "start my day", "morning briefing", "what's on my plate", "what do I have today", or runs /start-my-day. Pulls GitHub PRs (authored + review-requested), Jira tickets, Outlook calendar, and yesterday's PKM journal to produce a structured daily briefing filed in the vault. Always invoke when the user wants to orient themselves at the start of their workday or get a summary of current responsibilities across tools.
---

# Start My Day

Produces a structured morning briefing by gathering live data, running formatting scripts, and filing the result in the PKM vault.

The vault is at `~/vault/pkm`.
Scripts live at `~/.claude/skills/start-my-day/scripts/`.

---

## Step 1: Gather Data

Run these **in parallel** — don't wait for one before starting another.

### A. GitHub (script)

```bash
python3 ~/.claude/skills/start-my-day/scripts/gather_github.py > /tmp/briefing_github.json
```

This outputs structured JSON: `authored_prs` and `review_requested`.

### B. Jira (MCP)

Call `mcp__plugin_atlassian_atlassian__searchJiraIssuesUsingJql` with:

```
assignee = currentUser() AND status NOT IN (Done, Closed, Cancelled) ORDER BY updated DESC
```

Request fields: `summary`, `status`, `priority`, `updated`, `key`.

Transform the result into this JSON and save to `/tmp/briefing_jira.json`:

```json
{
  "source": "jira",
  "issues": [
    {
      "key": "SEC2-416",
      "summary": "Python tooling upgrade",
      "status": "In Progress",
      "priority": "Medium",
      "url": "https://csgactuarial.atlassian.net/browse/SEC2-416"
    }
  ]
}
```

If Jira fails, write `{"source": "jira", "issues": [], "error": "unavailable"}` to the file.

### C. Outlook Calendar (MCP)

Use the M365 MCP to fetch today's calendar events. If not authenticated, note it and continue.

Transform the result and save to `/tmp/briefing_calendar.json`:

```json
{
  "source": "calendar",
  "events": [
    {
      "title": "1:1 with Alex",
      "start": "9:00 AM",
      "end": "9:30 AM"
    }
  ]
}
```

If unavailable, write `{"source": "calendar", "events": [], "error": "unavailable"}`.

### D. PKM (direct reads)

Read these two files directly:

1. `~/vault/pkm/index.md` — note the "Active Projects" and "This Week" sections
2. Most recent journal: find the latest `YYYY-MM-DD.md` in `~/vault/pkm/areas/career-growth/work-journal/` that predates today

```bash
ls ~/vault/pkm/areas/career-growth/work-journal/*.md \
  | grep -E '[0-9]{4}-[0-9]{2}-[0-9]{2}\.md' \
  | sort | grep -v "$(date +%Y-%m-%d)" | tail -1
```

Read that file and note: planned tasks, carryover items, blockers, anything marked "tomorrow" or "carry forward".

---

## Step 2: Run the Formatter

Once all sources are collected (or have timed out):

```bash
python3 ~/.claude/skills/start-my-day/scripts/format_briefing.py \
  --github /tmp/briefing_github.json \
  --jira /tmp/briefing_jira.json \
  --calendar /tmp/briefing_calendar.json
```

This outputs the skeleton briefing with placeholder comments for the PKM sections.

---

## Step 3: Fill In PKM Content

The formatter output contains two placeholder comments:

```
<!-- Claude: insert summary of yesterday's journal here -->
<!-- Claude: insert active projects + this week's focus from index.md here -->
```

Replace them with:

- **From Yesterday**: 3-5 bullet points summarizing what was worked on, what was left incomplete, and any explicit "tomorrow" items. Include a link to the journal file.
- **Active Projects**: The active projects list from index.md, plus the "This Week" section if present. Keep it as-is — don't paraphrase.

---

## Step 4: File the Briefing

```bash
TODAY=$(date +%Y-%m-%d)
JOURNAL="$HOME/vault/pkm/areas/career-growth/work-journal/$TODAY.md"
```

- **If today's journal doesn't exist**: create it with YAML frontmatter (see below) and the full briefing as content.
- **If it already exists**: prepend a `## Morning Briefing` section at the top (after frontmatter), don't overwrite anything.

Frontmatter for a new file:

```yaml
---
tags: [journal, work-log]
category: journal
status: active
created: YYYY-MM-DD
updated: YYYY-MM-DD
---
```

---

## Step 5: Present and Offer to Dig In

Display the briefing in the conversation.

Then ask:

> "Anything you want to dig into? I can pull up PR details, look at a Jira ticket, check on a project, or help you plan your day."

If the user wants details on a specific item, do it — pull PR comments, ticket history, project status, etc.

---

## Error Handling

Never block the briefing on a single failing source. If a source fails, show it as "unavailable" in that section and continue. A partial briefing is always better than no briefing.

| Source | Failure mode | Response |
|--------|-------------|---------|
| GitHub | `gh` not authed | Show "GitHub unavailable — run `gh auth login`" |
| Jira | MCP not authed | Show "Jira unavailable" |
| Calendar | M365 not authed | Show "Calendar unavailable — authenticate with M365 MCP" |
| PKM journal | File missing | Show "No journal entry found for previous workday" |

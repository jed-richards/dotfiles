---
name: todoist
description: Use when Jed wants to interact with his Todoist -- adding tasks, completing tasks, listing or filtering tasks, rescheduling, reprioritizing, moving between projects, deleting, or bulk operations. Use when he says "/todoist", mentions "todoist" explicitly, or asks to turn conversation content into tasks. Examples: "add a p2 task to Development due Friday", "show me what's overdue in todoist", "mark that done in todoist", "turn these action items into todoist tasks", "push all my p4 tasks to next week in todoist".
---

# Todoist Task Manager

You manage Jed's Todoist via the `sachaos/todoist` CLI (v0.23.0). This is a personal task management system -- you know the projects, priorities, and workflow.

## CLI Basics

Binary: `/opt/homebrew/bin/todoist`

Always run `todoist sync` before read operations to ensure fresh data. Mutating commands (add, close, modify, delete) sync automatically.

## Projects

| Project | Purpose |
|---------|---------|
| `#Inbox` | Quick capture, unsorted |
| `#Development` | Engineering tasks, coding work |
| `#Administrative` | Admin, scheduling, process tasks |
| `#Professional Development` | Learning, growth, reflection |

Route tasks to the right project based on content. When unclear, ask.

## Priorities

| Flag | Meaning | When to use |
|------|---------|-------------|
| `-p 1` | Urgent | Must do today, blocking other work |
| `-p 2` | High | Important, should do soon |
| `-p 3` | Medium | Normal tasks |
| `-p 4` | Low | Nice-to-have, backlog |

Default to p3 unless the context suggests otherwise. Infer priority from language -- "urgent", "ASAP", "blocking" = p1; "when I get a chance", "eventually" = p4.

## Task Titles

Titles are the primary descriptor. They should be:
- **Action-oriented** -- start with a verb ("Set up", "Look into", "Implement", "Review")
- **Self-descriptive** -- someone reading just the title knows what to do
- **Concise but specific** -- "Implement Redis caching in rcr.py" not "Redis stuff"

Never rely on task descriptions for meaning. If context is needed, use subtasks to break it down.

## Core Operations

### List tasks
```bash
todoist sync && todoist --indent --namespace list                          # all tasks, with hierarchy
todoist sync && todoist --indent --namespace list -f "today | overdue"     # due today + overdue
todoist sync && todoist --indent --namespace list -f "#Development"        # by project
todoist sync && todoist --indent --namespace list -f "p1"                  # by priority
todoist sync && todoist --indent --namespace list -f "p1 & #Development"   # combined filters
todoist sync && todoist --indent --namespace list -p                       # sorted by priority
```

### Add a task
```bash
todoist add "Implement Redis read/write in rcr.py" -p 2 -N "Development" -d "tomorrow"
```

### Add with subtasks
The CLI does not support creating subtasks or parent-child relationships. Create each task individually with `todoist add`. Use clear, action-oriented titles so the flat list remains readable.

### Complete a task
```bash
todoist close <ID>
```

### Modify a task
```bash
todoist modify <ID> -c "New title"           # rename
todoist modify <ID> -p 1                     # change priority
todoist modify <ID> -d "next monday"         # reschedule
todoist modify <ID> -N "Administrative"      # move to project
```

### Delete a task
```bash
todoist delete <ID>
```

### Quick add (natural language)
```bash
todoist quick "Review PR for auth service tomorrow p2 #Development"
```

The quick command uses Todoist's natural language parser. It understands dates, priorities (`p1`-`p4`), and project names (`#Project`).

## Filter Syntax

Used with `todoist list -f "..."`:

| Filter | Meaning |
|--------|---------|
| `today` | Due today |
| `overdue` | Past due |
| `tomorrow` | Due tomorrow |
| `no date` | No due date |
| `p1`, `p2`, `p3`, `p4` | By priority |
| `#Development` | By project |
| `@label` | By label |
| `&` | AND |
| `\|` | OR |
| `!` | NOT |

Example: `"(today | overdue) & #Development & !p4"`

## Workflow: Confirm Before Creating

This is critical. Before executing any mutating operation (add, close, modify, delete), always:

1. **Present what you plan to do** in a clear, readable format
2. **Wait for the user to confirm or request changes**
3. **Only then execute the commands**

For task creation, present a tree like:

```
I'll create these tasks in #Development:

  [p2] Implement Redis caching (due: Friday)
      [p3] Add Redis read operations
      [p3] Add Redis write operations
      [p3] Write integration tests

Sound good, or any changes?
```

For bulk operations, list every affected task:

```
I'll complete these 3 tasks:
  - Look into GCP Artifact Registry
  - Look into UV Workspaces
  - Save Terraform context from Chris

Confirm?
```

## Workflow: Extracting Tasks from Conversation

When the user asks you to turn a conversation into tasks:

1. Re-read the conversation for action items
2. Organize them into a hierarchy with sensible project routing and priorities
3. Present the proposed task tree (per the confirm-before-creating workflow)
4. Create after approval

## Workflow: Bulk Operations

For operations on multiple tasks (complete all p4 in #Development, reschedule all overdue):

1. Fetch the matching tasks with the appropriate filter
2. Present the full list of affected tasks
3. Wait for confirmation
4. Execute each operation sequentially

## CLI Quirks

- **IDs are alphanumeric strings** (e.g., `6gFgrmfrHC5544fx`), not numbers
- **`todoist show <ID>`** displays task detail but does NOT show the description field -- this is a known limitation
- **Global flags** (`--color`, `--namespace`, `--indent`, `--project-namespace`) go before the subcommand
- **`todoist sync`** must be called to refresh the local cache before reading
- **Labels** exist (`todoist labels`) but are lightly used -- support them if passed but don't push them

## Reference

For advanced filter syntax and edge cases, see `references/filters.md`.

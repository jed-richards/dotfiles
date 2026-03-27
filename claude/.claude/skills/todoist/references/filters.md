# Todoist Filter Reference

Full syntax for `todoist list -f "..."`.

## Boolean Operators

| Operator | Meaning |
|----------|---------|
| `&` | AND |
| `\|` | OR |
| `!` | NOT |
| `()` | Grouping |

## Date Filters

| Filter | Meaning |
|--------|---------|
| `today` | Due today |
| `tomorrow` | Due tomorrow |
| `overdue` / `od` | Past due |
| `no date` | No due date set |
| `date: Jan 3` | Due on specific date |
| `date before: May 5` | Due before date |
| `date after: May 5` | Due after date |
| `recurring` | Recurring tasks only |
| `!recurring` | Non-recurring tasks only |

## Priority

| Filter | Meaning |
|--------|---------|
| `p1` | Priority 1 (urgent) |
| `p2` | Priority 2 (high) |
| `p3` | Priority 3 (medium) |
| `p4` | Priority 4 (low) |
| `no priority` | Default priority |

## Project and Section

| Filter | Meaning |
|--------|---------|
| `#ProjectName` | Tasks in project |
| `##ProjectName` | Tasks in project + subprojects |
| `/SectionName` | Tasks in section |
| `#Project & /Section` | Combined |

## Labels

| Filter | Meaning |
|--------|---------|
| `@labelname` | Tasks with label |
| `no labels` | Tasks without labels |
| `@home*` | Wildcard match |

## Search

| Filter | Meaning |
|--------|---------|
| `search: keyword` | Full-text search |

## Example Compound Filters

```
(today | overdue) & #Development
p1 & !#Inbox
#Administrative & !p4 & !recurring
no date & #Development
(p1 | p2) & overdue
```

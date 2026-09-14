# Notification helpers: `pr-notify` and `notify`

Two zsh functions that fire a native macOS notification when something finishes, so you don't have to babysit a terminal.

## Requirement

Both rely on [`terminal-notifier`](https://github.com/julienXX/terminal-notifier):

```sh
brew install terminal-notifier
```

## `pr-notify` — watch a PR's CI checks

Wraps `gh pr checks --watch` and notifies you when checks finish, with a sound that differs for pass/fail. Clicking the notification opens the PR in your browser.

```sh
pr-notify() {
  local pr_url
  pr_url="$(gh pr view "$@" --json url -q .url 2>/dev/null)"
  if gh pr checks --watch "$@"; then
    terminal-notifier -title "CI" -message "All checks passed" -sound Glass -open "$pr_url"
  else
    terminal-notifier -title "CI" -message "Checks failed" -sound Basso -open "$pr_url"
  fi
}
```

**Usage:**

```sh
# Watch checks for the PR associated with your current branch
pr-notify

# Watch checks for a specific PR number
pr-notify 482

# Any args are passed straight through to `gh pr checks` / `gh pr view`,
# so you can target a PR on another branch too
pr-notify --repo org/repo 482
```

## `notify` — wrap any long-running command

Runs whatever command you give it, then notifies you whether it succeeded or failed (including the exit code on failure).

```sh
notify() {
  local cmd="$*"
  "$@"
  local exit_code=$?
  if [ $exit_code -eq 0 ]; then
    terminal-notifier -title "$cmd" -message "Succeeded" -sound Glass
  else
    terminal-notifier -title "$cmd" -message "Failed (exit $exit_code)" -sound Basso
  fi
}
```

**Usage:**

```sh
# Get pinged when a long build finishes
notify npm run build

# Get pinged when a test suite finishes (pass or fail)
notify pytest -x

# Works with any command/args, since "$@" is passed through as-is
notify terraform apply -auto-approve
```

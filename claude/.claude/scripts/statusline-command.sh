#!/usr/bin/env bash
# Claude Code statusline -- 2-line dashboard
# Requires: Nerd Font, truecolor terminal

RESET='\033[0m'

# Shell-matched palette
C_TIME='\033[2m\033[38;5;99m'        # Dim purple   -- time
C_DIR='\033[38;2;116;199;236m'      # Muted sapphire -- directory
C_GIT='\033[31m'                    # Red          -- git branch
C_STAGED='\033[32m'                 # Green        -- staged marker
C_DIRTY='\033[31m'                  # Red          -- unstaged marker
C_MODEL='\033[2m\033[34m'           # Dim blue     -- model
C_COST='\033[2m\033[33m'            # Dim yellow   -- cost
C_ADD='\033[32m'                    # Green        -- lines added
C_DEL='\033[31m'                    # Red          -- lines removed
C_CACHE='\033[36m'                  # Cyan         -- cache hit
C_SEP='\033[2m'                     # Dim          -- separators
C_BAR_EMPTY='\033[38;2;69;71;90m'   # Surface   -- bar background
C_BAR_OK='\033[38;2;166;227;161m'   # Green     -- ctx < 50%
C_BAR_WARN='\033[38;2;249;226;175m' # Yellow    -- ctx 50-70%
C_BAR_HIGH='\033[38;2;250;179;135m' # Peach     -- ctx 70-85%
C_BAR_CRIT='\033[38;2;243;139;168m' # Red       -- ctx > 85%

# --- Parse JSON input (single jq call) ---
input=$(cat)
eval "$(echo "$input" | jq -r '
  @sh "cwd=\(.workspace.current_dir // "")",
  @sh "model=\(.model.display_name // "")",
  @sh "cost=\(.cost.total_cost_usd // "")",
  @sh "lines_added=\(.cost.total_lines_added // 0)",
  @sh "lines_removed=\(.cost.total_lines_removed // 0)",
  @sh "ctx_pct=\(.context_window.used_percentage // "")",
  @sh "cache_read=\(.context_window.current_usage.cache_read_input_tokens // 0)",
  @sh "cache_create=\(.context_window.current_usage.cache_creation_input_tokens // 0)"
')"

# --- Short dir: last 2 path components, home as ~ ---
display_cwd="${cwd/#$HOME/~}"
short_dir=$(echo "$display_cwd" | awk -F/ '{
  n = split($0, p, "/");
  if (n <= 2) print $0;
  else print p[n-1] "/" p[n];
}')

# --- Git info ---
git_branch=""
git_staged=""
git_dirty=""
if [[ -n "$cwd" ]] && git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git_branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null \
    || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
  git -C "$cwd" diff --cached --quiet 2>/dev/null || git_staged="+"
  git -C "$cwd" diff --quiet 2>/dev/null          || git_dirty="!"
fi

# --- Context progress bar ---
bar_str=""
bar_pct=""
bar_color="$C_BAR_OK"
if [[ -n "$ctx_pct" ]]; then
  bar_pct=${ctx_pct%%.*}
  if   [[ $bar_pct -ge 85 ]]; then bar_color="$C_BAR_CRIT"
  elif [[ $bar_pct -ge 70 ]]; then bar_color="$C_BAR_HIGH"
  elif [[ $bar_pct -ge 50 ]]; then bar_color="$C_BAR_WARN"
  fi
  bar_width=12
  filled=$(( bar_pct * bar_width / 100 ))
  empty=$(( bar_width - filled ))
  bar_str="${bar_color}"
  for ((i=0; i<filled; i++)); do bar_str="${bar_str}█"; done
  bar_str="${bar_str}${C_BAR_EMPTY}"
  for ((i=0; i<empty; i++)); do bar_str="${bar_str}░"; done
  bar_str="${bar_str}${RESET}"
fi

# --- Cache hit % ---
cache_hit=""
cache_total=$(( cache_read + cache_create ))
[[ $cache_total -gt 0 ]] && cache_hit=$(( cache_read * 100 / cache_total ))

# --- Cost ---
cost_fmt=""
[[ -n "$cost" ]] && cost_fmt=$(printf '$%.2f' "$cost")

# --- Line 1: time | git branch + markers | lines changed ---
L1="${C_TIME}󰥔 $(date +%I:%M%p)${RESET}"
if [[ -n "$git_branch" ]]; then
  L1="${L1}  ${C_GIT} ${git_branch}${RESET}"
  [[ -n "$git_staged" ]] && L1="${L1}${C_STAGED}+${RESET}"
  [[ -n "$git_dirty" ]]  && L1="${L1}${C_DIRTY}!${RESET}"
fi
if [[ "${lines_added:-0}" != "0" ]] || [[ "${lines_removed:-0}" != "0" ]]; then
  L1="${L1}  ${C_SEP}|  ${C_ADD}+${lines_added} ${C_DEL}-${lines_removed}${RESET}"
fi

# --- Line 2: dir | model | context bar | cost | cache ---
L2="${C_DIR} ${short_dir}${RESET}"
[[ -n "$model" ]] && L2="${L2}  ${C_SEP}| ${C_MODEL}󰚩 ${model}${RESET}"
if [[ -n "$bar_pct" ]]; then
  L2="${L2}  ${C_SEP}| ${bar_str} ${bar_color}${bar_pct}%${RESET}"
fi
[[ -n "$cost_fmt" ]]  && L2="${L2}  ${C_SEP}| ${C_COST}${cost_fmt}${RESET}"
[[ -n "$cache_hit" ]] && L2="${L2}  ${C_SEP}| ${C_CACHE}⚡${cache_hit}%${RESET}"

printf '%b\n' "$L1"
printf '%b\n' "$L2"

#!/bin/bash
# focus-or-spawn: Switch to a named workspace, focusing the app or spawning it
# Usage: focus-or-spawn <workspace-name> <window-class> <cmd> [args...]
#
# Example: focus-or-spawn browser zen zen-browser
#
# To find window classes: hyprctl clients -j | jq '.[].class'

workspace="$1"
class="$2"
shift 2

# Find the workspace the app is currently on (check class and initialClass)
existing_workspace=$(hyprctl clients -j | jq -r \
    --arg cls "$class" \
    '.[] | select(.class == $cls or .initialClass == $cls) | .workspace.name' \
    | head -1)

if [ -n "$existing_workspace" ]; then
    # App is running: go to its workspace and focus it
    hyprctl dispatch workspace "name:$existing_workspace"
    hyprctl dispatch focuswindow "class:$class"
else
    # App not running: go to designated workspace and launch it
    hyprctl dispatch workspace "name:$workspace"
    "$@" &
fi

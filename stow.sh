#!/usr/bin/env bash

# stow.sh - Stow dotfile packages into $HOME
# Usage: ./stow.sh [-D|-R] [-n] [-l] [package...]
#   (no packages)  stow every package that applies to this OS
#   -D             unstow
#   -R             restow (prune stale links, then stow again)
#   -n             dry run: show what would happen
#   -l             list the packages that would be stowed and exit

set -euo pipefail

cd "$(dirname "$(readlink -f "$0")")"

# Not stow packages
skip=(tools wallpapers)
# Only stowed on the matching OS
linux_only=(hypr ly niri systemd waybar)
macos_only=(aerospace)

action=-S
dry_run=()
list=0

usage() { sed -n '3,9s/^# \{0,1\}//p' "$0"; }

while getopts "DRnlh" opt; do
    case "$opt" in
        D) action=-D ;;
        R) action=-R ;;
        n) dry_run=(-n) ;;
        l) list=1 ;;
        h) usage; exit 0 ;;
        *) usage >&2; exit 1 ;;
    esac
done
shift $((OPTIND - 1))

command -v stow > /dev/null || { echo "error: 'stow' not found" >&2; exit 1; }

contains() {
    local needle="$1"; shift
    local x
    for x in "$@"; do [ "$x" = "$needle" ] && return 0; done
    return 1
}

case "$(uname -s)" in
    Darwin) skip+=("${linux_only[@]}") ;;
    *)      skip+=("${macos_only[@]}") ;;
esac

if [ "$#" -gt 0 ]; then
    packages=("${@%/}")
else
    packages=()
    for dir in */; do
        pkg="${dir%/}"
        contains "$pkg" "${skip[@]}" || packages+=("$pkg")
    done
fi

if [ "$list" -eq 1 ]; then
    printf '%s\n' "${packages[@]}"
    exit 0
fi

for pkg in "${packages[@]}"; do
    [ -d "$pkg" ] || { echo "error: no package '$pkg'" >&2; exit 1; }
done

# Submodule-backed packages (nvim, tmux plugins, ...) are empty until initialized
if [ "$action" != -D ] && git submodule status 2> /dev/null | grep -q '^-'; then
    echo "==> initializing submodules"
    git submodule update --init --recursive
fi

echo "==> stow $action ${dry_run[*]} -t $HOME ${packages[*]}"
stow "$action" "${dry_run[@]}" -v -t "$HOME" "${packages[@]}"

#!/usr/bin/env bash

# Toggles/reports the freedesktop color-scheme setting (org.gnome.desktop.interface
# color-scheme), which is what auto-dark-mode.nvim polls via xdg-desktop-portal
# to sync nvim's background/colorscheme.

KEY="color-scheme"
SCHEMA="org.gnome.desktop.interface"

toggle() {
    current=$(gsettings get "$SCHEMA" "$KEY")
    if [[ "$current" == "'prefer-dark'" ]]; then
        gsettings set "$SCHEMA" "$KEY" "default"
    else
        gsettings set "$SCHEMA" "$KEY" "prefer-dark"
    fi
}

status() {
    current=$(gsettings get "$SCHEMA" "$KEY")
    if [[ "$current" == "'prefer-dark'" ]]; then
        echo '{"text": "󰽥", "tooltip": "Dark mode (click to switch to light)", "class": "dark"}'
    else
        echo '{"text": "󰃞", "tooltip": "Light mode (click to switch to dark)", "class": "light"}'
    fi
}

case "$1" in
    toggle) toggle ;;
    *) status ;;
esac

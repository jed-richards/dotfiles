#!/bin/sh
# Toggle tmux status bar colors based on system appearance (cyberdream palette)

is_dark() {
    case "$(uname)" in
        Darwin)
            defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q Dark
            ;;
        Linux)
            # GNOME / GTK
            if command -v gsettings >/dev/null 2>&1; then
                gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null | grep -q dark && return 0
                gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null | grep -qi dark && return 0
            fi
            # KDE
            if [ -f "$HOME/.config/kdeglobals" ]; then
                grep -qi "dark" "$HOME/.config/kdeglobals" && return 0
            fi
            return 1
            ;;
        *)
            return 1
            ;;
    esac
}

if is_dark; then
    tmux set -g status-style "fg=#ffffff,bg=#16181a"
else
    tmux set -g status-style "fg=#16181a,bg=#ffffff"
fi

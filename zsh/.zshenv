# NOTE: This file is required at `~/.zshenv` so that we can set ZDOTDIR before
# zsh looks for `.zshrc`

# Set XDG directories because for some reason they don't get set by default.
# See:
#  - https://specifications.freedesktop.org/basedir-spec/latest
#  - https://wiki.archlinux.org/title/XDG_Base_Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# Set zsh config directory
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# editor
export EDITOR="nvim"
export VISUAL="nvim"
export GIT_EDITOR="nvim"

# Man pages
export MANPAGER='nvim +Man!'

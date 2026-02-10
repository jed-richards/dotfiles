# Resources:
#  - https://thevaluable.dev/zsh-install-configure-mouseless/
#  - https://thevaluable.dev/zsh-completion-guide-examples/
#  - https://wiki.archlinux.org/title/XDG_Base_Directory#Partial and search for zsh

bindkey -e

#== Shell history
[ -d "$XDG_STATE_HOME"/zsh ] || mkdir -p "$XDG_STATE_HOME"/zsh
HISTFILE="$XDG_STATE_HOME"/zsh/history
HISTSIZE=10000
SAVEHIST=10000

#== Options (see `man zshall` and search for "SPECIFYING OPTIONS")
setopt EXTENDED_HISTORY       # write history in `:<start time>:<elapsed seconds>;<command>' format
setopt HIST_IGNORE_ALL_DUPS   # delete old entry if new entry is a duplicate
setopt SHARE_HISTORY          # share shell history between sessions
setopt INTERACTIVE_COMMENTS   # allow comments in interactive shell (enables # prefix)

#== Add ons
source "$ZDOTDIR/aliases"
source "$ZDOTDIR/completion"
source "$ZDOTDIR/keybinds"
source "$ZDOTDIR/plugins/init"
source "$ZDOTDIR/work"

# Prompts
fpath=($ZDOTDIR/prompts $fpath)
autoload -U promptinit && promptinit
prompt jed


#== Source tooling integration
if command -v fzf &>/dev/null; then
    eval "$(fzf --zsh)"
fi

# TODO: write this to ~/.local/share/zsh/completions/_zoxide
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi

# TODO: write this to ~/.local/share/zsh/completions/_gh
if command -v gh &>/dev/null; then
    eval "$(gh completion --shell zsh)"
fi

# TODO: write this to ~/.local/share/zsh/completions/_docker
if command -v docker &>/dev/null; then
    eval "$(docker completion zsh)"
fi

#== Other

# Disable all error beeps and beeps for pager with LESS
unsetopt BEEP
export LESS="$LESS -Q -R" # -Q for quiet and -R for raw ansi escape sequences (color)

# Unset the default alias for `run-help`; it is an alias for `man`.
# Then load the more advanced `run-help`
unalias run-help
autoload -U run-help

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
setopt COMPLETE_ALIASES

#== Add ons
source "$ZDOTDIR/aliases"
source "$ZDOTDIR/completion"
source "$ZDOTDIR/keybinds"
source "$ZDOTDIR/plugins/init"

# Prompts
fpath=($ZDOTDIR/prompts $fpath)
autoload -U promptinit && promptinit
prompt jed

#== Other

# Disable all error beeps and beeps for pager with LESS
unsetopt BEEP
export LESS="$LESS -Q"

# Add bins to path
export PATH="/home/jed-richards/bin:$PATH"
export PATH="/home/jed-richards/.cargo/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$PATH:$HOME/projects/wtree"

# Work
export ANGEL_WORKTREES="/home/jed-richards/work/angel-worktrees"
export PYFLX_WORKTREES="/home/jed-richards/work/pyflx-worktrees"
export FLX_WORKTREES="/home/jed-richards/work/flx-worktrees"

# Add flx specific tools to PATH
export PATH="$FLX_WORKTREES/flx-clean/tools:$PATH"

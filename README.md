# dotfiles

Collection of my dotfiles

## Setup

1. Clone the repo

```bash
git clone git@github.com:jed-richards/dotfiles.git
```

2. Install [stow](https://www.gnu.org/software/stow/)

3. Initialize submodules

```bash
git submodule update --init --recursive
```

4. Stow!

```bash
# Stow individual packages
stow -t $HOME nvim
stow -t $HOME zsh
stow -t $HOME bin   # personal scripts and tools → ~/.local/bin/
```

## Personal Scripts & Tools

Personal scripts and external tools live under `bin/` and `tools/` respectively.

- **`bin/.local/bin/`** — stowed to `~/.local/bin/`, already on `$PATH`
  - Drop shell scripts directly here
  - Symlinks to binaries in `tools/` go here
- **`tools/`** — external tool repos (git submodules)

To add a new tool:

```bash
# 1. Add as a submodule
git submodule add <repo-url> tools/<name>

# 2. Symlink the binary into bin/.local/bin/
cd bin/.local/bin
ln -s ../../../tools/<name>/<binary> <name>
```

## Dev

### Waybar

Use the below to auto reload `waybar` when editing the config.

```bash
watchexec -w waybar/.config "(pkill waybar || true) && hyprctl dispatch exec waybar"
```

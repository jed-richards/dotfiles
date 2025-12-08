# dotfiles

Collection of my dotfiles

## Setup

1. Clone the repo

```bash
git clone git@github.com:jed-richards/dotfiles.git
```

2. Install [stow](https://www.gnu.org/software/stow/)

3. Add initialize submodules

```bash
git submodule update --init --recursive
```

4. Stow!

```bash
# Example to stow nvim directory
stow -t $HOME nvim
```

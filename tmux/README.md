# tmux

tmux config, managed via stow, with plugins installed as git submodules
and loaded by [tpm](https://github.com/tmux-plugins/tpm).

## Setup

1. From the dotfiles repo root, initialize the submodules (tpm and any
   plugins):

```bash
git submodule update --init --recursive
```

2. Stow the package:

```bash
stow -t $HOME tmux
```

This symlinks `~/.config/tmux` to `tmux/.config/tmux` in this repo, so
`tmux.conf` and `plugins/` (tpm, circadia, ...) are the same files as
the ones tracked here — no separate step is needed to make plugins
show up at runtime.

3. Start tmux and reload plugins:

```bash
tmux
# inside tmux:
prefix + I    # fetches/sources any missing plugins
```

## Adding a plugin

Plugins are vendored as git submodules under `.config/tmux/plugins/`
rather than left for tpm to clone at runtime, so a fresh `git clone` +
`git submodule update --init` fully reproduces the setup without a
network-dependent `prefix + I` step.

```bash
git submodule add <plugin-repo-url> tmux/.config/tmux/plugins/<name>
```

Then add `set -g @plugin '<user>/<name>'` to `tmux.conf` above the
`run '~/.config/tmux/plugins/tpm/tpm'` line at the bottom.

**Note:** tpm only auto-sources a `*.tmux` file that lives at a
plugin's *root* directory. If a plugin's tmux entrypoint is nested
(e.g. `ports/tmux/foo.tmux`), tpm will silently never find it — you'll
need to source it explicitly instead. See the circadia setup below
for an example.

## Colorscheme: circadia

Uses [circadia](https://github.com/tanmaymanojgandhi/circadia)
(`dark-ember` flavour by default; see `@circadia_flavour` in
`tmux.conf` for other options: `light-parchment`, `dark-plum`,
`dark-forest`).

circadia's tmux entrypoint lives at `ports/tmux/circadia.tmux`, not at
the plugin root, so tpm never auto-discovers it. Rather than patching
the vendored submodule (which would pin it to a local-only commit that
doesn't exist upstream, breaking on a fresh clone), `tmux.conf` sources
it explicitly:

```tmux
run 'bash ~/.config/tmux/plugins/circadia/ports/tmux/circadia.tmux'
```

The `set -g @plugin 'tanmaymanojgandhi/circadia'` line is kept purely
so `prefix + U` still updates the submodule; it does not make tpm load
the theme.

### Troubleshooting

**Colors don't change / status bar stays at tmux's default look**

- Confirm the submodule is actually checked out:
  `git -C tmux/.config/tmux/plugins/circadia status` should not say
  "no submodule mapping found" or show an empty directory. If it's
  empty, run `git submodule update --init --recursive`.
- Confirm the explicit `run 'bash .../circadia.tmux'` line is present
  in `tmux.conf` — if it's missing, tpm alone will never load this
  theme (see the note above about nested entrypoints).
- Reload and check directly:

  ```bash
  tmux source-file ~/.config/tmux/tmux.conf
  tmux show-options -g status-style
  ```

  If this still shows a light/default style instead of the
  `dark-ember` colors, run the port script by hand to see the error:

  ```bash
  bash ~/.config/tmux/plugins/circadia/ports/tmux/circadia.tmux
  ```

**"No such file or directory" pointing at a `circadia-<flavour>.tmux` file**

This means something is trying to resolve the flavour file relative to
the wrong directory (e.g. from a symlink placed outside
`ports/tmux/`). The script computes its own directory from
`${BASH_SOURCE[0]}`, so it only works when invoked from its real
location inside `ports/tmux/` — don't symlink `circadia.tmux` out to
the plugin root by itself; source it via the full `ports/tmux/` path
as shown above.

**`run '...tpm/tpm'` fails with exit code 126**

Usually a missing execute bit on `tpm` itself, or on a plugin's
`*.tmux` file that tpm tries to auto-source (tpm executes these
directly rather than `source-file`-ing them). Check with:

```bash
ls -l ~/.config/tmux/plugins/tpm/tpm
```

and `chmod +x` as needed. This shouldn't come up for circadia since
it's sourced explicitly via `bash` above, sidestepping the executable
requirement entirely.

**Checking which flavour is actually applied**

```bash
tmux show-options -g @circadia_flavour
tmux show-options -g status-style
```

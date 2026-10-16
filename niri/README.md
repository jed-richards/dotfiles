# niri

Scrollable-tiling Wayland compositor.

## Install

```bash
paru -S niri swaybg lxqt-policykit xwayland-satellite
```

## Apply dotfiles

```bash
# From dotfiles root:
stow niri
stow --restow waybar
```

## Session setup

The `niri` package installs `/usr/share/wayland-sessions/niri.desktop` automatically.
`ly` will list it as a session — no further DM configuration needed.

## Deferred / to add later

- **DP-3 external monitor** — add an `output "DP-3" { ... }` block to `config.kdl` when ready
- **focus-or-spawn mnemonic bindings** — try niri's native scrollable model first
- **Scratchpad** — install `niri-scratchpad` or `ndrop` from AUR if you miss it

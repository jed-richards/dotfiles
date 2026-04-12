# niri

Scrollable-tiling Wayland compositor. Runs alongside Hyprland — select at the `ly` login screen.

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

## Key differences from Hyprland

| Concept | Hyprland | niri |
|---|---|---|
| Layout model | Fixed workspaces, windows tile to fill | Infinite horizontal strip, windows never resize |
| Navigation | `mod+h/j/k/l` move focus | Same keys — `h/l` scroll columns, `j/k` move within a column |
| Column width | Drag to resize | `mod+r` cycles preset widths (⅓ → ½ → ⅔ → full) |
| Tabs | Special workspace / plugin | `mod+,` consumes window into column tab; `mod+.` expels it |
| Workspaces | `mod+1-9`, `mod+[` `mod+]` | Same |
| Floating | `mod+ctrl+f` | Same |
| Screenshot | `Print` / `mod+Print` | Same — grim + slurp + satty |

## Deferred / to add later

- **DP-3 external monitor** — add an `output "DP-3" { ... }` block to `config.kdl` when ready
- **focus-or-spawn mnemonic bindings** — try niri's native scrollable model first
- **Scratchpad** — install `niri-scratchpad` or `ndrop` from AUR if you miss it

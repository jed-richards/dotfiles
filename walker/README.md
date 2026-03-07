# Walker

[Walker](https://github.com/abenz1267/walker) is a Wayland-native app launcher with a Raycast-like feel. It uses [Elephant](https://github.com/abenz1267/elephant) as a backend service for data providers (apps, clipboard, files, etc.).

## Dependencies

```bash
paru -S elephant-all-bin walker-bin
```

## Setup

### 1. Enable the elephant backend service

Elephant must run in your user environment (not system-level):

```bash
elephant service enable
systemctl --user start elephant
```

The hyprland config starts it automatically via:

```
exec-once = systemctl --user start elephant
```

### 2. Stow the config

```bash
cd ~/dotfiles && stow walker
```

### 3. Bind the launcher in Hyprland

```
bind = $mod, Space, exec, walker
bind = $mod, v, exec, walker --modules clipboard
```

## Usage

Type to search across apps and open windows simultaneously. Use prefixes to switch modes:

| Prefix | Mode                 |
| ------ | -------------------- |
| `;`    | List all providers   |
| `:`    | Clipboard history    |
| `$`    | Open windows         |
| `/`    | File browser         |
| `@`    | Web search           |
| `%`    | Bookmarks            |
| `=`    | Calculator           |
| `>`    | Shell command runner |

## Keybinds

| Key            | Action                    |
| -------------- | ------------------------- |
| `ctrl+n`       | Next item                 |
| `ctrl+p`       | Previous item             |
| `ctrl+shift+p` | Pin app to top of results |
| `ctrl+Return`  | Open new instance         |
| `Escape`       | Close                     |

## Troubleshooting

**"Waiting for elephant..."** — elephant isn't running:

```bash
systemctl --user restart elephant
```

**Stale socket after killing elephant manually:**

```bash
pkill -x elephant && systemctl --user restart elephant
```

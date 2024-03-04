# dotfiles
Collection of my dotfiles

## Installations

### kitty (terminal emulator)
[Kitty Docs](https://sw.kovidgoyal.net/kitty/)

Install script
```
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
```

Create symlinks to binaries
```
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
```

or

```
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten /usr/bin/
```

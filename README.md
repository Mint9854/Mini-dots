# mini-dots

> minimal/clean dotfiles for CachyOS + Hyprland

Cold dark palette · JetBrains Mono · thin borders · blur

---

## Install

**One-liner** (clone + install in one shot):
```bash
bash <(curl -sL https://raw.githubusercontent.com/mint/mini-dots/main/install.sh)
```

**Manual clone:**
```bash
git clone https://github.com/mint/mini-dots.git ~/.dotfiles
bash ~/.dotfiles/install.sh
```

**Options:**
```
--dry-run     Preview everything, make no changes
--skip-pkgs   Skip package installation
--no-backup   Skip backing up existing configs
```

---

## What it installs

| Component   | Config                          |
|-------------|----------------------------------|
| Hyprland    | window rules, animations, gaps  |
| Hyprpaper   | wallpaper                       |
| Hypridle    | idle / lock / sleep             |
| Waybar      | top bar, blurred, centered clock|
| Wofi        | app launcher                    |
| Kitty       | terminal                        |
| Starship    | shell prompt                    |

---

## Palette

| Role     | Hex       |
|----------|-----------|
| Base     | `#13151e` |
| Surface  | `#1c1f2b` |
| Text     | `#c5cdd9` |
| Accent   | `#7e9ab5` |
| Accent 2 | `#a8b5c8` |
| Red      | `#c47878` |
| Yellow   | `#c4ae78` |
| Green    | `#78c49a` |

---

## Keybinds

| Bind              | Action              |
|-------------------|---------------------|
| `Super + Enter`   | Terminal (kitty)    |
| `Super + Space`   | Launcher (wofi)     |
| `Super + Q`       | Close window        |
| `Super + F`       | Toggle float        |
| `Super + Shift+F` | Fullscreen          |
| `Super + 1–6`     | Switch workspace    |
| `Super + Shift 1–6` | Move to workspace |
| `Super + V`       | Clipboard history   |
| `Super + Shift+S` | Screenshot (area)   |
| `Super + W`       | Reload Waybar       |

---

## After install

- Drop your wallpaper at `~/Pictures/wallpapers/wall.png`
- Reload shell: `source ~/.zshrc` (or `.bashrc`)
- Re-run anytime to pull updates: `bash ~/.dotfiles/install.sh`

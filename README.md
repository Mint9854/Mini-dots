# mini-dots

> minimal/clean dotfiles Hyprland

Cold dark palette · JetBrains Mono · thin borders · blur

---
##Sowcase
<img width="1920" height="1079" alt="image" src="https://github.com/user-attachments/assets/b77d38cc-0bef-44cc-9d2d-7305c52e1677" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/70de4bbe-0d26-48ef-8abb-e4b0c20669ea" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/c1d5668b-d8a2-40e4-b20b-6eff3d2ed704" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/261027b9-53d8-4e30-841a-64c8fa958cb5" />





https://github.com/user-attachments/assets/1119fcde-0e8c-462f-a11b-657959891dc0





## Install

Automatic Installation:
```bash
git clone https://github.com/Mint9854/Mini-dots.git ~/.dotfiles && bash ~/.dotfiles/install.sh
```

**Manual Installation:**
```bash
git clone https://github.com/Mint9854/mini-dots.git ~/.dotfiles
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
| Hyprlock    | Lock screen                     |
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
| `Super + W`       | Wallpaper Selector  |
| 'Super + L'       | Lockscreen          |
---

## After install

- Drop your wallpaper at `~/Pictures/wallpapers/wall.png`
- Reload shell: `source ~/.zshrc` (or `.bashrc`)
- Re-run anytime to pull updates: `bash ~/.dotfiles/install.sh`

#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════╗
# ║          mini-dots — automated installer                 ║
# ║          CachyOS + Hyprland · minimal/clean              ║
# ╚══════════════════════════════════════════════════════════╝
#
#   STEP 1 — push your repo to GitHub first:
#     git init && git remote add origin https://github.com/mint/mini-dots.git
#     git add . && git commit -m "initial" && git push -u origin main
#
#   STEP 2 — then use one of these:
#
#   a) One-liner (curl raw file directly):
#      bash <(curl -fsSL https://raw.githubusercontent.com/mint/mini-dots/main/install.sh)
#
#   b) Clone then run (recommended — works offline after clone):
#      git clone https://github.com/mint/mini-dots.git ~/.dotfiles
#      bash ~/.dotfiles/install.sh
#
#   c) If repo is already at ~/.dotfiles:
#      bash ~/.dotfiles/install.sh

set -euo pipefail

# ── Detect if we received an HTML page instead of a script ───
# (happens when the GitHub repo doesn't exist yet / wrong URL)
if [[ "${BASH_SOURCE[0]:-}" == "" ]] || head -c 15 "${BASH_SOURCE[0]}" 2>/dev/null | grep -qi "<!doctype\|<html"; then
    echo ""
    echo "  ERROR: installer received an HTML page, not a shell script."
    echo "  This usually means the GitHub repo doesn't exist yet, or the URL is wrong."
    echo ""
    echo "  Push your repo first:"
    echo "    git init && git remote add origin https://github.com/mint/mini-dots.git"
    echo "    git add . && git commit -m 'initial' && git push -u origin main"
    echo ""
    echo "  Then re-run:"
    echo "    bash <(curl -fsSL https://raw.githubusercontent.com/mint/mini-dots/main/install.sh)"
    echo ""
    exit 1
fi

# ── Colors ───────────────────────────────────────────────────
R='\033[0;31m'; G='\033[0;32m'; Y='\033[0;33m'
B='\033[0;34m'; C='\033[0;36m'; W='\033[0;37m'; N='\033[0m'
BOLD='\033[1m'

info()    { echo -e "${B}${BOLD}  ··${N} $*"; }
success() { echo -e "${G}${BOLD}  ✓${N}  $*"; }
warn()    { echo -e "${Y}${BOLD}  !${N}  $*"; }
error()   { echo -e "${R}${BOLD}  ✗${N}  $*"; exit 1; }
section() { echo -e "\n${C}${BOLD}── $* ${N}"; }

# ── Arg parsing ──────────────────────────────────────────────
DRY_RUN=false
SKIP_PKGS=false
NO_BACKUP=false

for arg in "$@"; do
    case $arg in
        --dry-run)   DRY_RUN=true   ;;
        --skip-pkgs) SKIP_PKGS=true ;;
        --no-backup) NO_BACKUP=true ;;
        --help|-h)
            echo ""
            echo "  Usage: bash install.sh [options]"
            echo ""
            echo "  Options:"
            echo "    --dry-run     Preview actions without making changes"
            echo "    --skip-pkgs   Skip package installation"
            echo "    --no-backup   Skip backing up existing configs"
            echo ""
            echo "  One-liner (repo must exist on GitHub first):"
            echo "    bash <(curl -fsSL https://raw.githubusercontent.com/mint/mini-dots/main/install.sh)"
            echo ""
            exit 0 ;;
    esac
done

# ── Header ───────────────────────────────────────────────────
clear
echo ""
echo -e "${C}${BOLD}"
echo "  ███╗   ███╗██╗███╗   ██╗██╗      ██████╗  ██████╗ ████████╗███████╗"
echo "  ████╗ ████║██║████╗  ██║██║      ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝"
echo "  ██╔████╔██║██║██╔██╗ ██║██║█████╗██║  ██║██║   ██║   ██║   ███████╗"
echo "  ██║╚██╔╝██║██║██║╚██╗██║██║╚════╝██║  ██║██║   ██║   ██║   ╚════██║"
echo "  ██║ ╚═╝ ██║██║██║ ╚████║██║      ██████╔╝╚██████╔╝   ██║   ███████║"
echo "  ╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚═╝      ╚═════╝  ╚═════╝    ╚═╝   ╚══════╝"
echo -e "${N}"
echo -e "  ${W}github.com/mint/mini-dots${N}  ·  CachyOS + Hyprland  ·  minimal/clean"
echo ""
$DRY_RUN && echo -e "  ${Y}${BOLD}[DRY RUN — no changes will be made]${N}\n"

# ── Helpers ──────────────────────────────────────────────────
REPO_URL="https://github.com/mint/mini-dots.git"
DOTFILES_DIR="$HOME/.dotfiles"
CONFIG="$HOME/.config"
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"

run() { $DRY_RUN && echo -e "${W}    [dry] $*${N}" || eval "$@"; }

link() {
    local src="$1" dst="$2"
    if $DRY_RUN; then
        echo -e "${W}    [dry] $dst${N}"; return
    fi
    mkdir -p "$(dirname "$dst")"
    if [[ -e "$dst" && ! -L "$dst" ]] && ! $NO_BACKUP; then
        mkdir -p "$BACKUP_DIR"
        cp -r "$dst" "$BACKUP_DIR/" 2>/dev/null || true
    fi
    ln -sfn "$src" "$dst"
    echo -e "    ${W}$dst${N}"
}

pkg_installed() { pacman -Qi "$1" &>/dev/null; }

# ── Clone or update repo ─────────────────────────────────────
section "Repository"
if [[ -d "$DOTFILES_DIR/.git" ]]; then
    info "Repo found at ${W}$DOTFILES_DIR${N} — pulling latest..."
    run git -C "$DOTFILES_DIR" pull --ff-only
    success "Up to date"
else
    info "Cloning ${W}$REPO_URL${N} → $DOTFILES_DIR"
    if ! run git clone --depth=1 "$REPO_URL" "$DOTFILES_DIR"; then
        error "Clone failed. Make sure the repo exists at github.com/mint/mini-dots and you have internet access."
    fi
    success "Cloned"
fi

# ── Package installation ─────────────────────────────────────
REQUIRED_PKGS=(
    hyprland hyprpaper hypridle hyprlock
    waybar wofi kitty
    dunst wlogout
    starship
    ttf-jetbrains-mono-nerd
    noto-fonts noto-fonts-emoji
    grimblast-git
    cliphist wl-clipboard
    brightnessctl
    pipewire wireplumber
    network-manager-applet
    pavucontrol
    bibata-cursor-theme-bin
)

if ! $SKIP_PKGS; then
    section "Packages"
    MISSING=()
    for pkg in "${REQUIRED_PKGS[@]}"; do
        if pkg_installed "$pkg"; then
            info "${W}ok${N}  $pkg"
        else
            warn "missing  $pkg"
            MISSING+=("$pkg")
        fi
    done

    if [[ ${#MISSING[@]} -gt 0 ]]; then
        echo ""
        read -rp "  Install ${#MISSING[@]} missing package(s) with yay/paru? [Y/n] " ans
        ans="${ans:-Y}"
        if [[ "$ans" =~ ^[Yy]$ ]]; then
            if command -v yay &>/dev/null; then
                run yay -S --needed --noconfirm "${MISSING[@]}"
            elif command -v paru &>/dev/null; then
                run paru -S --needed --noconfirm "${MISSING[@]}"
            else
                error "No AUR helper found. Install yay or paru first:\n  https://github.com/Jguer/yay"
            fi
            success "Packages installed"
        else
            warn "Skipping — some things may not work correctly"
        fi
    else
        success "All packages present"
    fi
fi

# ── Backup notice ────────────────────────────────────────────
if ! $DRY_RUN && ! $NO_BACKUP; then
    section "Backup"
    info "Existing configs will be backed up to:"
    echo "    $BACKUP_DIR"
fi

# ── Linking configs ──────────────────────────────────────────
section "Hyprland"
link "$DOTFILES_DIR/hypr/hyprland.conf"  "$CONFIG/hypr/hyprland.conf"
link "$DOTFILES_DIR/hypr/hyprpaper.conf" "$CONFIG/hypr/hyprpaper.conf"
link "$DOTFILES_DIR/hypr/hypridle.conf"  "$CONFIG/hypr/hypridle.conf"
success "Done"

section "Waybar"
link "$DOTFILES_DIR/waybar/config.jsonc" "$CONFIG/waybar/config.jsonc"
link "$DOTFILES_DIR/waybar/style.css"    "$CONFIG/waybar/style.css"
success "Done"

section "Wofi"
link "$DOTFILES_DIR/wofi/config"    "$CONFIG/wofi/config"
link "$DOTFILES_DIR/wofi/style.css" "$CONFIG/wofi/style.css"
success "Done"

section "Kitty"
link "$DOTFILES_DIR/kitty/kitty.conf" "$CONFIG/kitty/kitty.conf"
success "Done"

section "Starship"
link "$DOTFILES_DIR/shell/starship.toml" "$CONFIG/starship.toml"
success "Done"

# ── Shell rc ─────────────────────────────────────────────────
section "Shell"
SHELL_RC=""
[[ "$SHELL" == *zsh*  ]] && SHELL_RC="$HOME/.zshrc"
[[ "$SHELL" == *bash* ]] && SHELL_RC="$HOME/.bashrc"

if [[ -n "$SHELL_RC" ]]; then
    if ! grep -q "starship init" "$SHELL_RC" 2>/dev/null; then
        if ! $DRY_RUN; then
            {
                echo ""
                echo "# starship prompt — mini-dots"
                echo 'export STARSHIP_CONFIG="$HOME/.config/starship.toml"'
                echo 'eval "$(starship init $(basename $SHELL))"'
            } >> "$SHELL_RC"
        else
            echo -e "${W}    [dry] append starship init to $SHELL_RC${N}"
        fi
        success "Starship init added to ${W}$SHELL_RC${N}"
    else
        info "Starship already present in $SHELL_RC"
    fi
else
    warn "Could not detect shell rc — add manually:"
    echo '    export STARSHIP_CONFIG="$HOME/.config/starship.toml"'
    echo '    eval "$(starship init $(basename $SHELL))"'
fi

# ── Wallpaper dir ────────────────────────────────────────────
section "Wallpaper"
WALL_DIR="$HOME/Pictures/wallpapers"
if [[ ! -d "$WALL_DIR" ]]; then
    run mkdir -p "$WALL_DIR"
    success "Created $WALL_DIR"
fi
[[ ! -f "$WALL_DIR/wall.png" ]] \
    && warn "Add a wallpaper at ${W}$WALL_DIR/wall.png${N}" \
    || success "Wallpaper found"

# ── Reload ───────────────────────────────────────────────────
section "Reloading"
if ! $DRY_RUN; then
    if hyprctl version &>/dev/null 2>&1; then
        hyprctl reload && success "Hyprland reloaded"
        pkill waybar 2>/dev/null || true
        sleep 0.4
        waybar &>/dev/null & disown
        success "Waybar restarted"
    else
        info "Hyprland not running — configs apply on next login"
    fi
else
    echo -e "${W}    [dry] hyprctl reload${N}"
    echo -e "${W}    [dry] restart waybar${N}"
fi

# ── Done ─────────────────────────────────────────────────────
echo ""
echo -e "${G}${BOLD}  ✓ All done!${N}"
echo ""
[[ -d "$BACKUP_DIR" ]] && echo -e "  Backup:       ${W}$BACKUP_DIR${N}"
[[ -n "$SHELL_RC"   ]] && echo -e "  Reload shell: ${C}source $SHELL_RC${N}"
echo -e "  Repo:         ${C}$DOTFILES_DIR${N}"
echo ""

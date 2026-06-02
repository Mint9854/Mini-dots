k#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers"
selected=$(ls -1 "$WALLPAPER_DIR" | wofi --dmenu --prompt "Select Wallpaper")

if [ -n "$selected" ]; then
    # Set the actual wallpaper
    awww img "$WALLPAPER_DIR/$selected" --transition-type none

    # Generate colors
    wallust run "$WALLPAPER_DIR/$selected"
    
    # Reload Waybar
    killall waybar && waybar &
fi

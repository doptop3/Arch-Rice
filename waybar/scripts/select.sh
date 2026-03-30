#!/bin/bash
WAYBAR_DIR="$HOME/.config/waybar"
STYLECSS="$WAYBAR_DIR/style.css"
CONFIG="$WAYBAR_DIR/config"
ASSETS="$WAYBAR_DIR/assets"
THEMES="$WAYBAR_DIR/themes"

menu() {
    find "${ASSETS}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) | awk '{print "img:"$0}'
}

main() {
    choice=$(menu | wofi -c ~/.config/wofi/waybar -s ~/.config/wofi/style-waybar.css --show dmenu --prompt " Select Waybar (Scroll with Arrows)" -n) || return
    selected_wallpaper=$(echo "$choice" | sed 's/^img://')
    echo $selected_wallpaper

    case "$selected_wallpaper" in
        "$ASSETS/experimental.png")
            cp "$THEMES/experimental/style-experimental.css" "$STYLECSS"
            cp "$THEMES/experimental/config-experimental" "$CONFIG"
            ;;
        "$ASSETS/main.png")
            cp "$THEMES/default/style-default.css" "$STYLECSS"
            cp "$THEMES/default/config-default.jsonc" "$CONFIG"
            ;;
        "$ASSETS/line.png")
            cp "$THEMES/line/style-line.css" "$STYLECSS"
            cp "$THEMES/line/config-line" "$CONFIG"
            ;;
        "$ASSETS/zen.png")
            cp "$THEMES/zen/style-zen.css" "$STYLECSS"
            cp "$THEMES/zen/config-zen" "$CONFIG"
            ;;
        *)
            echo "Unknown selection"
            return
            ;;
    esac

    pkill waybar && waybar &
}
main

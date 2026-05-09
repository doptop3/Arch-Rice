#!/bin/bash
WALLPAPER_DIR="$HOME/wallpapers"
CAVA_CONFIG="$HOME/.config/cava/config"
#I dont know what the fuck I am doing | neither do i...
menu() {
    find "${WALLPAPER_DIR}" -not -path '*/.*' -xtype f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) | sort -u | awk '{print "img:"$0}'
}
main() {
    choice=$(menu | wofi -c ~/.config/wofi/wallpaper -s ~/.config/wofi/style-wallpaper.css --show dmenu --prompt "Select Wallpaper:" -n)

    [[ -z "$choice" ]] && exit
    selected_wallpaper=$(echo "$choice" | sed 's/^img://')

    awww img "$selected_wallpaper" --transition-type any --transition-fps 60 --transition-duration .4
    wal -s -t -i "$selected_wallpaper" -n --cols16

    # reload sway-services (notifications)
    pkill swayosd-server
    swayosd-server &
    swaync-client --reload-css

    # update terminal - IF YOU WANT TO GO AHEAD, this will end in all the kitty terminal colours being replaced by your background through a shaky mapping of pywal using 15 colours taken from wallpaper, this is waaaay too simple since primary background colours that are more black makes the text show the same way which makes reading the text practically impossible.. (instead just run in terminal: kitty +kitten themes)  
    # cat ~/.cache/wal/colors-kitty.conf > ~/.config/kitty/current-theme.conf
    
    # colour matching
    color1=$(sed -n "s/^color2='\(.*\)'/\1/p" ~/.cache/wal/colors.sh)
    color2=$(sed -n "s/^color3='\(.*\)'/\1/p" ~/.cache/wal/colors.sh)

    sed -i "s/^gradient_color_1 = .*/gradient_color_1 = '$color1'/" $CAVA_CONFIG
    sed -i "s/^gradient_color_2 = .*/gradient_color_2 = '$color2'/" $CAVA_CONFIG
    pkill -USR2 cava 2>/dev/null
}
main


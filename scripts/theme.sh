#!/usr/bin/env bash

THEMES_DIR="$HOME/themes"

BLACKWHITE_ICON="$HOME/scripts/blackwhite.jpg"
COLOR_ICON="$HOME/scripts/colorful.jpg"

if [[ -n "$1" ]]; then
    SELECTED_THEME="$1"
else
    themes=(
        "BlackWhite\0icon\x1f${BLACKWHITE_ICON}"
        "Colorful\0icon\x1f${COLOR_ICON}"
    )
    SELECTED_THEME=$(printf "%b\n" "${themes[@]}" | rofi -dmenu -p "Theme Selector")
fi

if [[ -n "$SELECTED_THEME" ]]; then
    mkdir -p "$HOME/.config/dunst" "$HOME/.config/hypr" "$HOME/.config/kitty" "$HOME/.config/rofi" "$HOME/.config/waybar"

    if [[ "$SELECTED_THEME" == "BlackWhite" ]]; then
        BLACKWHITE_THEME_DIR="$HOME/themes/blackwhite"

        cp -f "$BLACKWHITE_THEME_DIR/dunstrc" "$HOME/.config/dunst/dunstrc"
        cp -f "$BLACKWHITE_THEME_DIR/hypr.lua" "$HOME/.config/hypr/colors.lua"
        cp -f "$BLACKWHITE_THEME_DIR/hypr.conf" "$HOME/.config/hypr/colors.conf"
        cp -f "$BLACKWHITE_THEME_DIR/kitty.conf" "$HOME/.config/kitty/current-theme.conf"
        cp -f "$BLACKWHITE_THEME_DIR/rofi.rasi" "$HOME/.config/rofi/colors.rasi"
        cp -f "$BLACKWHITE_THEME_DIR/waybar.css" "$HOME/.config/waybar/colors.css"

        if [[ -n "$DISPLAY" || -n "$WAYLAND_DISPLAY" ]]; then
            dunstify "Theme Selector" "$SELECTED_THEME theme selected" -i "$BLACKWHITE_ICON"
        fi

    elif [[ "$SELECTED_THEME" == "Colorful" ]]; then
        COLORFUL_THEME_DIR="$HOME/themes/colorful"

        if [[ ! -d "$COLORFUL_THEME_DIR" ]]; then
            echo "Fehler: Matugen-Cache existiert nicht. Bitte erst Wallpaper setzen!"
            exit 1
        fi

        cp -f "$COLORFUL_THEME_DIR/dunstrc" "$HOME/.config/dunst/dunstrc"
        cp -f "$COLORFUL_THEME_DIR/hypr.lua" "$HOME/.config/hypr/colors.lua"
        cp -f "$COLORFUL_THEME_DIR/hypr.conf" "$HOME/.config/hypr/colors.conf"
        cp -f "$COLORFUL_THEME_DIR/kitty.conf" "$HOME/.config/kitty/current-theme.conf"
        cp -f "$COLORFUL_THEME_DIR/rofi.rasi" "$HOME/.config/rofi/colors.rasi"
        cp -f "$COLORFUL_THEME_DIR/waybar.css" "$HOME/.config/waybar/colors.css"

        if [[ -n "$DISPLAY" || -n "$WAYLAND_DISPLAY" ]]; then
            dunstify "Theme Selector" "$SELECTED_THEME theme selected" -i "$COLOR_ICON"
        fi
    fi

    if [[ -n "$DISPLAY" || -n "$WAYLAND_DISPLAY" ]]; then
        dunstctl reload
        kitty +kitten themes --reload-in=all
        spicetify watch -s 2>&1 | sed "/Reloaded Spotify/q"
        pkill -SIGUSR2 waybar
    fi
fi

#!/usr/bin/env bash

TERMINAL="kitty"

if [ "$1" != "--run-in-terminal" ]; then
    $TERMINAL --class "update-terminal" -- "$0" --run-in-terminal
    exit 0
fi

echo "Prüfe ausstehende Updates parallel..."

tmp_official=$(mktemp)
tmp_aur=$(mktemp)
tmp_fw=$(mktemp)

cleanup() {
    rm -f "$tmp_official" "$tmp_aur" "$tmp_fw"
}
trap cleanup EXIT

checkupdates > "$tmp_official" 2>/dev/null &
pid_official=$!

yay -Qua --color=never --noconfirm > "$tmp_aur" 2>/dev/null &
pid_aur=$!

fwupdmgr get-updates --json > "$tmp_fw" 2>/dev/null &
pid_fw=$!

wait $pid_official $pid_aur $pid_fw

official_updates=$(cat "$tmp_official")
aur_updates=$(cat "$tmp_aur")
fw_json=$(cat "$tmp_fw")

count_pacman=$(echo "$official_updates" | grep -c '^' 2>/dev/null)
count_pacman=${count_pacman:-0}

count_aur=$(echo "$aur_updates" | grep -c '^' 2>/dev/null)
count_aur=${count_aur:-0}

if [ -n "$fw_json" ] && echo "$fw_json" | jq . >/dev/null 2>&1; then
    count_fw=$(echo "$fw_json" | jq -r '.Devices[].Name' 2>/dev/null | grep -c '^')
    count_fw=${count_fw:-0}
else
    count_fw=0
fi

total_pkgs=$((count_pacman + count_aur))

clear

if [ "$total_pkgs" -gt 0 ] && [ "$count_fw" -gt 0 ]; then
    echo "=== Starte System- und Firmware-Updates ==="
    yay -Syu
    echo -e "\n=== Systempakete bereit. Starte Firmware-Update ==="
    fwupdmgr refresh && fwupdmgr update

elif [ "$total_pkgs" -gt 0 ]; then
    echo "=== Starte System-Updates ($total_pkgs Pakete) ==="
    yay -Syu

elif [ "$count_fw" -gt 0 ]; then
    echo "=== Starte Firmware-Updates ($count_fw Geräte) ==="
    fwupdmgr refresh && fwupdmgr update

else
    echo "System und Firmware sind bereits auf dem neuesten Stand."
fi

pkill -RTMIN+8 waybar 2>/dev/null

echo -e "\nDrücke Enter zum Schließen..."
read -r

#!/bin/bash

# Wallpaper folder
WALLPAPER_DIR="/home/bleezie/Pictures/wallpapers"

# Get all jpg/png files into array
WALLPAPER_LIST=($(find "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.png' \) | sort))
COUNT=${#WALLPAPER_LIST[@]}

# Bail if no wallpapers
if [ "$COUNT" -eq 0 ]; then
    notify-send "No wallpapers found!"
    exit 1
fi

# Index file
INDEX_FILE="$HOME/.cache/wall_index"
[ -f "$INDEX_FILE" ] || echo 0 > "$INDEX_FILE"
INDEX=$(cat "$INDEX_FILE")

# Wraparound
if [ "$INDEX" -ge "$COUNT" ]; then
    INDEX=0
fi

# Pick next wallpaper
WALLPAPER="${WALLPAPER_LIST[$INDEX]}"
NEXT_INDEX=$(( (INDEX + 1) % COUNT ))
echo "$NEXT_INDEX" > "$INDEX_FILE"

# Fast transition (lower step = quicker)
swww img "$WALLPAPER" --transition-type wipe --transition-step 30 --transition-fps 60

# Wait before setting colors so it grabs the new image
sleep 1

# Apply pywal colors without setting wallpaper
wal -n -i "$WALLPAPER"

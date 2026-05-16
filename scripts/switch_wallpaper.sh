#!/bin/bash
set -euo pipefail

# Wallpaper folder. Override with WALLPAPER_DIR=/path/to/wallpapers if needed.
WALLPAPER_DIR="${WALLPAPER_DIR:-$HOME/Pictures/wallpapers}"
CACHE_DIR="$HOME/.cache"
INDEX_FILE="$CACHE_DIR/wall_index"
TRANSITION_DURATION="${TRANSITION_DURATION:-0.8}"
PYWAL_DELAY="${PYWAL_DELAY:-0.9}"

mkdir -p "$CACHE_DIR"

# Get all wallpaper files into an array, safely handling spaces in filenames.
mapfile -d '' WALLPAPER_LIST < <(
  find "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) -print0 | sort -z
)
COUNT=${#WALLPAPER_LIST[@]}

# Bail if no wallpapers exist.
if [ "$COUNT" -eq 0 ]; then
  notify-send "Wallpaper switcher" "No wallpapers found in $WALLPAPER_DIR"
  exit 1
fi

# Start swww if Hyprland did not already autostart it.
if ! swww query >/dev/null 2>&1; then
  swww-daemon >/tmp/swww-daemon.log 2>&1 &
  sleep 0.8
fi

# Read the saved wallpaper index and reset it if it is invalid.
if [ ! -f "$INDEX_FILE" ] || ! [[ "$(cat "$INDEX_FILE")" =~ ^[0-9]+$ ]]; then
  echo 0 > "$INDEX_FILE"
fi
INDEX=$(cat "$INDEX_FILE")

# Wrap around if wallpapers were added/removed.
if [ "$INDEX" -ge "$COUNT" ]; then
  INDEX=0
fi

# Pick the next wallpaper and save the following index for next time.
WALLPAPER="${WALLPAPER_LIST[$INDEX]}"
NEXT_INDEX=$(( (INDEX + 1) % COUNT ))
echo "$NEXT_INDEX" > "$INDEX_FILE"

# Change wallpaper first, then wait for the transition before applying pywal colors.
swww img "$WALLPAPER" \
  --transition-type wipe \
  --transition-duration "$TRANSITION_DURATION" \
  --transition-fps 60
sleep "$PYWAL_DELAY"

# Apply pywal colors without trying to set the wallpaper a second time.
wal -n -i "$WALLPAPER"

# Refresh Waybar so it picks up pywal-generated colors immediately.
if pgrep -x waybar >/dev/null; then
  pkill -SIGUSR2 waybar || true
fi

notify-send "Wallpaper switched" "Theme synced from $(basename "$WALLPAPER")"

#!/bin/bash
set -euo pipefail

# --- check if user is non root ---
if [ "$EUID" -eq 0 ]; then
  echo "--- !!!ONLY RUN AS NON ROOT!!! ---"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/config"
WALLPAPER_DIR="$SCRIPT_DIR/wallpapers"

PACKAGES=(
  hyprland
  thunar
  kitty
  rofi
  swww
  python-pywal
  fish
  waybar
  swaync
  grim
  slurp
  wl-clipboard
  libnotify
)

# --- install packages ---
echo "--- installing packages ---"
sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"
pacman -Q "${PACKAGES[@]}"
echo "--- done installing packages ---"
sleep 0.25

# --- change shell to fish after fish is installed ---
setup_fish_shell() {
  local fish_path
  fish_path="$(command -v fish)"

  if ! grep -Fxq "$fish_path" /etc/shells; then
    echo "--- adding $fish_path to /etc/shells ---"
    echo "$fish_path" | sudo tee -a /etc/shells >/dev/null
  fi

  local current_shell
  current_shell="$(getent passwd "$USER" | cut -d: -f7)"

  if [ "$current_shell" = "$fish_path" ]; then
    echo "--- fish is already your login shell ---"
  else
    echo "--- changing login shell to fish: $fish_path ---"
    chsh -s "$fish_path" "$USER"
  fi
}

setup_fish_shell
sleep 0.25

# --- copy dotfiles into ~/.config ---
echo "--- copying config files ---"
mkdir -p "$HOME/.config"
for app in fish hypr kitty neofetch rofi waybar; do
  cp -r "$CONFIG_DIR/$app" "$HOME/.config/"
done

# --- copy pictures into wallpaper folder ---
echo "--- copying wallpapers into wallpaper folder ---"
mkdir -p "$HOME/Pictures"
cp -r "$WALLPAPER_DIR" "$HOME/Pictures/"
echo "--- done copying files ---"
sleep 1

# --- make scripts executable ---
echo "--- making scripts executable ---"
chmod +x "$SCRIPT_DIR"/scripts/*.sh

echo "--- finished setup---"

# --- launch hyprland and apps ---
echo "--- launching hyprland and apps ---"
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
mkdir -p "$XDG_RUNTIME_DIR"

if ! pgrep -x Hyprland >/dev/null && ! pgrep -x hyprland >/dev/null; then
  Hyprland &
else
  echo "--- hyprland is already running ---"
fi

sleep 2
if ! swww query >/dev/null 2>&1; then
  swww-daemon &
  sleep 1
fi

"$SCRIPT_DIR/scripts/switch_wallpaper.sh"

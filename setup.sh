#!/bin/bash

# --- check if user is non root ---
if [ "SEUID" -eq 0 ]; then
  echo "--- !!!ONLY RUN AS NON ROOT!!! ---"
  exit 1
fi

# --- install packages ---
echo "--- installing basic packages ---"
sudo pacman -S --needed --noconfirm hyprland
pacman -Q hyprland
echo "-hyprland installed-"
sleep 1

sudo pacman -S --needed --noconfirm thunar
pacman -Q thunar
echo "-thunar installed-"
sleep 1

sudo pacman -S --needed --noconfirm kitty
pacman -Q kitty
echo "-kitty installed-"
sleep 1

sudo pacman -S --needed --noconfirm rofi
pacman -Q rofi
echo "-rofi installed-"
sleep 1

sudo pacman -S --needed --noconfirm swww
pacman -Q swww
echo "-swww installed-"
sleep 1

sudo pacman -S --needed --noconfirm python-pywal
pacman -Q python-pywal
echo "-pywal installed-"
sleep 1

sudo pacman -S --needed --noconfirm fish
pacman -Q fish
echo "-fish installed-"
sleep 1

sudo pacman -S --needed --noconfirm waybar
pacman -Q waybar
echo "-waybar installed-"
echo "--- done installing basic packages ---"
sleep 1

# --- copy dotfiles into ~/.config ---
echo "--- copying config files ---"
cp -r ./config/fish ~/.config/
cp -r ./config/hypr ~/.config/
cp -r ./config/kitty ~/.config/
cp -r ./config/neofetch ~/.config/
cp -r ./config/rofi ~/.config/
cp -r ./config/waybar ~/.config/

# --- copy pictures into wallpaper folder
echo "--- copying wallpapers into wallpaper folder ---"
mkdir -p ~/Pictures/wallpapers
cp -r ./wallpapers ~/Pictures/wallpapers
echo "--- done copying files ---"
sleep 1

# --- make scripts executable ---
echo "--- making scripts executable ---"
chmod +x ./scripts/*.sh

echo "--- finished setup---"

# --- launch hyprland and apps ---"
echo "--- launching hyprland and apps ---"
  export XDG_RUNTIME_DIR="/run/user/$(id -u)"
  mkdir -p "$XDG_RUNTIME_DIR"

if ! pgrep -x hyprland > /dev/null; then
  hyprland --in-its-own-namespace &
else
  echo "--- hyprland is already running ---"
fi

sleep 2

chsh -s /bin/fish
swww daemon &
sleep 1
swww img ~/Pictures/wallpapers/wallpaper.jpg
wal -i ~/Pictures/wallpapers/wallpaper.jpg

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
sudo pacman -S --needed --noconfirm thunar
pacman -Q thunar
echo "-thunar installed-"
sudo pacman -S --needed --noconfirm kitty
pacman -Q kitty
echo "-kitty installed-"
sudo pacman -S --needed --noconfirm rofi
pacman -Q rofi
echo "-rofi installed-"
sudo pacman -S --needed --noconfirm swww
pacman -Q swww
echo "-swww installed-"
sudo pacman -S --needed --noconfirm python-pywal
pacman -Q python-pywal
echo "-pywal installed-"
sudo pacman -S --needed --noconfirm fish
pacman -Q fish
echo "-fish installed-"
sudo pacman -S --needed --noconfirm waybar
pacman -Q waybar
echo "-waybar installed-"
echo "--- done installing basic packages ---"

# --- copy dotfiles into ~/.config ---
echo "--- copying config files ---"
cp -r ~/dotfiles/config/fish ~/.config/
cp -r ~/dotfiles/config/hypr ~/.config/
cp -r ~/dotfiles/config/kitty ~/.config/
cp -r ~/dotfiles/config/neofetch ~/.config/
cp -r ~/dotfiles/config/rofi ~/.config/
cp -r ~/dotfiles/config/waybar ~/.config/

# --- copy pictures into wallpaper folder
echo "--- copying wallpapers into wallpaper folder ---"
mkdir -p ~/Pictures/wallpapers
cp -r ~/dotfiles/wallpapers ~/Pictures/wallpapers

# --- make scripts executable ---
echo "--- making scripts executable ---"
chmod +x ~/dotfiles/scripts/*.sh

echo "--- finished setup---"

# --- launch hyprland and apps ---"
echo "--- launching hyprland and apps ---
if [ -z "XDG_RUNTIME_DIR" ]; then
  export XDG_RUNTIME_DIR="/run/user/$(id -u)"
  mkdir -p "$XDG_RUNTIME_DIR"
fi

if ! pgrep -x hyprland > /dev/null; then
  hyprland --in-its-own-namespace &
else
  echo "--- hyprland is already running ---"
fi

sleep 2

chsh -S /bin/fish
swww init && swww img ~/Pictures/wallpapers/wallpaper.jpg
wal -i ~/Pictures/wallpapers/wallpaper.jpg

#!/bin/bash

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

# --- clone dotfiles ---
echo "--- cloning dotfiles into ~/dotfiles ---"
git clone https://github.com/bIeezie/bleezies-dotfiles.git ~/dotfiles

# --- copy dotfiles into ~/.config ---
echo "--- copying config files ---"
cp -r ~/dotfiles/config/fish ~/.config/
cp -r ~/dotfiles/config/hypr ~/.config/
cp -r ~/dotfiles/config/kitty ~/.config/
cp -r ~/dotfiles/config/neofetch ~/.config/
cp -r ~/dotfiles/config/rofi ~/.config/
cp -r ~/dotfiles/config/waybar ~/.config/

# --- make scripts executable ---
echo "--- making scripts executable ---"
chmod +x ~/dotfiles/scripts/*.sh

echo "--- finished ---"

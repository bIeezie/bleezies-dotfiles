#!/bin/bash

# --- install packages ---
echo "--- installing basic packages ---"
sudo pacman -S --needed --noconfirm hyprland
sudo pacman -S --needed --noconfirm thunar
sudo pacman -S --needed --noconfirm kitty
sudo pacman -S --needed --noconfirm rofi
sudo pacman -S --needed --noconfirm swww
sudo pacman -S --needed --noconfirm python-pywal
sudo pacman -S --needed --noconfirm fish
sudo pacman -S --needed --noconfirm waybar
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

#!/bin/bash

# --- basics ---
echo "--- installing basic packages... ---"
sudo pacman -S --needed --noconfirm hyprland thunar kitty rofi swww python-pywal fish git neofetch waybar
echo "--- done installing basic packages ---"

# --- clone dotfiles ---
echo "--- cloning dotfiles into .config---"
git clone https://github.com/bIeezie/bleezies-dotfiles.git ~/dotfiles

# --- copy dotfiles into .config ---
cp -r ~/dotfiles/config/fish ~/.config/
cp -r ~/dotfiles/config/hypr ~/.config/
cp -r ~/dotfiles/config/kitty ~/.config/
cp -r ~/dotfiles/config/neofetch ~/.config/
cp -r ~/dotfiles/config/rofi ~/.config/
cp -r ~/dotfiles/config/waybar ~/.config/
echo "--- done cloning files ---"

# --- make scripts executable ---
chmod +x ~/scripts/*.sh

echo "--- finished ---"

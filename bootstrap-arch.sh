#!/usr/bin/env bash

# Deploys the environment in arch and derivatives
sudo pacman --needed --noconfirm -S git zsh neovim ranger slock qutebrowser dmenu keychain udiskie compton playerctl rxvt-unicode pasystray blueman i3status feh the_silver_searcher entr mupdf mupdf-tools dunst
yay --noconfirm -S mons i3-gaps pa-applet-git terminus-font-ttf

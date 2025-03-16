#!/bin/bash
# update_neovim_repo.sh
#
# This script copies your init.vim and lua folder from
# ~/.config/nvim to your repository at ~/Repos/neovim_config,
# overwriting the repo version.
#
# Source directory
SRC="$HOME/.config/nvim"
# Destination repository directory
DEST="$HOME/Repos/neovim_config"

echo "Updating repository with init.vim and lua folder from $SRC..."

# Copy init.vim into the neovim_files folder of your repository
if [ -f "$SRC/init.vim" ]; then
  cp -f "$SRC/init.vim" "$DEST/neovim_files/init.vim"
  echo "Copied init.vim to $DEST/neovim_files/"
else
  echo "Error: $SRC/init.vim not found."
fi

# Copy the lua folder recursively, overwriting existing files
if [ -d "$SRC/lua" ]; then
  # Using rsync for a robust directory copy.
  rsync -av --delete "$SRC/lua/" "$DEST/lua/"
  echo "Copied lua folder to $DEST/lua/"
else
  echo "Error: $SRC/lua directory not found."
fi

echo "Repository update complete."

#!/bin/bash
# update_neovim_repo.sh

# Enable nullglob so that non-matching globs expand to nothing.
shopt -s nullglob

# Source directories
NVIM_SRC="$HOME/.config/nvim"
CLANG_SRC="$HOME/lc"

# Destination repository directory
DEST="$HOME/Repos/neovim_config"

echo "Updating repository with init.vim and lua folder from $NVIM_SRC..."

# Copy init.vim into the neovim_files folder of your repository
if [ -f "$NVIM_SRC/init.vim" ]; then
  cp -f "$NVIM_SRC/init.vim" "$DEST/neovim_files/init.vim"
  echo "Copied init.vim to $DEST/neovim_files/"
else
  echo "Error: $NVIM_SRC/init.vim not found."
fi

# Copy the lua folder recursively, overwriting existing files
if [ -d "$NVIM_SRC/lua" ]; then
  # Using rsync for a robust directory copy.
  rsync -av --delete "$NVIM_SRC/lua/" "$DEST/lua/"
  echo "Copied lua folder to $DEST/lua/"
else
  echo "Error: $NVIM_SRC/lua directory not found."
fi

# Copy clang configuration files from ~/lc into the repository
if [ -d "$CLANG_SRC" ]; then
  echo "Updating repository with clang files from $CLANG_SRC..."
  for file in "$CLANG_SRC"/.clang*; do
    if [ -f "$file" ]; then
      cp -f "$file" "$DEST/"
      echo "Copied $(basename "$file") to $DEST/"
    fi
  done
else
  echo "Error: $CLANG_SRC directory not found."
fi

echo "Repository update complete."


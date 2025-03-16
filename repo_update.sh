#!/bin/bash

# Enable nullglob so that non-matching globs expand to nothing.
shopt -s nullglob

# Source directories
NVIM_SRC="$HOME/.config/nvim"
CLANG_SRC="$HOME/lc"
# Destination repository directory
DEST="$HOME/Repos/neovim_config"
CLANG_DEST="$DEST/clang_files"

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
  rsync -av --delete "$NVIM_SRC/lua/" "$DEST/lua/"
  echo "Copied lua folder to $DEST/lua/"
else
  echo "Error: $NVIM_SRC/lua directory not found."
fi

# Ensure that the clang_files directory exists in the destination
if [ ! -d "$CLANG_DEST" ]; then
  mkdir -p "$CLANG_DEST"
  echo "Created directory $CLANG_DEST"
fi

# Copy clang configuration files from ~/lc into the clang_files folder in the repository
if [ -d "$CLANG_SRC" ]; then
  echo "Updating repository with clang files from $CLANG_SRC..."
  for file in "$CLANG_SRC"/.clang*; do
    if [ -f "$file" ]; then
      cp -f "$file" "$CLANG_DEST/"
      echo "Copied $(basename "$file") to $CLANG_DEST/"
    fi
  done
else
  echo "Error: $CLANG_SRC directory not found."
fi

echo "Repository update complete."


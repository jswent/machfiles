#!/bin/bash

# Get user's home directory
USER_DIR="$HOME"
SCRIPTS_DIR="$USER_DIR/Scripts"

# Check if MACHFILES_DIR is set
if [ -z "$MACHFILES_DIR" ]; then
  echo "Error: MACHFILES_DIR environment variable is not set"
  echo "Please set MACHFILES_DIR to point to your machfiles repository root"
  exit 1
fi

SOURCE_SCRIPTS_DIR="$MACHFILES_DIR/scripts"

# Check if Scripts directory exists and is not a symbolic link
if [ -d "$SCRIPTS_DIR" ] && [ ! -L "$SCRIPTS_DIR" ]; then
  echo "Scripts directory exists, creating individual script links..."

  # Iterate through each script in the source directory
  for script in "$SOURCE_SCRIPTS_DIR"/*; do
    if [ -f "$script" ]; then
      script_name=$(basename "$script")
      target_path="$SCRIPTS_DIR/$script_name"

      # Remove existing link or backup existing file
      if [ -L "$target_path" ]; then
        rm -f "$target_path"
      elif [ -f "$target_path" ]; then
        mv -f "$target_path" "$target_path.bak"
      fi

      # Create symbolic link
      ln -s "$script" "$target_path"
      echo "Created link for $script_name"
    fi
  done
else
  echo "Creating Scripts directory link..."

  # Remove existing link or backup existing directory
  if [ -L "$SCRIPTS_DIR" ]; then
    rm -f "$SCRIPTS_DIR"
  elif [ -d "$SCRIPTS_DIR" ]; then
    mv -f "$SCRIPTS_DIR" "$SCRIPTS_DIR.bak"
  fi

  # Create symbolic link to entire scripts directory
  ln -s "$SOURCE_SCRIPTS_DIR" "$SCRIPTS_DIR"
  echo "Created link to Scripts directory"
fi


#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open in Neovim (WezTerm)
# @raycast.mode silent

# Optional parameters:
# @raycast.icon images/neovim.png
# @raycast.packageName Developer Utils
# @raycast.argument1 { "type": "text", "placeholder": "Repository path" }

INPUT_PATH="$1"

# Handle tilde expansion manually
if [[ $INPUT_PATH == ~* ]]; then
  EXPANDED_PATH="${HOME}${INPUT_PATH:1}"
else
  EXPANDED_PATH="$INPUT_PATH"
fi

# Check if the path exists
if [ ! -e "$EXPANDED_PATH" ]; then
  echo "Error: Path does not exist: $EXPANDED_PATH"
  exit 1
fi

# Check if the path is a symlink and resolve it if needed
if [ -L "$EXPANDED_PATH" ]; then
  EXPANDED_PATH=$(readlink -f "$EXPANDED_PATH")
fi

# Function to launch WezTerm and ensure it's focused
launch_wezterm() {
  local cwd="$1"
  local nvim_args="$2"

  wezterm cli spawn --new-window --cwd="$cwd" nvim $nvim_args

  # osascript -e 'tell application "WezTerm" to activate'
}

# Determine working directory and how to open nvim
if [ -f "$EXPANDED_PATH" ]; then
  # It's a file
  FILE_NAME=$(basename "$EXPANDED_PATH")
  PARENT_DIR=$(dirname "$EXPANDED_PATH")

  # Try to find a Git repository
  cd "$PARENT_DIR"
  GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)

  if [ -n "$GIT_ROOT" ]; then
    # Found a Git repository, use it as CWD
    launch_wezterm "$GIT_ROOT" "$EXPANDED_PATH"
  else
    # No Git repository, use parent directory as CWD
    launch_wezterm "$PARENT_DIR" "$EXPANDED_PATH"
  fi
elif [ -d "$EXPANDED_PATH" ]; then
  # It's a directory, use it as CWD
  launch_wezterm "$EXPANDED_PATH" "."
else
  echo "Error: Path is neither a file nor a directory: $EXPANDED_PATH"
  exit 1
fi

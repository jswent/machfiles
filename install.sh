#!/bin/bash

REPO_URL="https://github.com/jswent/machfiles"
VERBOSE=false

# Parse command line arguments
while getopts "v" opt; do
  case $opt in
  v) VERBOSE=true ;;
  esac
done

# Function to print debug messages only in verbose mode
debug_print() {
  if [ "$VERBOSE" = true ]; then
    echo "DEBUG: $1"
  fi
}

# Check if we're running from the repository or standalone
setup_environment() {
  source ./installers/environment.sh
  check_environment
  local env_status=$?

  case $env_status in
  0) # All checks passed
    debug_print "Environment already properly configured"
    ;;
  1) # MACHFILES_DIR set but directory doesn't exist or not a repo
    debug_print "Cloning repository into MACHFILES_DIR: $MACHFILES_DIR"
    git clone "$REPO_URL" "$MACHFILES_DIR"
    ;;
  2) # MACHFILES_DIR not set
    export MACHFILES_DIR="$HOME/machfiles"
    debug_print "Setting MACHFILES_DIR to: $MACHFILES_DIR"

    if [ ! -d "$MACHFILES_DIR" ]; then
      debug_print "Cloning repository into new MACHFILES_DIR"
      git clone "$REPO_URL" "$MACHFILES_DIR"
    fi

    # Handle environment variable persistence
    if [ -n "$ZSH" ] && [ -d "$ZSH" ]; then
      # Create snippets directory if it doesn't exist
      mkdir -p "$ZSH/snippets"

      if ! grep -q "export MACHFILES_DIR" "$ZSH/snippets/env.zsh" 2>/dev/null; then
        echo "export MACHFILES_DIR=$MACHFILES_DIR" >>"$ZSH/snippets/env.zsh"
        debug_print "Added MACHFILES_DIR to $ZSH/snippets/env.zsh"
      fi
    else
      # Determine current shell
      current_shell=$(basename "$SHELL")
      rc_file="$HOME/.${current_shell}rc"

      echo "Warning: ZSH environment not configured."
      echo "Please add the following line to your $rc_file:"
      echo "    export MACHFILES_DIR=$MACHFILES_DIR"
    fi
    ;;
  esac

  # Ensure we're in the right directory
  cd "$MACHFILES_DIR"
}

# Source the installer scripts
source ./installers/dark-mode-notify.sh
# source other installers...

# Call setup_environment before showing menu
setup_environment

show_menu() {
  echo "1) Install everything"
  echo "2) Install dark-mode-notify"
  # other options...
  echo "q) Quit"
}

handle_choice() {
  case "$1" in
  1)
    # Install everything
    install_dark_mode_notify || echo "Failed to install dark-mode-notify"
    # other installations...
    ;;
  2)
    install_dark_mode_notify || echo "Failed to install dark-mode-notify"
    ;;
  q)
    exit 0
    ;;
  *)
    echo "Invalid option"
    ;;
  esac
}

# Main menu loop
while true; do
  show_menu
  read -p "Choose an option: " choice
  handle_choice "$choice"
done


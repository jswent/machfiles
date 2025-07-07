#!/bin/bash

install_zsh() {
  # Check if MACHFILES_DIR is set
  if [ -z "$MACHFILES_DIR" ]; then
    echo "Error: MACHFILES_DIR environment variable is not set"
    echo "Please set MACHFILES_DIR to point to your machfiles repository root"
    return 1
  fi

  # Check if zsh config is already installed
  if [ -L "$HOME/.zshrc" ] && [ "$(readlink "$HOME/.zshrc")" = "$MACHFILES_DIR/.zshrc" ]; then
    debug_print "Zsh config already installed"
    return 0
  fi


  debug_print "Starting zsh installation"

  # Handle existing .zshrc
  if [ -L "$HOME/.zshrc" ]; then
    debug_print "Removing existing .zshrc symlink"
    rm -f "$HOME/.zshrc"
  elif [ -f "$HOME/.zshrc" ]; then
    # Find available backup name
    backup_name="$HOME/.zshrc.old"
    counter=1
    while [ -f "$backup_name" ]; do
      backup_name="$HOME/.zshrc.old.$counter"
      counter=$((counter + 1))
    done
    
    debug_print "Existing .zshrc found, moving to $backup_name"
    mv "$HOME/.zshrc" "$backup_name"
  fi

  # Create .zshrc symlink
  debug_print "Creating .zshrc symlink"
  ln -s "$MACHFILES_DIR/.zshrc" "$HOME/.zshrc"

  # Initialize zsh shell
  debug_print "Initializing zsh shell"
  zsh -c "source ~/.zshrc"

  debug_print "Zsh installation complete"
}

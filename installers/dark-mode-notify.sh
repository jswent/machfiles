#!/bin/bash

install_dark_mode_notify() {
  # Check if MACHFILES_DIR is set
  if [ -z "$MACHFILES_DIR" ]; then
    echo "Error: MACHFILES_DIR environment variable is not set"
    echo "Please set MACHFILES_DIR to point to your machfiles repository root"
    return 1
  fi

  debug_print "Starting dark-mode-notify installation..."

  # Check if dark-mode-notify is already installed
  if [ -f "/usr/local/bin/dark-mode-notify" ]; then
    debug_print "Found existing dark-mode-notify installation"
    echo "dark-mode-notify is already installed at /usr/local/bin/dark-mode-notify"
    echo "Proceeding with LaunchAgent configuration..."
  else
    echo "Installing dark-mode-notify..."

    # Create temporary directory for cloning
    TEMP_DIR=$(mktemp -d)
    debug_print "Created temporary directory: $TEMP_DIR"

    debug_print "Cloning dark-mode-notify repository..."
    git clone https://github.com/bouk/dark-mode-notify "$TEMP_DIR"

    # Build and install
    cd "$TEMP_DIR"
    debug_print "Building dark-mode-notify..."

    # Check if we have write permissions to /usr/local/bin
    if [ ! -w "/usr/local/bin" ]; then
      debug_print "Elevated permissions required for installation"
      echo "This installation requires sudo access to install to /usr/local/bin"
      if ! sudo make install; then
        echo "Error: Failed to install dark-mode-notify"
        rm -rf "$TEMP_DIR"
        return 1
      fi
    else
      if ! make install; then
        echo "Error: Failed to install dark-mode-notify"
        rm -rf "$TEMP_DIR"
        return 1
      fi
    fi
  fi

  # Setup LaunchAgent using shared installer function
  PLIST_SOURCE="$MACHFILES_DIR/LaunchAgents/com.jswent.dark-mode-notify.plist"
  debug_print "Installing LaunchAgent from: $PLIST_SOURCE"

  install_launchagent "$PLIST_SOURCE"
  local launchagent_result=$?

  if [ $launchagent_result -eq 1 ]; then
    echo "Error: Failed to install LaunchAgent"
    [ -d "$TEMP_DIR" ] && rm -rf "$TEMP_DIR"
    return 1
  fi

  # Cleanup with sudo if necessary
  if [ -d "$TEMP_DIR" ]; then
    debug_print "Cleaning up temporary directory: $TEMP_DIR"
    if [ -w "$TEMP_DIR" ]; then
      rm -rf "$TEMP_DIR"
    else
      debug_print "Elevated permissions required for cleanup"
      sudo rm -rf "$TEMP_DIR"
    fi
  fi

  debug_print "Installation completed successfully"
  echo "dark-mode-notify installation complete!"
  return 0
}

# Run the installation if this script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_dark_mode_notify || exit 1
fi

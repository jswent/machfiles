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

  # Setup LaunchAgent
  LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"
  debug_print "Creating LaunchAgents directory: $LAUNCH_AGENTS_DIR"
  mkdir -p "$LAUNCH_AGENTS_DIR"

  # Copy LaunchAgent plist from machfiles to Library/LaunchAgents
  PLIST_SOURCE="$MACHFILES_DIR/LaunchAgents/com.jswent.dark-mode-notify.plist"
  PLIST_DEST="$LAUNCH_AGENTS_DIR/com.jswent.dark-mode-notify.plist"

  debug_print "Checking for LaunchAgent plist at: $PLIST_SOURCE"
  # Verify source plist exists
  if [ ! -f "$PLIST_SOURCE" ]; then
    echo "Error: LaunchAgent plist not found at $PLIST_SOURCE"
    [ -d "$TEMP_DIR" ] && rm -rf "$TEMP_DIR"
    return 1
  fi

  # Flag to track if we need to load/reload the LaunchAgent
  NEED_RELOAD=false

  # Compare files if destination exists
  if [ -f "$PLIST_DEST" ]; then
    debug_print "Comparing existing plist with source"
    if ! cmp -s "$PLIST_SOURCE" "$PLIST_DEST"; then
      debug_print "Plist files differ, updating"
      echo "LaunchAgent plist has changed, updating..."
      cp -f "$PLIST_SOURCE" "$PLIST_DEST"
      NEED_RELOAD=true
    else
      debug_print "Plist files are identical"
      echo "LaunchAgent plist is unchanged"
    fi
  else
    debug_print "No existing plist found, installing new one"
    echo "Installing LaunchAgent plist..."
    cp -f "$PLIST_SOURCE" "$PLIST_DEST"
    NEED_RELOAD=true
  fi

  # Check if LaunchAgent is loaded
  debug_print "Checking LaunchAgent status"
  if ! launchctl list | grep -q "com.jswent.dark-mode-notify"; then
    debug_print "LaunchAgent not loaded, loading now"
    echo "Loading LaunchAgent..."
    launchctl load -w "$PLIST_DEST"
  elif [ "$NEED_RELOAD" = true ]; then
    debug_print "Reloading LaunchAgent due to plist changes"
    echo "Reloading LaunchAgent..."
    launchctl unload "$PLIST_DEST"
    launchctl load -w "$PLIST_DEST"
  else
    debug_print "LaunchAgent already loaded and up to date"
    echo "LaunchAgent is already loaded"
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

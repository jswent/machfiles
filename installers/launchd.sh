#!/bin/bash

# Install a single LaunchAgent from the given plist file
# Args:
#   $1: Path to the plist file to install
# Returns:
#   0 = successfully installed/reloaded (action taken)
#   1 = failed
#   2 = already up to date (no action needed)
install_launchagent() {
  local plist_source="$1"

  if [ ! -f "$plist_source" ]; then
    echo "Error: Plist file not found: $plist_source"
    return 1
  fi

  # Ensure LaunchAgents directory exists
  local launch_agents_dir="$HOME/Library/LaunchAgents"
  if [ ! -d "$launch_agents_dir" ]; then
    mkdir -p "$launch_agents_dir"
  fi

  local service_name=$(basename "$plist_source" .plist)
  local plist_dest="$launch_agents_dir/$service_name.plist"

  echo "Processing $service_name..."

  # Flag to track if we need to load/reload
  local need_reload=false

  # Compare files if destination exists
  if [ -f "$plist_dest" ]; then
    if ! cmp -s "$plist_source" "$plist_dest"; then
      echo "  LaunchAgent plist has changed, updating..."

      # Unload if currently loaded
      if launchctl list 2>/dev/null | grep -q "^[0-9-]*\s*.*\s$service_name$"; then
        launchctl unload "$plist_dest" 2>/dev/null || true
      fi

      if ! cp -f "$plist_source" "$plist_dest"; then
        echo "  Error: Failed to update $service_name"
        return 1
      fi
      need_reload=true
    fi
  else
    echo "  Installing new LaunchAgent..."
    if ! cp "$plist_source" "$plist_dest"; then
      echo "  Error: Failed to install $service_name"
      return 1
    fi
    need_reload=true
  fi

  # Check if LaunchAgent is currently loaded
  if launchctl list 2>/dev/null | grep -q "^[0-9-]*\s*.*\s$service_name$"; then
    if [ "$need_reload" = true ]; then
      echo "  Reloading LaunchAgent..."
      launchctl load -w "$plist_dest"
      return 0
    else
      echo "  LaunchAgent already loaded and up to date"
      return 2
    fi
  else
    echo "  Loading LaunchAgent..."
    if launchctl load -w "$plist_dest"; then
      return 0
    else
      echo "  Error: Failed to load $service_name"
      return 1
    fi
  fi
}

# Install all LaunchAgents in $MACHFILES_DIR/LaunchAgents
install_launchagents() {
  # Check if MACHFILES_DIR is set and exists
  if [ -z "$MACHFILES_DIR" ]; then
    echo "Error: MACHFILES_DIR environment variable is not set"
    echo "Please set MACHFILES_DIR to point to your machfiles repository root"
    return 1
  fi

  if [ ! -d "$MACHFILES_DIR/LaunchAgents" ]; then
    echo "Error: LaunchAgents directory not found at $MACHFILES_DIR/LaunchAgents"
    return 1
  fi

  # Track if any installations succeeded
  local installed_count=0
  local failed_count=0

  # Loop through LaunchAgents
  for plist_source in "$MACHFILES_DIR"/LaunchAgents/*.plist; do
    # Handle case where no .plist files exist
    if [ ! -f "$plist_source" ]; then
      echo "No LaunchAgent plists found"
      return 0
    fi

    install_launchagent "$plist_source"
    local result=$?

    case $result in
    0)
      ((installed_count++))
      ;;
    1)
      ((failed_count++))
      ;;
    2)
      # Already up to date, don't increment either counter
      ;;
    esac
  done

  # Summary
  if [ $installed_count -gt 0 ] || [ $failed_count -gt 0 ]; then
    echo ""
    echo "LaunchAgents installation complete!"
    echo "  Installed/reloaded: $installed_count"
    [ $failed_count -gt 0 ] && echo "  Failed: $failed_count"
  fi

  return 0
}

# Run the installation if this script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_launchagents || exit 1
fi

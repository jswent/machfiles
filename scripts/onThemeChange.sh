#!/bin/bash

PATH="$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin"

USER_DIR="/Users/jswent"
MACHFILES_DIR="$USER_DIR/machfiles"
CONFIG_DIR="$USER_DIR/.config"
KITTY_DIR="$CONFIG_DIR/kitty"

update_kitty_theme() {
  local theme_file="$1"
  # Check if current-theme.conf already exists
  # If so, either remove link or back up file
  if [ -L "$KITTY_DIR/current-theme.conf" ]; then
    rm -f "$KITTY_DIR/current-theme.conf"
  elif [ -f "$KITTY_DIR/current-theme.conf" ]; then
    mv -f "$KITTY_DIR/current-theme.conf" "$KITTY_DIR/current-theme.conf.bak"
  fi
  ln -s "$theme_file" "$KITTY_DIR/current-theme.conf"
  # Update current windows with new colors
  # Find all Kitty sockets and update their colors
  for socket in /tmp/mykitty-*; do
    if [ -S "$socket" ]; then
      echo "Updating theme for socket: $socket"
      kitty @ --to "unix:$socket" set-colors -a -c "$KITTY_DIR/current-theme.conf"
    fi
  done
}

update_nvim_theme() {
  local colorscheme="$1"
  # Find all Neovim server sockets
  NVIM_SERVERS=$(find /tmp/* -name 'nvim*' -type s 2>/dev/null)

  # Change theme for each Neovim instance
  for server in $NVIM_SERVERS; do
    nvim --server "$server" --remote-expr "luaeval('vim.cmd(\"colorscheme ${colorscheme}\") or true')"
  done
}

update_nvim_appearance() {
  local appearance="$1"
  # Find all Neovim server sockets
  NVIM_SERVERS=$(find /tmp/* -name 'nvim*' -type s 2>/dev/null)

  # Change theme for each Neovim instance
  for server in $NVIM_SERVERS; do
    nvim --server "$server" --remote-expr "luaeval('require(\"jswent.colorscheme\").set_appearance(\"$appearance\")')"
  done
}

update_starship_theme() {
  local new_theme="$1"
  local file

  if [[ -d "$MACHFILES_DIR" ]]; then
    file="$MACHFILES_DIR/config/starship.toml"
  else
    file="$CONFIG_DIR/starship.toml"
  fi

  sed -i '' "s/^palette = \"[^\"]*\"/palette = \"$new_theme\"/" "$file"
}

update_starship_appearance() {
  local appearance="$1"
  local config_path="$CONFIG_DIR/starship.toml"

  if [ ! -d "$MACHFILES_DIR" ]; then
    return 1
  fi

  if [ ! -L "$config_path" ]; then
    return 1
  fi

  echo "reached"
  if [ "$appearance" = "light" ]; then
    rm "$config_path"
    ln -s "$MACHFILES_DIR/config/starship-light.toml" "$config_path"
  elif [ "$appearance" = "dark" ]; then
    rm "$config_path"
    ln -s "$MACHFILES_DIR/config/starship-dark.toml" "$config_path"
  fi
}

# Check that dark mode is received from service
if [ -n "$DARKMODE" ]; then
  if [ "$DARKMODE" -eq 1 ]; then
    echo "Switching to dark mode"
    update_kitty_theme "$KITTY_DIR/themes/solarized_custom.conf"
    # update_nvim_theme "tokyonight-moon"
    update_nvim_appearance "dark"
    update_starship_appearance "dark"
  elif [ "$DARKMODE" -eq 0 ]; then
    echo "Switching to light mode"
    update_kitty_theme "$KITTY_DIR/themes/solarized_light.conf"
    # update_nvim_theme "tokyonight-day"
    update_nvim_appearance "light"
    update_starship_appearance "light"
  else
    echo "Invalid DARKMODE value: $DARKMODE"
  fi
fi

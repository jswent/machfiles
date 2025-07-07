#!/bin/bash

install_homebrew() {
  # Check if MACHFILES_DIR is set
  if [ -z "$MACHFILES_DIR" ]; then
    echo "Error: MACHFILES_DIR environment variable is not set"
    echo "Please set MACHFILES_DIR to point to your machfiles repository root"
    return 1
  fi

  debug_print "Starting homebrew installation..."

  # Part 1: Check if homebrew exists and install if not
  if ! command -v brew &> /dev/null; then
    debug_print "Homebrew not found, installing..."
    echo "Installing Homebrew..."
    
    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for the current session
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f "/usr/local/bin/brew" ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
    
    # Verify installation
    if ! command -v brew &> /dev/null; then
      echo "Error: Homebrew installation failed"
      return 1
    fi
    
    echo "Homebrew installed successfully!"
  else
    debug_print "Homebrew already installed"
    echo "Homebrew is already installed"
  fi

  # Part 2: Install packages from domains
  install_homebrew_packages
  return $?
}

discover_domains() {
  local domains_dir="$MACHFILES_DIR/brew"
  debug_print "Discovering domains in: $domains_dir"
  
  if [ ! -d "$domains_dir" ]; then
    debug_print "Domains directory not found"
    return 1
  fi
  
  # Find all .sh files in domains directory
  find "$domains_dir" -name "*.sh" -type f | sort
}

load_domain() {
  local domain_file="$1"
  debug_print "Loading domain file: $domain_file"
  
  # Reset domain variables
  DOMAIN_NAME=""
  FORMULAE=()
  CASKS=()
  
  # Source the domain file
  source "$domain_file"
  
  # Validate that required variables are set
  if [ -z "$DOMAIN_NAME" ]; then
    echo "Error: DOMAIN_NAME not set in $domain_file"
    return 1
  fi
  
  debug_print "Loaded domain: $DOMAIN_NAME with ${#FORMULAE[@]} formulae and ${#CASKS[@]} casks"
}

show_domain_menu() {
  local domains=($(discover_domains))
  
  if [ ${#domains[@]} -eq 0 ]; then
    echo "No domains found in $MACHFILES_DIR/domains"
    return 1
  fi
  
  echo "Available package domains:"
  echo "1) Install everything"
  
  local counter=2
  local domain_names=()
  
  for domain_file in "${domains[@]}"; do
    if load_domain "$domain_file"; then
      echo "$counter) $DOMAIN_NAME"
      domain_names+=("$DOMAIN_NAME:$domain_file")
      counter=$((counter + 1))
    fi
  done
  
  echo "q) Back to main menu"
  
  # Store domain info for later use
  echo "${domain_names[@]}" > /tmp/machfiles_domains.txt
  echo "${domains[@]}" > /tmp/machfiles_domain_files.txt
}

install_selected_domains() {
  local selected_domains=("$@")
  local all_formulae=()
  local all_casks=()
  
  debug_print "Installing selected domains: ${selected_domains[*]}"
  
  for domain_file in "${selected_domains[@]}"; do
    if load_domain "$domain_file"; then
      debug_print "Processing domain: $DOMAIN_NAME"
      echo "Processing $DOMAIN_NAME..."
      
      # Add formulae to master list
      all_formulae+=("${FORMULAE[@]}")
      
      # Add casks to master list  
      all_casks+=("${CASKS[@]}")
    fi
  done
  
  # Install all formulae in one command
  if [ ${#all_formulae[@]} -gt 0 ]; then
    echo "Installing ${#all_formulae[@]} formulae..."
    debug_print "Installing formulae: ${all_formulae[*]}"
    
    if ! brew install "${all_formulae[@]}"; then
      echo "Warning: Some formulae failed to install"
    fi
  fi
  
  # Install all casks in one command
  if [ ${#all_casks[@]} -gt 0 ]; then
    echo "Installing ${#all_casks[@]} casks..."
    debug_print "Installing casks: ${all_casks[*]}"
    
    if ! brew install --cask "${all_casks[@]}"; then
      echo "Warning: Some casks failed to install"
    fi
  fi
  
  echo "Package installation complete!"
}

handle_domain_choice() {
  local choice="$1"
  local domains=($(cat /tmp/machfiles_domain_files.txt 2>/dev/null))
  
  case "$choice" in
    1)
      # Install everything
      echo "Installing all domains..."
      install_selected_domains "${domains[@]}"
      ;;
    q)
      return 0
      ;;
    *)
      # Check if it's a valid domain number
      local domain_index=$((choice - 2))
      if [ "$domain_index" -ge 0 ] && [ "$domain_index" -lt ${#domains[@]} ]; then
        local selected_domain="${domains[$domain_index]}"
        echo "Installing selected domain..."
        install_selected_domains "$selected_domain"
      else
        echo "Invalid option"
        return 1
      fi
      ;;
  esac
}

install_homebrew_packages() {
  debug_print "Starting package installation menu"
  
  # Check if domains directory exists
  if [ ! -d "$MACHFILES_DIR/domains" ]; then
    echo "Error: No domains directory found at $MACHFILES_DIR/domains"
    echo "Please create domain files to define packages to install"
    return 1
  fi
  
  # Show domain menu and handle selection
  while true; do
    show_domain_menu
    read -p "Choose a domain to install: " choice
    
    if [ "$choice" = "q" ]; then
      break
    fi
    
    if handle_domain_choice "$choice"; then
      break
    fi
  done
  
  # Cleanup temporary files
  rm -f /tmp/machfiles_domains.txt /tmp/machfiles_domain_files.txt
}
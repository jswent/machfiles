# machfiles

My personal macOS dotfiles and system configuration manager. Automates the setup of development tools, shell configuration, and application settings with automatic dark/light mode theme switching.

## Features

- **Modular Installation** - Install everything at once or pick individual components
- **ZSH Configuration** - Modern shell setup with zinit, starship prompt, and curated plugins
- **Package Management** - Organized homebrew packages grouped by domain (devtools, editor, web, tweaks)
- **Automatic Theme Switching** - Seamlessly switch themes across terminal, editor, and prompt when macOS appearance changes
- **Application Configs** - Pre-configured settings for ghostty, kitty, wezterm, neovim, raycast, and more

## Prerequisites

- macOS (tested on recent versions)
- Git

## Quick Start

### One-Line Install

```bash
curl -fsSL https://raw.githubusercontent.com/jswent/machfiles/main/install.sh | bash
```

### Manual Install

```bash
# Clone the repository
git clone https://github.com/jswent/machfiles.git ~/machfiles

# Set environment variable
export MACHFILES_DIR="$HOME/machfiles"

# Run installer
cd ~/machfiles
./install.sh
```

The installer will present an interactive menu where you can choose what to install.

## What Gets Installed

### 1. ZSH Configuration

- Modern plugin management with [zinit](https://github.com/zdharma-continuum/zinit)
- [Starship](https://starship.rs/) prompt with custom theme
- Syntax highlighting, autosuggestions, and completions
- [zoxide](https://github.com/ajeetdsouza/zoxide) for smart directory navigation
- [fzf](https://github.com/junegunn/fzf) for fuzzy finding
- Custom aliases and functions

### 2. Homebrew Packages

Organized into domains for easy management:

- **DevTools**: gcc, clang-format, go, ripgrep, fd, eza, lazygit, tmux, btop, jq, docker, ghostty, and more

- **Editor**: neovim, bat, cursor, visual-studio-code, emacs, textmate

- **Web**: Browsers and web development tools

- **Tweaks**: System utilities and enhancements

### 3. macOS Appearance Automation

- Installs [dark-mode-notify](https://github.com/jswent/dark-mode-notify)
- Automatically updates themes when macOS appearance changes
- Syncs terminal (Kitty), editor (Neovim), and prompt (Starship) themes
- Works with all running instances simultaneously

### 4. LaunchAgents

Automatically installs and configures macOS LaunchAgents from the `LaunchAgents/` directory:

- **dark-mode-notify** - Monitors macOS appearance changes and triggers theme switching
- **brew-update** - Scheduled homebrew updates and maintenance
- Any new additions not documented here

All LaunchAgents are:

- Copied to `~/Library/LaunchAgents/`
- Loaded with `launchctl` to run at startup
- Configured with logging to `/tmp/` for debugging

## Usage

### Installing Components

Run the installer to see the menu:

```bash
cd $MACHFILES_DIR
./install.sh
```

For verbose output:

```bash
./install.sh -v
```

### Customizing

#### Local Shell Customizations

Add per-machine aliases and settings without modifying the repo:

- `~/.aliases.zsh` - Custom aliases
- `~/.ext.zsh` - Additional configuration

These files are sourced automatically if they exist.

**Example `~/.aliases.zsh`:**

```bash
# Work-specific aliases
alias work='cd ~/Projects/work && ls'
alias deploy='./scripts/deploy.sh'

# Custom git shortcuts
alias gp='git push origin $(git rev-parse --abbrev-ref HEAD)'
alias gl='git log --oneline --graph --decorate -10'
```

**Example `~/.ext.zsh`:**

```bash
# Environment variables for tools
export CONDA_PREFIX="$HOME/.local/conda"
export JAVA_HOME=$(/usr/libexec/java_home -v 17)

# Source project-specific configurations
source "$HOME/Repos/my-project/project-config.zsh"

# Load optional language version managers
source "$MACHFILES_DIR/zsh/pyenv.zsh"
source "$MACHFILES_DIR/zsh/conda.zsh"
source "$MACHFILES_DIR/zsh/jenv.zsh"
```

#### Adding Packages

Create or edit domain files in `installers/brew/`:

```bash
# Example: installers/brew/mytools.sh
DOMAIN_NAME="mytools"
FORMULAE=(
  "package1"
  "package2"
)
CASKS=(
  "app1"
  "app2"
)
```

The installer will automatically discover your new domain.

### Managing LaunchAgents

Check dark-mode-notify status:

```bash
launchctl list | grep dark-mode-notify
```

View logs:

```bash
tail -f /tmp/dark-mode-notify-stdout.log
```

Reload after changes:

```bash
launchctl unload ~/Library/LaunchAgents/com.jswent.dark-mode-notify.plist
launchctl load -w ~/Library/LaunchAgents/com.jswent.dark-mode-notify.plist
```

## Key Aliases

### Git

- `ggs` - git status
- `gga` - git add
- `ggc` - git commit -m
- `lg` - lazygit

### Navigation

- `ls` - eza with icons and colors
- `ll` - long format listing
- `gc` - go to ~/.config
- `gm` - go to `$MACHFILES_DIR`
- `gv` - go to neovim config
- `gw` - go to Projects/Working

### System

- `clr` - clear screen and tmux history
- `sourcez` - reload zsh configuration
- `vi`, `nvim` - launch neovim

See `zsh/aliases.zsh` for the complete list.

## Directory Structure

```
machfiles/
├── .zshrc              # Main ZSH configuration
├── install.sh          # Interactive installer
├── config/             # Application configs
│   ├── ghostty/
│   ├── kitty/
│   ├── wezterm/
│   ├── raycast/
│   └── ...
├── installers/         # Installation modules
│   ├── environment.sh
│   ├── zsh.sh
│   ├── homebrew.sh
│   ├── dark-mode-notify.sh
│   └── brew/          # Package domains
├── scripts/           # Helper scripts
│   └── onThemeChange.sh
├── zsh/               # ZSH modules
│   ├── aliases.zsh
│   ├── exports.zsh
│   └── ...
└── LaunchAgents/      # macOS LaunchAgents
```

## Updating

Pull the latest changes and re-run the installer:

```bash
cd $MACHFILES_DIR
git pull
./install.sh
```

The installer is idempotent - safe to run multiple times.

## Troubleshooting

### MACHFILES_DIR not set

Add to your shell config:

```bash
export MACHFILES_DIR="$HOME/machfiles"
```

### ZSH config not loading

Ensure the symlink is correct:

```bash
ls -la ~/.zshrc
# Should point to: /Users/[you]/machfiles/.zshrc
```

### Theme switching not working

Check if dark-mode-notify is running:

```bash
launchctl list | grep dark-mode-notify
cat /tmp/dark-mode-notify-stdout.log
```

## License

Personal dotfiles - feel free to fork and adapt for your own use.

## Acknowledgments

Built with these excellent tools:

- [zinit](https://github.com/zdharma-continuum/zinit) - ZSH plugin manager
- [starship](https://starship.rs/) - Cross-shell prompt
- [dark-mode-notify](https://github.com/jswent/dark-mode-notify) - macOS appearance change notifications
- [Homebrew](https://brew.sh/) - Package manager for macOS

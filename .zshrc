export MACHFILES_DIR=$HOME/machfiles

if [ ! -d "$MACHFILES_DIR" ]; then
  mkdir -p "$(dirname $MACHFILES_DIR)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

export EDITOR="nvim"
export VISUAL="nvim"

export HISTFILE=$MACHFILES_DIR/.zsh_history
export HISTSIZE=100000000
export SAVEHIST=$HISTSIZE
setopt appendhistory
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS

source "${ZINIT_HOME}/zinit.zsh"

zinit ice depth=1

zinit wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
      zsh-users/zsh-syntax-highlighting \
  atload"_zsh_autosuggest_start; bindkey '^ ' autosuggest-accept" \
      zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions \
  atload"eval $(zoxide init zsh)" \
      ajeetdsouza/zoxide

alias ls='eza --icons --color=always --group-directories-first'
alias ll='ls -lF'
alias lsa='ls -lah'
alias nvim='nvim --listen /tmp/nvim-$RANDOM'

eval "$(starship init zsh)"

# Personal aliases
alias ls='eza --icons --color=always --group-directories-first'
alias ll='ls -lF'
alias lsa='ls -lah'
alias clr=';clear;test -n "$TMUX" && tmux clear-history'
alias nvim='nvim --listen /tmp/nvim-$RANDOM'
alias vi='nvim'
alias yy='yazi'

# git aliases
alias ggs='git status'
alias gga='git add'
alias ggc='git commit -m'
alias ggr='git reset'
alias ggmv='git mv -f'
alias ggrm='git rm -rf'
alias lg='lazygit'

# confirm before overwriting something
alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'

# go to aliases
alias gc='cd $HOME/.config && lsa'
alias gv='cd $HOME/.config/nvim && lsa'
alias gm='cd $MACHFILES_DIR'
alias gw='cd $HOME/Projects/Working && lsa'
alias ga='cd $HOME/Projects/Archived && lsa'
alias gsb='cd $HOME/Projects/Sandbox && lsa'

# machmarks aliases
alias m='machmarks'
alias mm='m -g'
alias ms='m -s'
alias ml='m -l'
alias mla='m -L'

# tmux aliases
alias tmkill='killall tmux'
alias tmls='tmux ls'

# python aliases
alias py='python3'

# mass change extension function
mvext () {
  local current_extension="$1"
  local to_extension="$2" 
  for f in *."$current_extension"; do mv -- "$f" "${f%.$current_extension}.$to_extension"; done
}

alias bash='clear && exec bash'
alias sourcez='source ~/.zshrc'

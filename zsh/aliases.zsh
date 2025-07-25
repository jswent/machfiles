# Colorful ZSH
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# Personal aliases
alias ls='eza --icons --color=always --group-directories-first'
alias ll='ls -lF'
alias lsa='ls -lah'
alias clr=';clear;test -n "$TMUX" && tmux clear-history'
alias nvim='nvim --listen /tmp/nvim-$RANDOM'
alias vi='nvim'

# git functions
push () {
  local current_branch=$(git rev-parse --abbrev-ref HEAD)
  local branches=$(git remote -v | grep push | awk '{print $1}')
  for branch in "$branches"
  do
    git push -u "$branch" "$current_branch"
  done
  
}

# git aliases
alias ggs='git status'
alias gga='git add'
alias ggc='git commit -m'
alias ggr='git reset'
alias ggmv='git mv -f'
alias ggrm='git rm -rf'
# alias ggp=push
alias ggui='gitui'
alias lg='lazygit'

# confirm before overwriting something
alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'

# go to aliases
alias gc='cd $HOME/.config && lsa'
alias gv='cd $HOME/.config/nvim && lsa'
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

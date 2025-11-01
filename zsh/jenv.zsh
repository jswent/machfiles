jenv() {
  unfunction 'jenv' 2>/dev/null

  # Initialize jenv
  local __jenv_init
  __jenv_init="$(jenv init -)"
  if [[ $? -eq 0 ]]; then
    eval "$__jenv_init"
  fi

  # Add jenv bin to path
  export PATH="$HOME/.jenv/bin:$PATH"

  unset __jenv_init

  command jenv "$@"
}

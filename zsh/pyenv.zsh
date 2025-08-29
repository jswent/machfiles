# Lazy load pyenv on MacOS with homebrew
# TODO: Generic loader for linux

if [[ -z "$PYENV_ROOT" ]]; then
  export PYENV_ROOT="$HOME/.pyenv"
fi

pyenv() {
  unfunction 'pyenv' 2>/dev/null

  local PYENV_BIN="/opt/homebrew/bin/pyenv"

  if [[ ! -x "$PYENV_BIN" ]] && ! command -v pyenv >/dev/null 2>&1; then
    read "confirm?pyenv not found at $PYENV_BIN. Install it now? [y/N] "
    if [[ $confirm =~ ^[Yy]$ ]]; then
      if [[ "$OSTYPE" == darwin* ]] && command -v brew >/dev/null 2>&1; then
        brew install pyenv pyenv-virtualenv
      else
        command curl -fsSL https://pyenv.run | bash
      fi
    else
      echo "Aborted."
      return 1
    fi
  fi

  # Initialize pyenv
  local __pyenv_init
  __pyenv_init="$("$PYENV_BIN" init - zsh 2>/dev/null)"
  if [[ $? -eq 0 ]]; then
    eval "$__pyenv_init"
  fi

  unset __pyenv_init
  unset PYENV_BIN confirm

  command pyenv "$@"
}

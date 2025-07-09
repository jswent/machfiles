# Lazy load conda and manually activate environments

if [[ -z $CONDA_PREFIX ]]; then
  echo "Unable to locate conda installation directory, no \$CONDA_PREFIX set"
  return 1
fi

conda() {
  unfunction 'conda' 2>/dev/null

  # Check if conda is installed
  local CONDA_BIN="$CONDA_PREFIX/bin/conda"
  if [[ ! -f "$CONDA_BIN" ]]; then
    read "confirm?Conda binary not found at $CONDA_BIN. Would you like to install it now? [y/N] "
    if [[ $confirm =~ ^[Yy]$ ]]; then
      local CONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh"
      curl "$CONDA_URL" -o "$CONDA_PREFIX/miniconda.sh"
      bash "$CONDA_PREFIX/miniconda.sh" -b -u -p "$CONDA_PREFIX"
      rm "$CONDA_PREFIX/miniconda.sh"
    else
      echo "Aborted."
      exit 1
    fi
  fi

  # Initialize conda
  local __conda_setup
  __conda_setup="$('$CONDA_BIN', 'shell.zsh', 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
    eval "$__conda_setup"
  else 
    if [ -f "$CONDA_PREFIX/etc/profile.d/conda.sh" ]; then
        . "$CONDA_PREFIX/etc/profile.d/conda.sh"
    else
        export PATH="$CONDA_PREFIX/bin:$PATH"
    fi
  fi

  unset __conda_setup

  conda "$@"
}

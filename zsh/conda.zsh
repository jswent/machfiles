# Lazy load conda and manually activate environments

if [[ -z $CONDA_PREFIX ]]; then
  echo "Unable to locate conda installation directory, no \$CONDA_PREFIX set"
  return 1
fi

conda() {
  # Check if conda is installed
  local CONDA_BIN="$CONDA_PREFIX/bin/conda"
  if [[ ! -f "$CONDA_BIN" ]]; then
    read "confirm?Conda binary not found at $CONDA_BIN. Would you like to install it now? [y/N] "
    if [[ $confirm =~ ^[Yy]$ ]]; then
      local CONDA_URL="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Darwin-arm64.sh"
      curl -L "$CONDA_URL" -o "$CONDA_PREFIX/miniforge.sh"
      bash "$CONDA_PREFIX/miniforge.sh" -b -u -p "$CONDA_PREFIX"
      rm "$CONDA_PREFIX/miniforge.sh"
    else
      echo "Aborted."
      exit 1
    fi
  fi

  unfunction 'conda' 2>/dev/null

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

mamba() {
  # Initialize conda first if not already done
  # Check if conda is still a function (not yet initialized)
  if [[ $(type -w conda 2>/dev/null) == "conda: function" ]]; then
    conda --version > /dev/null 2>&1
    if [ $? -eq 1 ]; then
      return 1
    fi
  fi

  unfunction 'mamba' 2>/dev/null

  # Initialize mamba shell
  local MAMBA_BIN="$CONDA_PREFIX/bin/mamba"
  local __mamba_setup
  __mamba_setup="$("$MAMBA_BIN" 'shell' 'hook' --shell zsh 2> /dev/null)"
  if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
  fi

  unset __mamba_setup

  mamba "$@"
}

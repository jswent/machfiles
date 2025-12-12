# Lazy install + lazy load Julia via juliaup

# juliaup stores versions/config in the "Julia depot" by default; override via JULIAUP_DEPOT_PATH
: "${JULIAUP_DEPOT_PATH:=$HOME/.local/julia}"
: "${JULIA_DEPOT_PATH:=$JULIAUP_DEPOT_PATH}"   # optional but commonly desired
export JULIAUP_DEPOT_PATH JULIA_DEPOT_PATH

__ensure_juliaup() {
  local root="$JULIAUP_DEPOT_PATH"
  local julia_bin="$root/bin/julia"
  local juliaup_bin="$root/bin/juliaup"

  if [[ -x "$julia_bin" && -x "$juliaup_bin" ]]; then
    return 0
  fi

  local confirm
  read "confirm?juliaup not found at $root. Install now? [y/N] "
  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    return 1
  fi

  # Official installer supports non-interactive + custom install location
  curl -fsSL https://install.julialang.org | sh -s -- \
    --yes \
    --add-to-path=no \
    --path "$root" || return 1

  [[ -x "$julia_bin" && -x "$juliaup_bin" ]] || return 1
}

julia() {
  __ensure_juliaup || return 1
  unfunction julia juliaup __ensure_juliaup 2>/dev/null
  export PATH="$JULIAUP_DEPOT_PATH/bin:$PATH"
  julia "$@"
}

juliaup() {
  __ensure_juliaup || return 1
  unfunction julia juliaup __ensure_juliaup 2>/dev/null
  export PATH="$JULIAUP_DEPOT_PATH/bin:$PATH"
  juliaup "$@"
}


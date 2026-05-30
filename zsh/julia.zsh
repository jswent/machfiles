# Lazy install Julia via juliaup; if installed, expose it immediately

# juliaup stores versions/config in the "Julia depot" by default; override via JULIAUP_DEPOT_PATH
: "${JULIAUP_DEPOT_PATH:=$HOME/.local/julia}"
: "${JULIA_DEPOT_PATH:=$JULIAUP_DEPOT_PATH}"   # optional but commonly desired
export JULIAUP_DEPOT_PATH JULIA_DEPOT_PATH

if [[ -x "$JULIAUP_DEPOT_PATH/bin/julia" && -x "$JULIAUP_DEPOT_PATH/bin/juliaup" ]]; then
  case ":$PATH:" in
    *":$JULIAUP_DEPOT_PATH/bin:"*) ;;
    *) export PATH="$JULIAUP_DEPOT_PATH/bin:$PATH" ;;
  esac
else
  __juliaup_install() {
    local root="$JULIAUP_DEPOT_PATH"
    local julia_bin="$root/bin/julia"
    local juliaup_bin="$root/bin/juliaup"

    # Re-check in case it was installed after this file was sourced.
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

    [[ -x "$julia_bin" && -x "$juliaup_bin" ]]
  }

  __juliaup_activate() {
    case ":$PATH:" in
      *":$JULIAUP_DEPOT_PATH/bin:"*) ;;
      *) export PATH="$JULIAUP_DEPOT_PATH/bin:$PATH" ;;
    esac
  }

  julia() {
    __juliaup_install || return 1
    __juliaup_activate
    unfunction julia juliaup __juliaup_install __juliaup_activate 2>/dev/null
    julia "$@"
  }

  juliaup() {
    __juliaup_install || return 1
    __juliaup_activate
    unfunction julia juliaup __juliaup_install __juliaup_activate 2>/dev/null
    juliaup "$@"
  }
fi

# Lazy install Rust via rustup; if installed, expose it immediately

# Keep rustup state and cargo cache/install output under XDG-ish paths.
# These must be set before running rustup-init and whenever using the toolchain.
: "${RUSTUP_HOME:=$HOME/.config/rustup}"
: "${CARGO_HOME:=$HOME/.local/cargo}"
export RUSTUP_HOME CARGO_HOME

__rustup_activate() {
  case ":$PATH:" in
    *":$CARGO_HOME/bin:"*) ;;
    *) export PATH="$CARGO_HOME/bin:$PATH" ;;
  esac
}

if [[ -x "$CARGO_HOME/bin/rustup" ]]; then
  __rustup_activate
  unfunction __rustup_activate 2>/dev/null
else
  __rustup_install() {
    local rustup_bin="$CARGO_HOME/bin/rustup"

    # Re-check in case it was installed after this file was sourced.
    if [[ -x "$rustup_bin" ]]; then
      return 0
    fi

    local confirm
    read "confirm?rustup not found at $CARGO_HOME. Install Rust now? [y/N] "
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
      echo "Aborted."
      return 1
    fi

    mkdir -p "$CARGO_HOME" "$RUSTUP_HOME" || return 1

    # Official Unix installer. --no-modify-path keeps dotfile ownership of PATH.
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- \
      -y \
      --no-modify-path || return 1

    [[ -x "$rustup_bin" ]]
  }

  __rustup_run() {
    local cmd="$1"
    shift

    __rustup_install || return 1
    __rustup_activate
    unfunction \
      rust rustup rustc rustdoc cargo rustfmt rust-analyzer \
      cargo-clippy clippy-driver cargo-miri \
      rust-lldb rust-gdb rust-gdbgui \
      __rustup_install __rustup_run __rustup_activate 2>/dev/null

    "$cmd" "$@"
  }

  rust() { __rustup_run rustc "$@" }
  rustup() { __rustup_run rustup "$@" }
  rustc() { __rustup_run rustc "$@" }
  rustdoc() { __rustup_run rustdoc "$@" }
  cargo() { __rustup_run cargo "$@" }
  rustfmt() { __rustup_run rustfmt "$@" }
  rust-analyzer() { __rustup_run rust-analyzer "$@" }
  cargo-clippy() { __rustup_run cargo-clippy "$@" }
  clippy-driver() { __rustup_run clippy-driver "$@" }
  cargo-miri() { __rustup_run cargo-miri "$@" }
  rust-lldb() { __rustup_run rust-lldb "$@" }
  rust-gdb() { __rustup_run rust-gdb "$@" }
  rust-gdbgui() { __rustup_run rust-gdbgui "$@" }
fi

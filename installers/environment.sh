#!/bin/bash

check_environment() {
  # Check if MACHFILES_DIR is set
  if [ -z "$MACHFILES_DIR" ]; then
    debug_print "MACHFILES_DIR environment variable is not set"
    return 2
  fi

  # Check if directory exists
  if [ ! -d "$MACHFILES_DIR" ]; then
    debug_print "MACHFILES_DIR directory does not exist at: $MACHFILES_DIR"
    return 1
  fi

  # Check if it's a git repository
  if ! git -C "$MACHFILES_DIR" rev-parse --git-dir >/dev/null 2>&1; then
    debug_print "MACHFILES_DIR is not a git repository"
    return 1
  fi

  debug_print "Environment check passed"
  return 0
}


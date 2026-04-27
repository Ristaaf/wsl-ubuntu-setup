#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="$HOME/.local/bin"
MAN_DIR="$HOME/.local/share/man/man1"

mkdir -p "$BIN_DIR"
mkdir -p "$MAN_DIR"

mandb -q --user-db || true

# bat -> batcat
if command -v batcat >/dev/null; then
  ln -sfn "$(command -v batcat)" "$BIN_DIR/bat"
  ln -sfn /usr/share/man/man1/batcat.1.gz "$MAN_DIR/bat.1.gz"
fi

# fd -> fdfind
if command -v fdfind >/dev/null; then
  ln -sfn "$(command -v fdfind)" "$BIN_DIR/fd"
  ln -sfn /usr/share/man/man1/fdfind.1.gz "$MAN_DIR/fd.1.gz"
fi

# Optional sanity output
ls -l "$BIN_DIR"/{bat,fd} 2>/dev/null || true

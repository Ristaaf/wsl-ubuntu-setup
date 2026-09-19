#!/usr/bin/env bash
set -euo pipefail

LAZYDOCKER_BIN_DIR="${LAZYDOCKER_BIN_DIR:-$HOME/.local/bin}"

if command -v lazydocker >/dev/null 2>&1; then
  echo "lazydocker already installed, skipping"
  exit 0
fi

echo "Installing lazydocker..."
mkdir -p "$LAZYDOCKER_BIN_DIR"

# The upstream installer downloads into the current directory, so run it
# from a scratch dir to avoid leaving tarballs behind on failure.
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
cd "$tmp"

DIR="$LAZYDOCKER_BIN_DIR" \
  bash <(curl -fsSL https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh)

"$LAZYDOCKER_BIN_DIR/lazydocker" --version

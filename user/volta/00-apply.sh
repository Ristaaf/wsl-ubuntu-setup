#!/usr/bin/env bash
set -euo pipefail

VOLTA_HOME="$HOME/.volta"
VOLTA_BIN="$VOLTA_HOME/bin/volta"

# Install Volta only if not already installed
if [ ! -x "$VOLTA_BIN" ]; then
  echo "Installing Volta..."

  curl -fsSL https://get.volta.sh | bash -s -- --skip-setup
else
  echo "Volta already installed, skipping"
fi

#!/usr/bin/env bash
set -euo pipefail

if command -v tldr >/dev/null 2>&1; then
  echo "tlrc already installed, skipping"
else
  echo "Installing tlrc..."
  cargo install --locked tlrc
fi

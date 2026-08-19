#!/usr/bin/env bash
set -euo pipefail

if command -v delta >/dev/null 2>&1; then
  echo "git-delta already installed, skipping"
else
  echo "Installing git-delta..."
  cargo install --locked git-delta
fi

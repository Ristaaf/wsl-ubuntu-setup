#!/usr/bin/env bash
set -euo pipefail

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Guard: ensure volta is on PATH
command -v volta >/dev/null 2>&1 || {
  echo "Volta is not available on PATH"
  exit 1
}

echo "Installing baseline Volta tools..."

volta install node@lts
volta install yarn
volta install pnpm

echo "Baseline Volta tools installed"


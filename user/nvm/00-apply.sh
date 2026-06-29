#!/usr/bin/env bash
set -euo pipefail

NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
NVM_SH="$NVM_DIR/nvm.sh"

# Install nvm only if not already installed.
# Profile is managed in user/shell/zsh/zprofile (PROFILE=/dev/null skips installer edits).
if [ ! -s "$NVM_SH" ]; then
  echo "Installing nvm..."

  export PROFILE=/dev/null
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
else
  echo "nvm already installed, skipping"
fi

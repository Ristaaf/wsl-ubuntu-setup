#!/usr/bin/env bash
set -euo pipefail

export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
# shellcheck source=/dev/null
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Guard: ensure nvm is available after sourcing
command -v nvm >/dev/null 2>&1 || {
  echo "nvm is not available"
  exit 1
}

echo "Installing baseline Node tools..."

nvm install --lts
nvm alias default 'lts/*'
(set +u; nvm use default)

export COREPACK_ENABLE_DOWNLOAD_PROMPT=0
corepack enable
corepack prepare yarn@stable --activate
corepack prepare pnpm@latest --activate

# Yarn Classic (v1) writes state-only ~/.yarnrc and ~/yarn.lock; Yarn 4 does not use them.
if [ -f "$HOME/.yarnrc" ] && grep -q 'yarn lockfile v1' "$HOME/.yarnrc"; then
  rm -f "$HOME/.yarnrc" "$HOME/yarn.lock"
fi

echo "Baseline Node tools installed"

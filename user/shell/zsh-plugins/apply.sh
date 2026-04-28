#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="$HOME/.local/share/zsh/plugins"
mkdir -p $PLUGIN_ROOT

if [[ ! -d "$PLUGIN_ROOT/zsh-autosuggestions/.git" ]]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGIN_ROOT/zsh-autosuggestions"
fi

ln -sfn "$SCRIPT_DIR/gclone" "$PLUGIN_ROOT/gclone"

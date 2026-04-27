#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="$HOME/.local/share/zsh/plugins/zsh-autosuggestions"

if [[ ! -d "$PLUGIN_DIR/.git" ]]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGIN_DIR"
fi 


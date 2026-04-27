#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

ln -sfn "$SCRIPT_DIR/tmux.conf"  "$HOME/.tmux.conf"

TPM_DIR="$HOME/.tmux/plugins/tpm"

if [ ! -d "$TPM_DIR" ]; then
  mkdir -p "$HOME/.tmux/plugins"
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

~/.tmux/plugins/tpm/bin/install_plugins

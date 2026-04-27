#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

chsh -s /usr/bin/zsh

ln -sfn "$SCRIPT_DIR/zsh/zshrc"  "$HOME/.zshrc"
ln -sfn "$SCRIPT_DIR/zsh/zshenv" "$HOME/.zshenv"
ln -sfn "$SCRIPT_DIR/zsh/zprofile" "$HOME/.zprofile"

rm -f \
	"$HOME/.bashrc" \
	"$HOME/.bash_logout" \
	"$HOME/.bash_history" \
	"$HOME/.profile" \
	"$HOME/.zcompdump"
	
mkdir -p "$HOME/.cache/zsh"
mkdir -p "$HOME/.local/state/zsh"
mkdir -p "$HOME/.local/state/less"

#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=lib/ui.sh
source "$ROOT_DIR/lib/ui.sh"

setup_ui_init

### ---- System phase -------------------------------------------------

setup_ui_register_dir "SYSTEM · apt" "$ROOT_DIR/system/apt" sudo
setup_ui_register "SYSTEM · locale" sudo "$ROOT_DIR/system/locale/apply.sh"
setup_ui_register "SYSTEM · wsl" sudo "$ROOT_DIR/system/wsl/apply.sh"

### ---- User phase ---------------------------------------------------

setup_ui_register_dir "USER · bin" "$ROOT_DIR/user/bin"
setup_ui_register "USER · shell" "$ROOT_DIR/user/shell/apply.sh"
setup_ui_register "USER · ssh" "$ROOT_DIR/user/ssh/apply.sh"
setup_ui_register "USER · zsh plugins" "$ROOT_DIR/user/shell/zsh-plugins/apply.sh"
setup_ui_register --slow "cargo build, ~2–3 min" "USER · starship" "$ROOT_DIR/user/starship/apply.sh"
setup_ui_register "USER · tmux" "$ROOT_DIR/user/tmux/apply.sh"
setup_ui_register "USER · cursor" "$ROOT_DIR/user/cursor/apply.sh"
setup_ui_register --slow "compile from source, ~1–3 min" "USER · neovim" "$ROOT_DIR/user/neovim/apply.sh"
setup_ui_register_dir "USER · nvm" "$ROOT_DIR/user/nvm"

setup_ui_run_all

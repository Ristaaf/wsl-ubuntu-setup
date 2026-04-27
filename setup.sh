#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log() {
  printf "\n\033[1m==> %s\033[0m\n" "$*"
}

run_script() {
  local script="$1"

  if [[ ! -x "$script" ]]; then
    log "Skipping (not executable): $script"
    return
  fi

  log "Running: $script"
  "$script"
}

run_scripts_in_dir() {
  local dir="$1"
  local pattern="${2:-*.sh}"

  if [[ ! -d "$dir" ]]; then
    return
  fi

  while IFS= read -r script; do
    run_script "$script"
  done < <(find "$dir" -maxdepth 1 -type f -name "$pattern" | sort)
}

log "SETUP STARTED"

### ---- System phase -------------------------------------------------

log "SYSTEM: apt"
sudo bash -c "
  set -e
  $(declare -f log run_script)
  $(declare -f run_scripts_in_dir)
  run_scripts_in_dir \"$ROOT_DIR/system/apt\"
"

log "SYSTEM: locale"
sudo "$ROOT_DIR/system/locale/apply.sh"

log "SYSTEM: wsl"
sudo "$ROOT_DIR/system/wsl/apply.sh"

### ---- User phase ---------------------------------------------------

log "USER: bin"
"$ROOT_DIR/user/bin/apply.sh"

log "USER: shell"
"$ROOT_DIR/user/shell/apply.sh"

log "USER: zsh plugins"
"$ROOT_DIR/user/shell/zsh-plugins/apply.sh"

log "USER: starship"
"$ROOT_DIR/user/starship/apply.sh"

log "USER: tmux"
"$ROOT_DIR/user/tmux/apply.sh"

log "USER: cursor"
"$ROOT_DIR/user/cursor/apply.sh"

log "USER: neovim"
"$ROOT_DIR/user/neovim/apply.sh"

log "USER: volta"
run_scripts_in_dir "$ROOT_DIR/user/volta"

---

log "SETUP COMPLETED ✅"

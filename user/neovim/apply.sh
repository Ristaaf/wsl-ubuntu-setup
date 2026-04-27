#!/usr/bin/env bash
set -euo pipefail

# ---- Config (override via env or orchestrator) ----
NVIM_REF="${NVIM_REF:-v0.12.2}"                 # tag, branch, or commit
NVIM_SRC_ROOT="${NVIM_SRC_ROOT:-$HOME/src}"      # where sources live
NVIM_DIR="$NVIM_SRC_ROOT/neovim"
NVIM_PREFIX="${NVIM_PREFIX:-$HOME/.local}"       # user-local install prefix
NVIM_BUILD_TYPE="${NVIM_BUILD_TYPE:-RelWithDebInfo}"

# ---- Preconditions ----
mkdir -p "$NVIM_SRC_ROOT"
mkdir -p "$NVIM_PREFIX/bin"

# ---- Fetch/update repo ----
if [[ -d "$NVIM_DIR/.git" ]]; then
  git -C "$NVIM_DIR" fetch --tags --prune
else
  git clone https://github.com/neovim/neovim.git "$NVIM_DIR"
fi

cd "$NVIM_DIR"

git checkout --detach "$NVIM_REF" 2>/dev/null || git checkout "$NVIM_REF"

make distclean

make CMAKE_BUILD_TYPE="$NVIM_BUILD_TYPE" CMAKE_INSTALL_PREFIX="$NVIM_PREFIX"
make CMAKE_INSTALL_PREFIX="$NVIM_PREFIX" install

# ---- Quick sanity output ----
"$NVIM_PREFIX/bin/nvim" --version | head -n 3


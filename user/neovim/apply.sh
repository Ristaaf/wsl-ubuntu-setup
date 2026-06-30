#!/usr/bin/env bash
set -euo pipefail

# ---- Config (override via env or orchestrator) ----
NVIM_REF="${NVIM_REF:-v0.12.3}"                 # tag, branch, or commit
NVIM_SRC_ROOT="${NVIM_SRC_ROOT:-$HOME/src}"      # where sources live
NVIM_DIR="$NVIM_SRC_ROOT/neovim"
NVIM_PREFIX="${NVIM_PREFIX:-$HOME/.local}"       # user-local install prefix
NVIM_BUILD_TYPE="${NVIM_BUILD_TYPE:-RelWithDebInfo}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_CONFIG_SRC="$SCRIPT_DIR/nvim"

# ---- Preconditions ----
mkdir -p "$NVIM_SRC_ROOT"
mkdir -p "$NVIM_PREFIX/bin"

# ---- Fetch/update repo ----
# Fetch only the pinned ref — not --tags (neovim's moving "nightly" tag
# would otherwise fail with "would clobber existing tag" on later runs).
if [[ -d "$NVIM_DIR/.git" ]]; then
  git -C "$NVIM_DIR" fetch origin --prune
  git -C "$NVIM_DIR" fetch origin "refs/tags/${NVIM_REF}:refs/tags/${NVIM_REF}" 2>/dev/null \
    || git -C "$NVIM_DIR" fetch origin "$NVIM_REF"
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

# ---- Dotfiles: ~/.config/nvim → this repo -------------------------
mkdir -p "$HOME/.config"
echo Creating symlink
echo $SCRIPT_DIR
echo $NVIM_CONFIG_SRC
ln -sfn "$NVIM_CONFIG_SRC" "$HOME/.config/nvim"

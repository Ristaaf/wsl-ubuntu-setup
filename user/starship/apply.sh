#!/usr/bin/env bash
set -euo pipefail

# ---- Config (override via env or orchestrator) ----
STARSHIP_REF="${STARSHIP_REF:-v1.25.0}"              # tag, branch, or commit
STARSHIP_SRC_ROOT="${STARSHIP_SRC_ROOT:-$HOME/src}"  # where sources live
STARSHIP_DIR="$STARSHIP_SRC_ROOT/starship"
STARSHIP_PREFIX="${STARSHIP_PREFIX:-$HOME/.local}"   # user-local install prefix

# ---- Preconditions ----
mkdir -p "$STARSHIP_SRC_ROOT"
mkdir -p "$STARSHIP_PREFIX/bin"

command -v cargo >/dev/null
command -v rustc >/dev/null

# ---- Fetch/update repo ----
if [[ -d "$STARSHIP_DIR/.git" ]]; then
  git -C "$STARSHIP_DIR" fetch --tags --prune
else
  git clone https://github.com/starship/starship.git "$STARSHIP_DIR"
fi

cd "$STARSHIP_DIR"

# Checkout requested ref deterministically
git checkout --detach "$STARSHIP_REF" 2>/dev/null || git checkout "$STARSHIP_REF"

# ---- Build & install (user-local, no sudo) ----
# Use `cargo install --path` so install location is explicit via --root.
# Cargo installs binaries into <root>/bin. 【5-12f950】
cargo install --locked --path . --root "$STARSHIP_PREFIX"

# ---- Quick sanity output ----
"$STARSHIP_PREFIX/bin/starship" --version

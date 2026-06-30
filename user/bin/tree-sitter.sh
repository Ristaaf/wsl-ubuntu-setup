#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="${BIN_DIR:-$HOME/.local/bin}"
TREE_SITTER_VERSION="${TREE_SITTER_VERSION:-0.26.10}"
TREE_SITTER_MIN_VERSION="${TREE_SITTER_MIN_VERSION:-0.26.1}"
TREE_SITTER_BIN="$BIN_DIR/tree-sitter"

mkdir -p "$BIN_DIR"

tree_sitter__installed_version() {
  if [[ ! -x "$TREE_SITTER_BIN" ]]; then
    return 1
  fi

  "$TREE_SITTER_BIN" --version 2>/dev/null | awk '{print $2}'
}

tree_sitter__version_ok() {
  local version="$1"
  [[ -n "$version" ]] \
    && [[ "$(printf '%s\n' "$TREE_SITTER_MIN_VERSION" "$version" | sort -V | head -1)" == "$TREE_SITTER_MIN_VERSION" ]]
}

tree_sitter__asset_arch() {
  case "$(uname -m)" in
    x86_64) printf 'linux-x64' ;;
    aarch64|arm64) printf 'linux-arm64' ;;
    armv7l|armv6l) printf 'linux-arm' ;;
    i686|i386) printf 'linux-x86' ;;
    *)
      echo "unsupported architecture for tree-sitter: $(uname -m)" >&2
      return 1
      ;;
  esac
}

installed_version="$(tree_sitter__installed_version || true)"
if tree_sitter__version_ok "$installed_version"; then
  echo "tree-sitter ${installed_version} already installed (>= ${TREE_SITTER_MIN_VERSION}), skipping"
  exit 0
fi

version_tag="${TREE_SITTER_VERSION#v}"
asset="tree-sitter-$(tree_sitter__asset_arch).gz"
url="https://github.com/tree-sitter/tree-sitter/releases/download/v${version_tag}/${asset}"

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

curl -fsSL "$url" | gunzip > "$tmp"
chmod +x "$tmp"
mv "$tmp" "$TREE_SITTER_BIN"
trap - EXIT

installed_version="$(tree_sitter__installed_version)"
echo "Installed tree-sitter ${installed_version} → ${TREE_SITTER_BIN}"

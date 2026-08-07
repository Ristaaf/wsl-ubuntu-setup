#!/usr/bin/env bash
set -euo pipefail

CLAUDE_CODE_CHANNEL="${CLAUDE_CODE_CHANNEL:-stable}"

if command -v claude >/dev/null 2>&1; then
  echo "claude already installed, skipping (run 'claude update' to update)"
else
  echo "Installing Claude Code CLI..."
  curl -fsSL https://claude.ai/install.sh | bash -s "$CLAUDE_CODE_CHANNEL"
fi

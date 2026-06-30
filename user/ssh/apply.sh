#!/usr/bin/env bash
set -euo pipefail

BEGIN_MARKER="# ---- begin setup-ssh-config ----"
END_MARKER="# ---- end setup-ssh-config ----"

BLOCK="$(cat <<EOF
${BEGIN_MARKER}
Host *
    IgnoreUnknown WarnWeakCrypto
    WarnWeakCrypto no-pq-kex
${END_MARKER}
EOF
)"

CONFIG="$HOME/.ssh/config"

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

touch "$CONFIG"
chmod 600 "$CONFIG"

content="$(<"$CONFIG")"
content="${content//$'\r'/}"

if [[ "$content" == *"$BEGIN_MARKER"* ]]; then
  before="${content%%"$BEGIN_MARKER"*}"
  after="${content#*"$END_MARKER"}"
  content="${before}${after}"
fi

content="${content%"${content##*[![:space:]]}"}"
content="${content#"${content%%[![:space:]]*}"}"

if [[ -n "$content" ]]; then
  printf '%s\n\n%s\n' "$content" "$BLOCK" >"$CONFIG"
else
  printf '%s\n' "$BLOCK" >"$CONFIG"
fi

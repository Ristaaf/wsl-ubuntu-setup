#!/usr/bin/env bash
set -e

cd ~/setup

if git diff --quiet && git diff --cached --quiet; then
  echo "No changes to sync."
  exit 0
fi

git add -A
git commit -m "sync $(date -Iseconds)" || true
git push


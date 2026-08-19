#!/usr/bin/env bash
set -euo pipefail

# Only touches the keys below; leaves the rest of ~/.gitconfig (user.*, url.*, etc.) untouched.
git config --global core.pager "delta"
git config --global interactive.diffFilter "delta --color-only"
git config --global merge.conflictStyle "zdiff3"

git config --global delta.navigate "true"
git config --global delta.dark "true"
git config --global delta.side-by-side "true"
git config --global delta.line-numbers "true"

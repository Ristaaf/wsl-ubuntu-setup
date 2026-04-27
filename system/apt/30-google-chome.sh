#!/usr/bin/env bash
set -euo pipefail

tmp=$(mktemp -d)
cd "$tmp"

curl -fsSLo google-chrome.deb \
  https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

sudo apt install -y ./google-chrome.deb

cd /
rm -rf "$tmp"


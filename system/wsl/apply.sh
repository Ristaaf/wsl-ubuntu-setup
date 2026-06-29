#!/usr/bin/env bash
set -euo pipefail

sudo crudini --set /etc/wsl.conf interop appendWindowsPath false

# show-motd runs /etc/profile.d/update-motd.sh and writes ~/.motd_shown once per day.
# Purge it system-wide instead of adding ~/.hushlogin to the home folder.
sudo apt-get purge -y show-motd
sudo apt-get autoremove -y

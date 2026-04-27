#!/usr/bin/env bash
set -euo pipefail

sudo crudini --set /etc/wsl.conf interop appendWindowsPath false


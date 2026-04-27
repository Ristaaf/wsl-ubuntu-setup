#!/usr/bin/env bash
set -euo pipefail

locale -a | grep -qi '^en_US\.utf8$' || sudo locale-gen en_US.UTF-8
sudo update-locale LANG=en_US.UTF-8


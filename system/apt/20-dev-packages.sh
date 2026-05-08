#!/usr/bin/env bash
set -euo pipefail

sudo apt-get install -y \
	ninja-build \
	gettext \
	cmake \
	build-essential \
	libssl-dev

#sudo apt-get install -y \
#	rustc \
#	cargo

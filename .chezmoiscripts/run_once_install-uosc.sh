#!/usr/bin/env bash
set -euo pipefail

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/tomasklaen/uosc/HEAD/installers/unix.sh)"

mpv_dir="${XDG_CONFIG_HOME:-$HOME/.config}/mpv"
mkdir -p "$mpv_dir/scripts"
curl -fsSL -o "$mpv_dir/scripts/thumbfast.lua" \
  https://raw.githubusercontent.com/po5/thumbfast/master/thumbfast.lua

#!/usr/bin/env bash

set -eux

if [ -d /run/archiso ]; then
  timedatectl set-ntp true
  systemctl restart systemd-timesyncd
  pacman -Sy git deno
  git clone -b renewal https://github.com/futsuuu/dot.git
  deno run -A ./dot/archInstaller.ts
else
  echo "nothing to do"
  exit 1
fi

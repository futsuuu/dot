#!/usr/bin/env bash

set -eux

if [ -d /run/archiso ]; then
  timedatectl set-ntp true
  systemctl restart systemd-timesyncd
  pacman -Sy --noconfirm archlinux-keyring
  pacman -S --noconfirm git deno
  git clone -b renewal https://github.com/futsuuu/dot.git
  cd dot
  deno task install-arch
else
  echo "nothing to do"
  exit 1
fi

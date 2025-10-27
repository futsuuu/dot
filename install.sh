#!/usr/bin/env bash

set -eux

if [ -d /run/archiso ]; then
  timedatectl set-ntp true
  systemctl restart systemd-timesyncd
  while timedatectl status | grep -q 'System clock synchronized: no'; do
    sleep 1
  done
  pacman -Sy --noconfirm archlinux-keyring
  pacman -S --noconfirm git deno
  git clone -b renewal https://github.com/futsuuu/dot.git
  cd dot
  deno task install-arch
else
  echo "nothing to do"
  exit 1
fi

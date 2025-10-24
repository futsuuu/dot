#!/usr/bin/env bash

set -eu

install_arch() {
  echo "start installing Arch Linux"
  set -eux

  timedatectl set-ntp true

  # disk cleanup
  cryptsetup open --type plain /dev/sda container --key-file /dev/random
  dd if=/dev/zero of=/dev/mapper/container bs=4096 status=progress || true
  cryptsetup close container

  # partition
  sgdisk --new 0::+1G --typecode 0:ef00 --change-name 0:boot /dev/sda  # EFI system
  sgdisk --new 0:: --typecode 0:8e00 --change-name 0:system /dev/sda  # Linux LVM

  # LUKS
  cryptsetup luksFormat /dev/sda2
  cryptsetup open --type luks /dev/sda2 cryptolvm

  # LVM
  pvcreate /dev/mapper/cryptolvm
  vgcreate myvolume /dev/mapper/cryptolvm
  lvcreate -L "$(grep MemTotal /proc/meminfo | awk '{print $2}')K" myvolume -n swap
  lvcreate -l 25%FREE myvolume -n root
  lvcreate -l 100%FREE myvolume -n home

  # format
  mkfs.ext4 /dev/mapper/myvolume-root
  mkfs.ext4 /dev/mapper/myvolume-home
  mkfs.fat -F 32 /dev/sda1
  mkswap /dev/mapper/myvolume-swap

  # mount
  mount /dev/mapper/myvolume-root /mnt
  mount --mkdir /dev/mapper/myvolume-home /mnt/home
  mount --mkdir -o fmask=0137,dmask=0027 /dev/sda1 /mnt/boot
  swapon /dev/mapper/myvolume-swap
}

if [ -d /run/archiso ]; then
  install_arch
else
  echo "nothing to do"
  exit 1
fi

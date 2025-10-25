#!/usr/bin/env bash

set -eu

install_arch() {
  echo "start installing Arch Linux"
  set -eux

  timedatectl set-ntp true

  # disk cleanup
  if ! systemd-detect-virt -q; then
    cryptsetup open --type plain /dev/sda container --key-file /dev/random
    dd if=/dev/zero of=/dev/mapper/container bs=8M status=progress || true
    cryptsetup close container
  fi

  # partition
  sgdisk --new 0::+1G --typecode 0:ef00 --change-name 0:boot /dev/sda  # EFI system
  sgdisk --new 0:: --typecode 0:8e00 --change-name 0:system /dev/sda  # Linux LVM

  # LUKS
  cryptsetup luksFormat /dev/sda2
  cryptsetup open --type luks /dev/sda2 cryptolvm

  # LVM
  pvcreate /dev/mapper/cryptolvm
  vgcreate system /dev/mapper/cryptolvm
  lvcreate -L "$(grep MemTotal /proc/meminfo | awk '{print $2}')K" system -n swap
  lvcreate -l 25%FREE system -n root
  lvcreate -l 100%FREE system -n home

  # format
  mkfs.ext4 /dev/system/root
  mkfs.ext4 /dev/system/home
  mkfs.fat -F 32 /dev/sda1
  mkswap /dev/system/swap

  # mount
  mount /dev/system/root /mnt
  mount --mkdir /dev/system/home /mnt/home
  mount --mkdir -o fmask=0137,dmask=0027 /dev/sda1 /mnt/boot
  swapon /dev/system/swap

  local packages=(base base-devel linux-zen lvm2 efibootmgr sudo networkmanager)
  if ! systemd-detect-virt -q; then
    packages+=(linux-firmware)
    if grep -q AuthenticAMD /proc/cpuinfo; then
      packages+=(amd-ucode)
    elif grep -q GenuineIntel /proc/cpuinfo; then
      packages+=(intel-ucode)
    fi
  fi
  pacstrap -K /mnt "${packages[@]}"

  genfstab -U /mnt >> /mnt/etc/fstab

  setup_arch_chroot() {
    set -eux

    passwd
    useradd -m -g users -G wheel -s /bin/bash futsuuu
    passwd futsuuu
    echo '%wheel ALL=(ALL:ALL) ALL' > /etc/sudoers.d/wheel

    # network
    echo myarchlinux > /etc/hostname
    systemctl enable NetworkManager.service

    # time zone
    ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
    hwclock --systohc

    # localization
    echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
    echo 'ja_JP.UTF-8 UTF-8' >> /etc/locale.gen
    locale-gen
    echo 'LANG=en_US.UTF-8' > /etc/locale.conf
    touch /etc/vconsole.conf

    # mkinitcpio
    sed -i \
      -e 's/^MODULES=.*/MODULES=(tpm_tis?)/' \
      -e 's/^HOOKS=.*/HOOKS=(base systemd autodetect microcode modconf kms keyboard sd-vconsole block sd-encrypt lvm2 filesystems fsck)/' \
      /etc/mkinitcpio.conf
    sed -i \
      -e 's/^PRESETS=.*/PRESETS=("default")/' \
      -e 's/^default_/#default_/' \
      -e 's/^fallback_/#fallback_/' \
      /etc/mkinitcpio.d/linux-zen.preset
    echo 'default_uki="/boot/EFI/Linux/arch-linux-zen.efi"' >> /etc/mkinitcpio.d/linux-zen.preset
    echo 'default_options="--splash=/usr/share/systemd/bootctl/splash-arch.bmp"' >> /etc/mkinitcpio.d/linux-zen.preset

    # kernel parameters
    local system_uuid=$(lsblk --filter 'PATH == "/dev/sda2"' --output UUID --noheadings)
    local kernel_params=""
    kernel_params+="rd.luks.name=${system_uuid}=cryptolvm "
    kernel_params+="rd.luks.options=${system_uuid}=tpm2-device-auto "
    kernel_params+="root=/dev/system/root "
    kernel_params+="rw quiet bgrt_disable"
    mkdir -p /etc/cmdline.d
    echo ${kernel_params} > /etc/cmdline.d/root.conf

    # initramfs
    rm -f /boot/initramfs-*.img
    mkdir -p /boot/EFI/Linux
    mkinitcpio -P

    # UEFI boot entry
    efibootmgr --create \
      --disk /dev/sda --part 1 \
      --label "Arch Linux" \
      --loader '\EFI\Linux\arch-linux-zen.efi' \
      --unicode
  }
  arch-chroot /mnt bash -c "$(declare -f setup_arch_chroot); setup_arch_chroot"

  reboot
}

if [ -d /run/archiso ]; then
  install_arch
else
  echo "nothing to do"
  exit 1
fi

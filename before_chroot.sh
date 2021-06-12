#!/usr/bin/env bash

# Print every line being executed
set -x

# Update the system clock
timedatectl set-ntp true

# Partition the disks
parted /dev/sda mklabel gpt
parted /dev/sda mkpart '"EFI system partition"' fat32 1MiB 261MiB
parted /dev/sda set 1 esp on

parted /dev/sda mkpart '"root partition"' ext4 261MiB 100%

# Format the partitions
mkfs.ext4 /dev/sda2

# Mount the file systems
mount /dev/sda2 /mnt

# cp arch-installation-main/root/etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist

# Install essential packages
sed -i -e 's/#\(Color\)/\1/g' -e 's/#\(ParallelDownloads = 5\)/\1/g' /etc/pacman.conf
pacstrap /mnt base linux linux-firmware

# Fstab
genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt < ./after_chroot.sh

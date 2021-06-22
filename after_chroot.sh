#!/usr/bin/env bash

# Print every line being executed
set -x

# Time zone
ln -sf /usr/share/zoneinfo/Region/America/New_York /etc/localtime
hwclock --systohc

# Localization
sed -i -e 's/#\(en_US.UTF-8 UTF-8\)/\1/g' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Initramfs
mkinitcpio -P

# Root password (and nafiz's password)
echo root:${ROOT_PASSWORD} | chpasswd
useradd -m nafiz
echo nafiz:${USER_PASSWORD} | chpasswd

# Boot loader
pacman --noconfirm -Syu grub efibootmgr
mkdir /mnt/efi
mount /dev/sda1 /mnt/efi
grub-install --target=x86_64-efi --efi-directory=/mnt/efi --bootloader-id=GRUB
pacman --noconfirm -Syu intel-ucode
grub-mkconfig -o /boot/grub/grub.cfg

# Install more packages
sed -i -e 's/#\(Color\)/\1/g' -e 's/#\(ParallelDownloads = 5\)/\1/g' /etc/pacman.conf
pacman --noconfirm -Syu man-db man-pages texinfo sudo linux-headers broadcom-wl-dkms iwd dhcpcd curl openssh neovim htop base-devel pacman-contrib git nvidia xorg xorg-xinit noto-fonts noto-fonts-cjk noto-fonts-emoji alsa-utils pulseaudio xclip 

# Enable systemd services
systemctl enable iwd
systemctl enable dhcpcd

# Setup sudo
sed -i -e 's/# \(Defaults targetpw\)/\1/' -e 's/# \(ALL ALL=(ALL) ALL\)/\1/' /etc/sudoers

# Setup Git's config
git config --global user.name 'nafiz1001'
git config --global user.email 'nafiz.islam1001@gmail.com'
git config --global init.defaultBranch 'main'
git config --global core.editor 'nvim'

chown -R nafiz /home/nafiz

su nafiz <<'EOF'
cd $HOME

# Set default speaker
echo defaults.pcm.card 1 > $HOME/.asoundrc
echo defaults.ctl.card 1 >> $HOME/.asoundrc

# Setup Git's config
git config --global user.name 'nafiz1001'
git config --global user.email 'nafiz.islam1001@gmail.com'
git config --global init.defaultBranch 'main'
git config --global core.editor 'nvim'
EOF

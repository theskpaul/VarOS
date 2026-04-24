#!/bin/bash

set -ouex pipefail

### Download package
wget https://downloads.zohocdn.com/arattai-desktop/linux/arattai-1.0.8_x86_64.rpm -O /tmp/arattai.rpm

### Workaround for buggy arattai RPM (self-conflicting cpio directory entry)
mkdir -p /opt/Arattai

### Install packages
dnf5 config-manager setopt rpmfusion-nonfree.enabled=1
dnf5 install /tmp/arattai.rpm -y

dnf5 remove -y libva-intel-media-driver

PACKAGES="toolbox \
         clamav \
         clamtk \
         igt-gpu-tools \
         intel-media-driver \
         gparted \
         gh \
         btop \
         alacritty \
         neovim"

dnf5 install -y $PACKAGES --skip-unavailable

dnf5 config-manager setopt rpmfusion-nonfree.enabled=0

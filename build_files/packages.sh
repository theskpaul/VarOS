#!/bin/bash

set -ouex pipefail

### Install packages
dnf5 config-manager setopt rpmfusion-nonfree.enabled=1

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
         neovim \
         falkon \
         glab"

dnf5 install -y $PACKAGES --skip-unavailable

dnf5 config-manager setopt rpmfusion-nonfree.enabled=0

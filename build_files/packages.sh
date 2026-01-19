#!/bin/bash

set -ouex pipefail

### Install packages
dnf5 config-manager setopt terra.enabled=1
dnf5 config-manager setopt rpmfusion-nonfree.enabled=1

dnf5 remove -y libva-intel-media-driver

PACKAGES="alacritty \
          bat \
          clang \
          neovim \
          gparted \
          thefuck \
          podman-compose \
          godot \
          zsh \
          zed \
          git \
          toolbox \
          zsh-autosuggestions \
          zsh-syntax-highlighting \
          gh \
          code \
          fuse-btrfs \
          android-tools \
          android-file-transfer \
          google-android-emoji-fonts \
          memtest86+ \
          smartmontools \
          plasma-firewall \
          ksyslog \
          kgpg \
          kcalc \
          okular \
          gwenview \
          persepolis \
          clamav \
          clamtk \
          btop \
          intel-media-driver"
          # docker \
          # docker-cli \
          # containerd \
          # docker-buildx \
          # docker-compose \
          # docker-compose-switch \

dnf5 install -y $PACKAGES --skip-unavailable

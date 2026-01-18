#!/bin/bash

set -ouex pipefail

### Install packages
dnf5 config-manager setopt terra.enabled=1

dnf5 install -y alacritty bat clang neovim docker docker-cli containerd docker-buildx docker-compose docker-compose-switch thefuck podman-compose godot mono-devel zsh zed git toolbox zsh-autosuggestions zsh-syntax-highlighting gh code btop --skip-unavailable

#### Example for enabling a System Unit File

systemctl enable podman.socket

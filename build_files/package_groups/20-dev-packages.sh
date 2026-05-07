#!/usr/bin/bash

set -xeuo pipefail

dnf5 --setopt=install_weak_deps=False install -y \
         toolbox \
         btop \
         gh \
         alacritty \
         neovim \
         android-tools \
         bcc \
         bpftop \
         bpftrace \
         ccache \
         flatpak-builder \
         git-subtree \
         podman-machine \
         podman-tui \
         python3-ramalama \
         restic \
         rclone \
         sysprof \
         tiptop \
         zsh

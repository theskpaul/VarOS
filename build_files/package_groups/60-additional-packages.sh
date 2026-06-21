#!/usr/bin/bash

set -xeuo pipefail
IFS=$'\n\t'
umask 022

dnf5 --setopt=install_weak_deps=False install -y \
    ptyxis \
    brave-browser

dnf5 config-manager setopt brave-browser.enabled=0
dnf5 config-manager setopt protonvpn-fedora-stable.enabled=0
dnf5 --setopt=install_weak_deps=False install --enable-repo="protonvpn-fedora-stable" -y \
    --setopt=tsflags=noscripts \
    proton-vpn-gnome-desktop

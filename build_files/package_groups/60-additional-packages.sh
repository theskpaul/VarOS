#!/usr/bin/bash

set -xeuo pipefail

dnf5 --setopt=install_weak_deps=False install -y \
    falkon

dnf5 config-manager setopt protonvpn-fedora-stable.enabled=0
dnf5 --setopt=install_weak_deps=False install --enable-repo="protonvpn-fedora-stable" -y \
    --setopt=tsflags=noscripts \
    proton-vpn-gnome-desktop

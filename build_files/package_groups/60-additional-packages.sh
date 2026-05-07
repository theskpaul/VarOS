#!/usr/bin/bash

set -xeuo pipefail

dnf5 upgrade -y

dnf5 --setopt=install_weak_deps=False install -y \
    falkon

dnf5 config-manager setopt protonvpn-fedora-stable.enabled=0
dnf5 install --enable-repo="protonvpn-fedora-stable" -y \
    proton-vpn-gnome-desktop

#!/bin/bash

set -ouex pipefail
IFS=$'\n\t'
umask 022

dnf5 install -y \
   nix \
   nix-daemon

# dnf5 remove -y \
#    plasma-login-manager

dnf5 --setopt=install_weak_deps=False install -y \
   bindfs \
   clamav \
   clamtk \
   igt-gpu-tools \
   gparted \
   irqbalance \
   uresourced \
   nicstat \
   numactl \
   usbmuxd \
   waypipe
   # sddm \
   # sddm-kcm \
   # sddm-breeze

dnf copr enable -y bieszczaders/kernel-cachyos-addons
dnf install ananicy-cpp -y

dnf5 config-manager setopt kernel-cachyos-addons.enabled=0

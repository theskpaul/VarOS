#!/bin/bash

set -ouex pipefail

mkdir -vp /var/nix
mount -vo defaults,noatime --bind /var/nix /nix

dnf5 install -y \
         nix \
         nix-daemon

dnf5 --setopt=install_weak_deps=False install -y \
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

# dnf5 remove -y libva-intel-media-driver
# intel-media-driver

# dnf5 config-manager setopt rpmfusion-nonfree.enabled=0

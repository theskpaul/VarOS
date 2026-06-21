#!/bin/bash

set -ouex pipefail
IFS=$'\n\t'
umask 022

dnf5 install -y \
   nix \
   nix-daemon


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

dnf install dnf-plugins-core
dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo

dnf copr enable -y bieszczaders/kernel-cachyos-addons
dnf install ananicy-cpp -y

dnf5 config-manager setopt copr:copr.fedorainfracloud.org:bieszczaders:kernel-cachyos-addons.enabled=0

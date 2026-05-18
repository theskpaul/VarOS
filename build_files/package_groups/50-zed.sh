#!/usr/bin/bash

set -xeuo pipefail
IFS=$'\n\t'
umask 022

dnf5 config-manager setopt terra.enabled=1
dnf5 --setopt=install_weak_deps=False install -y \
    zed

dnf5 config-manager setopt terra.enabled=0
dnf5 config-manager setopt terra-mesa.enabled=0

#!/usr/bin/bash

set -xeuo pipefail

dnf5 config-manager setopt terra.enabled=1
dnf5 --setopt=install_weak_deps=False install -y \
    zed

dnf5 config-manager setopt terra.enabled=0

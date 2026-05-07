#!/usr/bin/bash

set -xeuo pipefail

dnf5 --setopt=install_weak_deps=False install -y \
    falkon

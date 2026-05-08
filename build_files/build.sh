#!/bin/bash

set -ouex pipefail

SCRIPT_DIR="/ctx/package_groups"

# Run all package group scripts in order
for script in "$SCRIPT_DIR"/[0-9]*.sh; do
    echo "=== Running: $script ==="
    bash "$script"
done

# System configuration
echo "=== Running: sys-config.sh ==="
bash /ctx/sys-config.sh

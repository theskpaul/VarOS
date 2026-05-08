#!/bin/bash

set -ouex pipefail

# Enable Nix mount
systemctl enable nix.mount

# Daemons
systemctl enable podman.socket
systemctl enable docker.socket
systemctl enable me.proton.vpn.split_tunneling.service
systemctl enable sddm.service

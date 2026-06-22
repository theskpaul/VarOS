#!/bin/bash

set -ouex pipefail
IFS=$'\n\t'
umask 022

# Enable Nix mount
systemctl enable nix.mount
systemctl enable opt.mount
systemctl enable var-srv-shared_tmp.mount

# Daemons
systemctl enable podman.socket
systemctl enable docker.socket
systemctl enable me.proton.vpn.split_tunneling.service
systemctl enable ananicy-cpp

# systemctl enable sddm.service

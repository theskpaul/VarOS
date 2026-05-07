#!/bin/bash

set -ouex pipefail

# Daemons
systemctl enable podman.socket
systemctl enable docker.socket
systemctl enable me.proton.vpn.split_tunneling.service

#!/bin/bash

set -ouex pipefail

# Daemons
systemctl enable podman.socket
systemctl enable docker.socket
#

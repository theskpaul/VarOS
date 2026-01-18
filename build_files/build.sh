#!/bin/bash

set -ouex pipefail

#### Enabling a System Unit File

systemctl enable podman.socket

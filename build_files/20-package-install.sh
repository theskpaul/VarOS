#!/bin/bash
set -ouex pipefail

PACKAGES="toolbox \
         clamav \
         clamtk \
         igt-gpu-tools \
         gparted \
         gh \
         btop \
         alacritty \
         neovim \
         falkon \
         irqbalance \
         uresourced \
         android-tools \
         bcc \
         bpftop \
         bpftrace \
         ccache \
         flatpak-builder \
         git-subtree \
         nicstat \
         numactl \
         podman-machine \
         podman-tui \
         python3-ramalama \
         restic \
         rclone \
         sysprof \
         tiptop \
         usbmuxd \
         waypipe \
         zsh"

dnf5 --setopt=install_weak_deps=False install -y $PACKAGES

dnf5 config-manager addrepo --set=baseurl="https://packages.microsoft.com/yumrepos/vscode" --id="vscode"
dnf5 config-manager setopt vscode.enabled=0
# FIXME: gpgcheck is broken for vscode due to it using `asc` for checking
# seems to be broken on newer rpm security policies.
dnf5 config-manager setopt vscode.gpgcheck=0
dnf5 install --nogpgcheck --enable-repo="vscode" -y \
    code

docker_pkgs=(
    containerd.io
    docker-buildx-plugin
    docker-ce
    docker-ce-cli
    docker-compose-plugin
)
dnf5 config-manager addrepo --from-repofile="https://download.docker.com/linux/fedora/docker-ce.repo"
dnf5 config-manager setopt docker-ce-stable.enabled=0
dnf5 install -y --enable-repo="docker-ce-stable" "${docker_pkgs[@]}" || {
    # Use test packages if docker pkgs is not available for f42
    if (($(lsb_release -sr) == 42)); then
        echo "::info::Missing docker packages in f42, falling back to test repos..."
        dnf5 install -y --enablerepo="docker-ce-test" "${docker_pkgs[@]}"
    fi
}

# Load iptable_nat module for docker-in-docker.
# See:
#   - https://github.com/ublue-os/bluefin/issues/2365
#   - https://github.com/devcontainers/features/issues/1235
mkdir -p /etc/modules-load.d && cat >>/etc/modules-load.d/ip_tables.conf <<EOF
iptable_nat
EOF

dnf5 config-manager setopt terra.enabled=1
dnf5 --setopt=install_weak_deps=False install -y \
    zed

dnf5 config-manager setopt terra.enabled=0

# dnf5 remove -y libva-intel-media-driver
# intel-media-driver

# dnf5 config-manager setopt rpmfusion-nonfree.enabled=0

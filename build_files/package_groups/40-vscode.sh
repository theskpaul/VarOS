#!/usr/bin/bash

set -xeuo pipefail
IFS=$'\n\t'
umask 022

dnf5 config-manager addrepo --set=baseurl="https://packages.microsoft.com/yumrepos/vscode" --id="vscode"
dnf5 config-manager setopt vscode.enabled=0
# FIXME: gpgcheck is broken for vscode due to it using `asc` for checking
# seems to be broken on newer rpm security policies.
dnf5 config-manager setopt vscode.repo_gpgcheck=1
dnf5 config-manager setopt vscode.gpgcheck=1
dnf5 --setopt=install_weak_deps=False install --enable-repo="vscode" -y \
    code

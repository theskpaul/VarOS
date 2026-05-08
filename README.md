<div align="center">

```
██╗   ██╗ █████╗ ██████╗  ██████╗ ███████╗
██║   ██║██╔══██╗██╔══██╗██╔═══██╗██╔════╝
██║   ██║███████║██████╔╝██║   ██║███████╗
╚██╗ ██╔╝██╔══██║██╔══██╗██║   ██║╚════██║
 ╚████╔╝ ██║  ██║██║  ██║╚██████╔╝███████║
  ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝
```

**A hardened, opinionated Bazzite image built for people who know what they want.**

[![Build Status](https://github.com/USERNAME/VarOS/actions/workflows/build.yml/badge.svg)](https://github.com/USERNAME/VarOS/actions/workflows/build.yml)
[![Fedora 44](https://img.shields.io/badge/Fedora-44-blue?logo=fedora&logoColor=white)](https://fedoraproject.org/)
[![Based on Bazzite](https://img.shields.io/badge/Based%20on-Bazzite-purple?logo=linux&logoColor=white)](https://bazzite.gg/)
[![License](https://img.shields.io/badge/License-Apache%202.0-green)](LICENSE)
[![Signed with Cosign](https://img.shields.io/badge/Signed-Cosign-orange?logo=sigstore&logoColor=white)](https://sigstore.dev/)

</div>

---

## What is VarOS?

VarOS is a custom [bootc](https://containers.github.io/bootc/) image layered on top of [Bazzite](https://bazzite.gg/), tuned for a daily driver development and gaming workstation. It ships with a curated set of tools, hardened defaults, and zero bloat — built and signed automatically via GitHub Actions every day.

It is **not** a distro. It is a *declaration* — a reproducible, image-based OS that updates atomically and rolls back cleanly if anything breaks.

---

## What's Inside

### 🧱 Base
| Component | Detail |
|---|---|
| Base image | `ghcr.io/ublue-os/bazzite:stable` |
| Fedora version | 44 |
| Update model | Atomic / bootc |
| Init system | systemd |

### 📦 Packages

**System**
- `nix` + `nix-daemon` — reproducible dev environments without touching the base system
- `irqbalance`, `uresourced` — interrupt and resource scheduling optimizations
- `waypipe` — remote Wayland app forwarding
- `gparted`, `igt-gpu-tools` — disk and GPU diagnostics
- `usbmuxd` — iOS device support
- `clamav` + `clamtk` — antivirus

**Development**
- `neovim`, `zsh`, `alacritty` — terminal stack
- `btop` — system monitor
- `gh` — GitHub CLI
- `android-tools` — ADB/fastboot
- `bcc`, `bpftrace`, `bpftop` — eBPF tracing and profiling
- `sysprof`, `tiptop` — system and CPU profiling
- `ccache` — compiler cache
- `podman-tui`, `podman-machine` — container management
- `flatpak-builder` — build Flatpak apps
- `restic`, `rclone` — backup and cloud sync
- `python3-ramalama` — local LLM tooling
- `toolbox` — distrobox-style dev containers

**Editors**
- [VS Code](https://code.visualstudio.com/) — via Microsoft's official repo
- [Zed](https://zed.dev/) — via Terra repo

**Containers & Virtualization**
- Full Docker CE stack — `docker-ce`, `docker-ce-cli`, `containerd.io`, `docker-buildx-plugin`, `docker-compose-plugin`
- Podman socket enabled

**Network & Privacy**
- [ProtonVPN](https://protonvpn.com/) — GNOME desktop client with split tunneling enabled
- [Falkon](https://www.falkon.org/) — lightweight browser

---

## System Configuration

### 🔒 DNS
Privacy-first DNS with malware and adult content filtering, dual-stack (IPv4 + IPv6):

| Provider | IPv4 | IPv6 |
|---|---|---|
| Cloudflare for Families | `1.1.1.3`, `1.0.0.3` | `2606:4700:4700::1113`, `2606:4700:4700::1003` |
| Quad9 | `9.9.9.9`, `149.112.112.112` | `2620:fe::fe`, `2620:fe::9` |

### 💾 Memory
zRAM swap enabled at **¾ of RAM** with `zstd` compression, priority 100.

### 📡 Wi-Fi
Uses `wpa_supplicant` backend instead of `iwd` for broader hardware compatibility.

### ⌨️ Console
`ter-122b` font with `in-eng` keymap.

### 🗂️ Nix
Nix store lives at `/var/nix`, bind-mounted to `/nix` at boot. The `nix-daemon` and `nix.mount` unit start automatically.

---

## Build & CI

Images are built daily via GitHub Actions, rechunked with `rpm-ostree compose build-chunked-oci` for efficient OTA updates, and signed with [Cosign](https://sigstore.dev/).

- **Pull requests** — build only, no rechunk, no push
- **Push to main** — full build, rechunk, push to GHCR, sign
- **Scheduled (daily)** — skips the entire pipeline if the upstream `bazzite:stable` digest hasn't changed

```
Containerfile
└── build_files/
    ├── build.sh                         ← single entrypoint
    ├── sys-config.sh                    ← systemd unit enables
    └── package_groups/
        ├── 10-system-packages.sh
        ├── 20-dev-packages.sh
        ├── 30-docker-packages.sh
        ├── 40-vscode.sh
        ├── 50-zed.sh
        └── 60-additional-packages.sh
```

### Build locally

```bash
# Build the image
just build

# Build a QCOW2 VM image
just build-qcow2

# Run the VM
just run-vm

# Lint all shell scripts
just lint
```

---

## Installation

### Rebase from an existing ublue image

```bash
bootc switch --transport registry ghcr.io/USERNAME/varos:latest
```

### Verify the signature

```bash
cosign verify \
  --key cosign.pub \
  ghcr.io/USERNAME/varos:latest
```

---

## License

[Apache 2.0](LICENSE)

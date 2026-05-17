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

[![Build Status](https://github.com/theskpaul/VarOS/actions/workflows/build.yml/badge.svg)](https://github.com/theskpaul/VarOS/actions/workflows/build.yml)
[![Fedora 44](https://img.shields.io/badge/Fedora-44-blue?logo=fedora&logoColor=white)](https://fedoraproject.org/)
[![Based on Bazzite](https://img.shields.io/badge/Based%20on-Bazzite-purple?logo=linux&logoColor=white)](https://bazzite.gg/)
[![License](https://img.shields.io/badge/License-Apache%202.0-green)](LICENSE)
[![Signed with Cosign](https://img.shields.io/badge/Signed-Cosign-orange?logo=sigstore&logoColor=white)](https://sigstore.dev/)

</div>

---

## What is VarOS?

VarOS is a custom [bootc](https://containers.github.io/bootc/) image layered on top of [Bazzite](https://bazzite.gg/), tuned for a daily driver development and gaming workstation. It ships with a curated set of tools, hardened defaults, and zero bloat — built and signed automatically via GitHub Actions on every push to main.

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
| Display manager | SDDM (replaces `plasma-login-manager`) |

### 📦 Packages

**System**
- `nix` + `nix-daemon` — reproducible dev environments without touching the base system
- `irqbalance`, `uresourced` — interrupt and resource scheduling optimizations
- `nicstat`, `numactl` — network and NUMA statistics
- `waypipe` — remote Wayland app forwarding
- `gparted`, `igt-gpu-tools` — disk and GPU diagnostics
- `usbmuxd` — iOS device support
- `clamav` + `clamtk` — antivirus
- `bindfs` — userspace bind mounts (used for shared game/ComfyUI storage)
- `sddm`, `sddm-kcm`, `sddm-breeze` — display manager

**Development**
- `neovim`, `zsh`, `alacritty` — terminal stack
- `ptyxis` — GNOME terminal emulator
- `btop` — system monitor
- `gh` — GitHub CLI
- `android-tools` — ADB/fastboot
- `bcc`, `bpftrace`, `bpftop` — eBPF tracing and profiling
- `sysprof`, `tiptop` — system and CPU profiling
- `ccache` — compiler cache
- `git-subtree` — git subtree tooling
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
Nix store lives at `/var/nix`, bind-mounted to `/nix` at boot via `nix.mount`. The unit starts automatically on `local-fs.target`.

### 🎮 Shared Game Storage
Games are stored on a separate btrfs subvolume at `/var/srv/games` and exposed per-user at `~/Games` via `bindfs`. The `games-bindfs@.service` template mounts the shared subvolume for each user with ownership remapped so Steam, Proton, and pressure-vessel all behave correctly.

```bash
systemctl enable --now games-bindfs@<username>.service
```

Point Steam's library at `~/Games` rather than the subvolume directly.

### 🤖 Shared ComfyUI Storage
The same pattern applies to ComfyUI via `comfy-bindfs@.service`, mounting `/var/srv/comfyui` at `~/Comfy/ComfyUI` per user.

```bash
systemctl enable --now comfy-bindfs@<username>.service
```

### 📷 Webcam
`uvcvideo` is blacklisted by default. To re-enable it temporarily:

```bash
sudo modprobe uvcvideo
```

Or remove `/etc/modprobe.d/blacklist.conf` from a layered override to make it permanent.

### 🖊️ Default Editor
`$EDITOR` is set to `/usr/bin/vim` system-wide via `/etc/environment`.

---

## Build & CI

Images are built via GitHub Actions on every push to `main`, rechunked with `rpm-ostree compose build-chunked-oci` for efficient OTA updates, signed with [Cosign](https://sigstore.dev/) v2.6.3, and pushed to GHCR.

- **Pull requests** — build only, no rechunk, no push, no signing
- **Push to main** — full build, rechunk, push to GHCR (`:latest` + versioned tag), sign both tags
- **`workflow_dispatch`** — manual trigger, same as push to main
- **Paths ignored** — changes to `**.md`, `**.txt`, and `docs/**` do not trigger a build

Dependency updates are managed automatically — GitHub Actions pins are updated weekly via [Dependabot](https://docs.github.com/en/code-security/dependabot), and broader dependency updates are handled by [Renovate](https://docs.renovatebot.com/) with automerge enabled for digest pins.

### Repository layout

```
Containerfile
├── build_files/
│   ├── sys-config.sh                    ← systemd unit enables
│   ├── 999-cleanup.sh                   ← final cache/tmp purge + bootc lint
│   └── package_groups/
│       ├── 10-system-packages.sh
│       ├── 20-dev-packages.sh
│       ├── 30-docker-packages.sh
│       ├── 40-vscode.sh
│       ├── 50-zed.sh
│       └── 60-additional-packages.sh
└── system_files/
    ├── etc/                             ← dropped into /etc at image build time
    └── usr/                             ← dropped into /usr at image build time
```

### Build locally

```bash
# Build the container image
just build

# Build a QCOW2 / RAW / ISO VM image
just build-qcow2
just build-raw
just build-iso

# Rebuild (container + VM image in one step)
just rebuild-qcow2

# Run a QCOW2 VM (opens browser UI on an available port)
just run-vm

# Run via systemd-vmspawn
just spawn-vm

# Lint all shell scripts with shellcheck
just lint

# Format all shell scripts with shfmt
just format
```

---

## Installation

### Rebase from an existing ublue image

```bash
bootc switch --transport registry ghcr.io/theskpaul/varos:latest
```

### Verify the image signature

```bash
cosign verify \
  --key cosign.pub \
  ghcr.io/theskpaul/varos:latest
```

The public key is committed to this repo as [`cosign.pub`](cosign.pub).

---

## License

[Apache 2.0](LICENSE)

---

## Acknowledgements

VarOS was originally bootstrapped from the [uBlue image-template](https://github.com/ublue-os/image-template) and builds upon the broader Universal Blue ecosystem. VarOS has since diverged substantially and is maintained as a personal workstation-focused image.

Parts of the configuration and workflow were also inspired by or adapted from:
- [Bazzite](https://bazzite.gg/)
- [Bazzite DX](https://github.com/ublue-os/bazzite-dx)

AI tools were used during parts of development and documentation.

FROM scratch AS ctx
COPY build_files /

FROM ghcr.io/ublue-os/bazzite:stable

# Copy ONLY files that package install scripts depend on at build time.
# Changing other files in system_files/ won't invalidate package layers.
COPY system_files/etc/yum.repos.d/ /etc/yum.repos.d/
COPY system_files/etc/systemd/system/ /etc/systemd/system/

# Layer 1: Stable system/hardware packages
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/package_groups/10-system-packages.sh

# ... layers 2-5 unchanged ...

# Layer 6: Additional packages — needs protonvpn-stable.repo from above
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/package_groups/60-additional-packages.sh

# Layer 7: sys-config
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/sys-config.sh

# Remaining system files last — DNS, zram, environment, modprobe, etc.
# Changing any of these only invalidates this layer, not the package layers.
COPY system_files /

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/999-cleanup.sh

RUN bootc container lint

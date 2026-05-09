FROM scratch AS ctx

FROM ghcr.io/ublue-os/bazzite:stable

# Copy ONLY files that package install scripts depend on at build time.
# Changing other files in system_files/ won't invalidate package layers.
COPY system_files/etc/systemd/system/ /etc/systemd/system/

COPY build_files/10-system-packages.sh /
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/package_groups/10-system-packages.sh

COPY build_files/20-dev-packages.sh /
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/package_groups/20-dev-packages.sh

COPY build_files/30-docker-packages.sh /
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/package_groups/30-docker-packages.sh

COPY build_files/40-vscode.sh /
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/package_groups/40-vscode.sh

COPY build_files/50-zed.sh /
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/package_groups/50-zed.sh

COPY system_files/etc/yum.repos.d/protonvpn-stable.repo /etc/yum.repos.d/
COPY build_files/60-additional-packages.sh /
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/package_groups/60-additional-packages.sh

COPY build_files/sys-config.sh /
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/sys-config.sh

COPY system_files /

COPY build_files/999-cleanup.sh /
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/999-cleanup.sh

RUN bootc container lint

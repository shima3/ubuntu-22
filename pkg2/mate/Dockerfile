# ARG OS_VERSION="ubuntu22"
# -----------------------------------------------------------------------------
# FROM ${OS_VERSION}utils AS update-stage
FROM utils AS update-stage
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get clean

COPY --from=pkg:xrdp / /
RUN /install && rm /install

RUN apt-get clean
RUN apt-get update

# ---------------------------------------------------------
FROM update-stage AS download-stage
# ARG PACKAGE="mate-desktop-environment ubuntu-mate-desktop"
ARG PACKAGE

# RUN apt-get install --yes --download-only $PACKAGE
RUN apt-get install --yes --download-only --fix-broken --fix-missing $PACKAGE
RUN tar Jcf /pkg.tar.xz /var/cache/apt/archives /var/lib/apt/lists

RUN echo 'apt-get clean' > /install
RUN echo 'tar Jxf /pkg.tar.xz && rm /pkg.tar.xz' >> /install
RUN echo "apt-get install --yes --no-download --fix-broken $PACKAGE" >> /install
# RUN echo 'dpkg -i /var/cache/apt/archives/*.deb' >> /install
# blueman-appletがクラッシュする。bluetooth機能なので不要
# RUN echo 'apt-get remove --purge --yes blueman' >> /install
RUN echo 'apt-get remove --purge --yes blueman mate-power-manager thermald ayatana-indicator-datetime' >> /install
RUN echo 'apt-get autoremove --purge' >> /install
RUN echo 'apt-get autoclean' >> /install
# ログイン時のアップデート通知を無効にする
RUN echo "if [ -e /etc/update-manager/release-upgrades ]; then sed -i -e 's/^Prompt=.*$/Prompt=never/g' /etc/update-manager/release-upgrades; fi" >> /install
RUN chmod +x /install

# ---------------------------------------------------------
FROM scratch AS package-stage
LABEL maintainer="Kazuyuki Shima <shima@hiroshima-cu.ac.jp>"

COPY --from=download-stage /pkg.tar.xz /
COPY --from=download-stage /install /

# ---------------------------------------------------------
FROM update-stage AS test-stage

COPY --from=package-stage / /
RUN /install

EXPOSE 3389

# CMD ["/usr/bin/supervisord", "-nc", "/etc/supervisor/supervisord.conf"]

# FROM ubuntu AS update-stage
FROM utils AS update-stage
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get clean

COPY --from=pkg:xrdp / /
RUN /install && rm /install

# COPY --from=pkg:mate / /
# RUN /install && rm /install

# COPY --from=pkg:japanese / /
# RUN /install && rm /install

RUN apt-get clean
RUN add-apt-repository ppa:xtradeb/apps -y
RUN apt-get update -y

# -----------------------------------------------------------------------------
FROM update-stage AS download-stage
# ARG DEBIAN_FRONTEND=noninteractive
ARG PACKAGE
# ARG TARGETARCH

# RUN wget --output-document=/chromium.deb "http://ftp.debian.org/debian/pool/main/c/chromium/chromium_134.0.6998.117-1_$TARGETARCH.deb"
RUN apt-get install --yes --download-only --fix-missing $PACKAGE
# COPY 99keyring /etc/X11/Xsession.d/99keyring
# RUN tar Jcf /pkg.tar.xz /var/cache/apt/archives /var/lib/apt/lists /etc/X11/Xsession.d/99keyring
COPY chromium.sh /usr/bin/
RUN tar Jcf /pkg.tar.xz /var/cache/apt/archives /var/lib/apt/lists /usr/bin/chromium.sh

RUN echo 'add-apt-repository ppa:xtradeb/apps -y' > /install
RUN echo 'tar Jxf /pkg.tar.xz && rm /pkg.tar.xz' >> /install
RUN echo "apt-get install --yes --no-download $PACKAGE" >> /install
RUN echo 'mv /usr/bin/chromium /usr/bin/chromium.org' >> /install
RUN echo 'mv /usr/bin/chromium.sh /usr/bin/chromium' >> /install
RUN echo 'apt-get autoclean' >> /install
RUN chmod +x /install

# -----------------------------------------------------------------------------
FROM scratch AS package-stage
LABEL maintainer="Kazuyuki Shima <shima@hiroshima-cu.ac.jp>"

COPY --from=download-stage /pkg.tar.xz /
COPY --from=download-stage /install /

# -----------------------------------------------------------------------------
FROM update-stage AS test-stage

# EXPOSE 3389
# CMD ["/usr/bin/supervisord", "-nc", "/etc/supervisor/supervisord.conf"]

COPY --from=package-stage / /
RUN /install

COPY --from=pkg:mate / /
RUN /install

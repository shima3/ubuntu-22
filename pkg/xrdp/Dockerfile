# ARG BASE_IMAGE="ubuntu22utils"
# -----------------------------------------------------------------------------
# FROM $BASE_IMAGE AS download-stage
FROM utils AS download-stage
ARG DEBIAN_FRONTEND="noninteractive"
# ARG PACKAGE="dbus-x11 xauth xorg xorgxrdp xrdp xserver-xorg alsa-utils libpulse-dev pulseaudio pulseaudio-utils"
ARG PACKAGE

RUN apt-get clean && apt-get update

RUN apt-get install --yes --fix-missing --download-only $PACKAGE
RUN echo "apt-get install --yes --fix-missing --no-download $PACKAGE" > /tmp/install

# -----------------------------------------------------------------------------
FROM download-stage AS build-stage
ARG DEBIAN_FRONTEND="noninteractive"

RUN sh /tmp/install

RUN curl -s -L https://github.com/neutrinolabs/pulseaudio-module-xrdp/archive/v0.7.tar.gz | tar zx -C /opt/ \
    && mv /opt/pulseaudio-module-xrdp* /opt/pulseaudio-module-xrdp \
    && cd /opt/pulseaudio-module-xrdp \
    && ./scripts/install_pulseaudio_sources_apt.sh -d /opt/pulseaudio.src \
    && ./bootstrap \
    && ./configure PULSE_DIR=/opt/pulseaudio.src prefix=/usr \
    && make

# -----------------------------------------------------------------------------
FROM download-stage AS archive-stage
ARG DEBIAN_FRONTEND="noninteractive"

COPY --from=build-stage /opt/pulseaudio-module-xrdp/src/*.la /opt/pulseaudio-module-xrdp/
COPY --from=build-stage /opt/pulseaudio-module-xrdp/src/.libs/*.so /opt/pulseaudio-module-xrdp/
COPY --from=build-stage /opt/pulseaudio-module-xrdp/instfiles/load_pa_modules.sh /opt/pulseaudio-module-xrdp/
COPY --from=build-stage /opt/pulseaudio-module-xrdp/instfiles/pulseaudio-xrdp.desktop /opt/pulseaudio-module-xrdp/
COPY xrdp.conf /etc/supervisor/conf.d/
COPY dbus.conf /etc/supervisor/conf.d/

RUN tar Jcf /pkg.tar.xz /var/cache/apt/archives /var/lib/apt/lists /opt/pulseaudio-module-xrdp /etc/supervisor/conf.d

RUN echo 'tar Jxf /pkg.tar.xz && rm /pkg.tar.xz' > /install
COPY config.sh /tmp/
RUN cat /tmp/install /tmp/config.sh >> /install
RUN chmod +x /install

# -----------------------------------------------------------------------------
FROM scratch AS package-stage
LABEL maintainer="Kazuyuki Shima <shima@hiroshima-cu.ac.jp>"

COPY --from=archive-stage /pkg.tar.xz /
COPY --from=archive-stage /install /

# -----------------------------------------------------------------------------
# FROM $BASE_IMAGE AS install-stage
FROM utils AS test-stage
ARG DEBIAN_FRONTEND="noninteractive"

COPY --from=package-stage / /
RUN /install

# CMD ["/usr/bin/supervisord", "-nc", "/etc/supervisor/supervisord.conf"]

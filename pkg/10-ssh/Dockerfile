# FROM utils AS update-stage
FROM base AS update-stage

RUN apt-get clean && apt-get update

# ------------------------------------------------------------------
FROM update-stage AS download-stage
ARG DEBIAN_FRONTEND="noninteractive"
# ARG PACKAGES="openssh-server"
ARG PACKAGE

RUN apt-get install --yes --download-only --fix-missing $PACKAGE

# RUN rm /etc/supervisor/conf.d/*
# COPY sshd.conf /etc/supervisor/conf.d/sshd.conf
COPY supervisor/ /etc/supervisor/conf.d/
COPY rsyslog.conf /tmp/rsyslog.conf

RUN tar Jcf /pkg.tar.xz var/cache/apt/archives var/lib/apt/lists etc/supervisor/conf.d tmp/rsyslog.conf

RUN echo "tar Jxf /pkg.tar.xz && rm /pkg.tar.xz" > /install
RUN echo "apt-get install --yes --no-download $PACKAGE" >> /install
RUN echo "mkdir /var/run/sshd" >> /install
RUN echo "sed -i 's/#PasswordAuthentication/PasswordAuthentication/' /etc/ssh/sshd_config" >> /install
# SSH login fix. Otherwise user is kicked off after login
RUN echo "sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd" >> /install
RUN echo 'mv /tmp/rsyslog.conf /etc' >> /install
# RUN echo 'groupadd -r syslog && useradd -r -g syslog --system syslog' >> /install

RUN chmod +x /install

# ------------------------------------------------------------------
FROM scratch AS package-stage
LABEL maintainer="Kazuyuki Shima <shima@hiroshima-cu.ac.jp>"

COPY --from=download-stage /pkg.tar.xz /
COPY --from=download-stage /install /

# ------------------------------------------------------------------
FROM update-stage AS test-stage
ARG DEBIAN_FRONTEND="noninteractive"

COPY --from=package-stage / /
RUN /install
EXPOSE 22

# CMD ["/usr/bin/supervisord", "-nc", "/etc/supervisor/supervisord.conf"]

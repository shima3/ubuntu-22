FROM base AS download-stage
ARG PACKAGE

RUN apt-get update
RUN apt-get install --yes --download-only --fix-missing $PACKAGE

COPY opam.sh /etc/profile.d/
RUN tar Jcf /pkg.tar.xz /var/cache/apt/archives /var/lib/apt/lists /etc/profile.d/opam.sh

RUN echo 'tar Jxf /pkg.tar.xz && rm /pkg.tar.xz' > /install
RUN echo "apt-get install --yes --no-download --no-install-recommends $PACKAGE" >> /install
RUN echo 'apt-get autoclean' >> /install
RUN echo 'useradd -d /opt/opam -m -s /bin/bash opam' >> /install
RUN echo 'sudo -u opam opam init --disable-sandboxing --auto-setup --yes' >> /install
# RUN echo 'echo export PATH="$PATH:/opt/opam/.opam/default/bin" > /etc/profile.d/opam.sh' >> /install
# RUN echo 'chmod +x /etc/profile.d/opam.sh' >> /install
# RUN echo '. /etc/profile.d/opam.sh' >> /install
RUN echo 'chmod a+rx /opt/opam' >> /install
RUN chmod +x /install

# -----------------------------------------------------------------------------
FROM scratch AS package-stage
LABEL maintainer="Kazuyuki Shima <shima@hiroshima-cu.ac.jp>"

COPY --from=download-stage /pkg.tar.xz /
COPY --from=download-stage /install /

# ------------------------------------------------------------------
FROM base AS test-stage

COPY --from=package-stage / /
# RUN /install

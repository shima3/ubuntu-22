FROM base AS update-stage
ARG DEBIAN_FRONTEND=noninteractive

COPY --from=pkg:opam / /
RUN /install && rm /install

# -----------------------------------------------------------------------------
FROM update-stage AS download-stage

RUN sudo -u opam opam --yes install --download-only frama-c

RUN tar Jcf /pkg.tar.xz /opt/opam/.opam/download-cache

RUN echo 'tar Jxf /pkg.tar.xz && rm /pkg.tar.xz' > /install
RUN echo 'sudo -u opam opam init --disable-sandboxing --auto-setup --yes' >> /install
RUN echo 'sudo -u opam opam --yes install frama-c' >> /install
RUN chmod +x /install

# -----------------------------------------------------------------------------
FROM scratch AS package-stage
LABEL maintainer="Kazuyuki Shima <shima@hiroshima-cu.ac.jp>"

COPY --from=download-stage /pkg.tar.xz /
COPY --from=download-stage /install /

# -----------------------------------------------------------------------------
FROM update-stage

COPY --from=package-stage / /
RUN /install

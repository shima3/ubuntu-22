# FROM ubuntu AS update-stage
FROM utils AS update-stage
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get clean

COPY --from=pkg:xrdp / /
RUN /install && rm /install

RUN apt-get clean && apt-get update -y

# -----------------------------------------------------------------------------
FROM update-stage AS download-stage
ARG PACKAGE

RUN apt-get install --yes --download-only --fix-missing $PACKAGE

RUN tar Jcf /pkg.tar.xz /var/cache/apt/archives /var/lib/apt/lists

RUN echo 'tar Jxf /pkg.tar.xz && rm /pkg.tar.xz' > /install
RUN echo "apt-get install --yes --no-download $PACKAGE" >> /install
RUN echo 'apt-get autoclean' >> /install
RUN chmod +x /install

# -----------------------------------------------------------------------------
FROM scratch AS package-stage
LABEL maintainer="Kazuyuki Shima <shima@hiroshima-cu.ac.jp>"

COPY --from=download-stage /pkg.tar.xz /
COPY --from=download-stage /install /

# -----------------------------------------------------------------------------
FROM update-stage
# ARG PACKAGE

COPY --from=package-stage / /
RUN /install

COPY --from=pkg:mate / /
RUN /install

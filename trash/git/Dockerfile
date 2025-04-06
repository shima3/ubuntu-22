# FROM ubuntu AS update-stage
FROM utils AS download-stage
ARG DEBIAN_FRONTEND="noninteractive"
ARG PACKAGE

RUN apt-get install --yes --download-only --fix-missing $PACKAGE
RUN tar Jcf /pkg.tar.xz /var/cache/apt/archives /var/lib/apt/lists

RUN echo "tar Jxf /pkg.tar.xz && rm /pkg.tar.xz" > /install
RUN echo "apt-get install --yes --no-download $PACKAGES" >> /install
RUN chmod +x /install

# ------------------------------------------------------------------
FROM scratch AS package-stage
LABEL maintainer="Kazuyuki Shima <shima@hiroshima-cu.ac.jp>"

COPY --from=download-stage /pkg.tar.xz /
COPY --from=download-stage /install /

# ------------------------------------------------------------------
# FROM update-stage
FROM utils AS test-stage
ARG DEBIAN_FRONTEND=noninteractive

COPY --from=package-stage / /
RUN /install

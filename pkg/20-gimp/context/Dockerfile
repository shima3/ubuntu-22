# FROM utils AS update-stage
FROM base AS update-stage
ARG DEBIAN_FRONTEND="noninteractive"

RUN apt-get clean

COPY --from=pkg:xrdp / /
RUN /install && rm /install

RUN apt-get clean
# RUN apt-get update

# ------------------------------------------------------------------
FROM update-stage AS download-stage
ARG DEBIAN_FRONTEND="noninteractive"
ARG PACKAGE

# RUN apt-get install --yes --download-only --fix-missing $PACKAGE
RUN apt-get update && apt-get install --yes --download-only --fix-missing $PACKAGE
RUN tar Jcf /pkg.tar.xz /var/cache/apt/archives /var/lib/apt/lists

RUN echo 'tar Jxf /pkg.tar.xz && rm /pkg.tar.xz' > /install
RUN echo "apt-get install --yes --no-download $PACKAGE" >> /install
RUN chmod +x /install

# ------------------------------------------------------------------
FROM scratch AS package-stage
LABEL maintainer="Kazuyuki Shima <shima@hiroshima-cu.ac.jp>"

COPY --from=download-stage /pkg.tar.xz /
COPY --from=download-stage /install /

# ------------------------------------------------------------------
FROM update-stage AS test-stage
ARG DEBIAN_FRONTEND="noninteractive"

COPY --from=pkg:mate / /
RUN /install

COPY --from=package-stage / /
RUN /install

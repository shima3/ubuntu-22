FROM base AS download-stage
ARG DEBIAN_FRONTEND="noninteractive"
ARG PACKAGE

RUN apt-get clean && apt-get update
RUN apt-get install --yes --download-only --fix-missing $PACKAGE
COPY / /context
RUN tar Jcf /pkg.tar.xz /var/cache/apt/archives /var/lib/apt/lists --directory=/context .

RUN echo 'tar Jxf /pkg.tar.xz && rm /pkg.tar.xz' > /install
RUN echo "apt-get install --yes --no-download $PACKAGE" >> /install
# RUN echo 'tar Jxf /context.tar.xz && rm /context.tar.xz' >> /install
RUN chmod +x /install

# ------------------------------------------------------------------
FROM scratch AS package-stage
LABEL maintainer="Kazuyuki Shima <shima@hiroshima-cu.ac.jp>"

COPY --from=download-stage /pkg.tar.xz /
# COPY --from=download-stage /context.tar.xz /
COPY --from=download-stage /install /

# ------------------------------------------------------------------
FROM base AS test-stage
ARG DEBIAN_FRONTEND="noninteractive"

COPY --from=package-stage / /
# RUN /install && rm /install
RUN /install
# EXPOSE 80

FROM utils AS download-stage
ARG DEBIAN_FRONTEND=noninteractive
ARG PACKAGE

# RUN apt-get clean && apt-get update
# RUN apt-get install --yes --download-only --fix-missing gcc g++
RUN apt-get install --yes --download-only --fix-missing $PACKAGE
RUN tar Jcf /pkg.tar.xz /var/cache/apt/archives /var/lib/apt/lists

RUN echo 'tar Jxf /pkg.tar.xz && rm /pkg.tar.xz' > /install
# RUN echo 'apt-get install --yes --no-download --no-install-recommends gcc g++' >> /install
RUN echo "apt-get install --yes --no-download $PACKAGE" >> /install
RUN chmod +x /install

# ------------------------------------------------------------------
FROM scratch AS package-stage
# MAINTAINER Kazuyuki Shima <shima@hiroshima-cu.ac.jp>
LABEL maintainer="Kazuyuki Shima <shima@hiroshima-cu.ac.jp>"

COPY --from=download-stage /pkg.tar.xz /
COPY --from=download-stage /install /

# ------------------------------------------------------------------
# FROM xz-utils AS install-stage
FROM utils AS test-stage
ARG DEBIAN_FRONTEND=noninteractive

COPY --from=package-stage / /
RUN /install

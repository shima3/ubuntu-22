FROM base AS download-stage
ARG DEBIAN_FRONTEND="noninteractive"

# RUN cd /opt && curl -sSL https://get.haskellstack.org/ | sh
RUN ARCH=`uname -m` && URL=`curl https://get.haskellstack.org/stable/linux-$ARCH.tar.gz | awk '{print $3;}'` && wget --output-document=/pkg.tar.gz $URL
# https://github.com/commercialhaskell/stack/releases/download/v3.7.1/stack-3.7.1-linux-aarch64.tar.gz

RUN echo 'cd /opt && tar zxf /pkg.tar.gz && rm /pkg.tar.gz' > /install
RUN echo 'ln -s /opt/stack-*/stack /usr/bin' >> /install

RUN chmod +x /install

# ------------------------------------------------------------------
FROM scratch AS package-stage
LABEL maintainer="Kazuyuki Shima <shima@hiroshima-cu.ac.jp>"

COPY --from=download-stage /pkg.tar.gz /
COPY --from=download-stage /install /

# ------------------------------------------------------------------
FROM base AS test-stage
ARG DEBIAN_FRONTEND="noninteractive"

COPY --from=package-stage / /
RUN /install

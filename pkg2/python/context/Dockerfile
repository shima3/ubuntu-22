FROM utils AS clean-stage
ARG DEBIAN_FRONTEND="noninteractive"

RUN apt-get clean

# RUN apt-get clean

# ------------------------------------------------------------------
FROM clean-stage AS download-stage
ARG DEBIAN_FRONTEND="noninteractive"
ARG PACKAGE

RUN apt-get update
RUN apt-get install --yes --download-only --fix-missing $PACKAGE
RUN tar cf /pkg.tar /var/cache/apt/archives /var/lib/apt/lists

RUN apt-get install --yes --no-download $PACKAGE
RUN pip3 download pygame -d /opt/python
RUN tar rf /pkg.tar /opt/python && xz /pkg.tar

RUN echo 'tar Jxf /pkg.tar.xz && rm /pkg.tar.xz' > /install
RUN echo "apt-get install --yes --no-download $PACKAGE" >> /install
RUN echo 'pip3 install --no-index --find-links=/opt/python pygame' >> /install
RUN chmod +x /install

# ------------------------------------------------------------------
FROM scratch AS package-stage
LABEL maintainer="Kazuyuki Shima <shima@hiroshima-cu.ac.jp>"

COPY --from=download-stage /pkg.tar.xz /
COPY --from=download-stage /install /

# ------------------------------------------------------------------
FROM clean-stage AS test-stage
ARG DEBIAN_FRONTEND="noninteractive"

COPY --from=pkg:xrdp / /
RUN /install && rm /install

COPY --from=pkg:mate / /
RUN /install

COPY --from=package-stage / /
RUN /install

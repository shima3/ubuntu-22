# FROM ubuntu AS update-stage
FROM utils AS update-stage
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get clean

COPY --from=pkg:xrdp / /
RUN /install && rm /install

# COPY --from=pkg:mate / /
# RUN /install && rm /install

# COPY --from=pkg:japanese / /
# RUN /install && rm /install

RUN apt-get clean && apt-get update -y

# -----------------------------------------------------------------------------
FROM update-stage AS download-stage
ARG DEBIAN_FRONTEND=noninteractive

# COPY vscode.deb /

# RUN echo 'dpkg -i /vscode.deb' > /install
RUN echo 'apt-get install --yes /vscode.deb' > /install
RUN echo 'rm /vscode.deb' >> /install
# RUN echo "apt --fix-broken install -y code" >> /install
# RUN echo 'apt-get autoclean' >> /install
RUN chmod +x /install

# -----------------------------------------------------------------------------
FROM scratch AS package-stage
LABEL maintainer="Kazuyuki Shima <shima@hiroshima-cu.ac.jp>"

# COPY --from=download-stage /pkg.tar.xz /
# COPY --from=download-stage /vscode.deb /
COPY vscode.deb /
COPY --from=download-stage /install /

# -----------------------------------------------------------------------------
FROM update-stage AS test-stage
ARG DEBIAN_FRONTEND=noninteractive

COPY --from=package-stage / /
RUN /install

COPY --from=pkg:mate / /
RUN /install

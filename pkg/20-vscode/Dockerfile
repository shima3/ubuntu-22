FROM base AS clean-stage
ARG DEBIAN_FRONTEND=noninteractive

COPY --from=pkg:xrdp / /
RUN /install && rm /install

# RUN apt-get clean && apt-get update -y
RUN apt-get clean

# -----------------------------------------------------------------------------
FROM clean-stage AS download-stage
ARG DEBIAN_FRONTEND=noninteractive
ARG TARGETARCH

# RUN wget 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64' -O vscode.deb
COPY wget-vscode-$TARGETARCH.sh wget-vscode.sh
RUN sh wget-vscode.sh

RUN echo 'apt-get install --yes /vscode.deb' > /install
RUN echo 'rm /vscode.deb' >> /install
RUN chmod +x /install

# -----------------------------------------------------------------------------
FROM scratch AS package-stage
LABEL maintainer="Kazuyuki Shima <shima@hiroshima-cu.ac.jp>"

# COPY --from=download-stage /pkg.tar.xz /
COPY --from=download-stage /vscode.deb /
# COPY vscode.deb /
COPY --from=download-stage /install /

# -----------------------------------------------------------------------------
FROM clean-stage AS test-stage
ARG DEBIAN_FRONTEND=noninteractive

COPY --from=package-stage / /
RUN /install

COPY --from=pkg:mate / /
RUN /install

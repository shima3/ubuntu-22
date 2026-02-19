FROM base AS download-stage
ARG DEBIAN_FRONTEND="noninteractive"

RUN git clone https://github.com/nvm-sh/nvm.git /opt/nvm && cd /opt/nvm && commit=`git rev-list --tags --max-count=1` && ver=`git describe --abbrev=0 --tags --match "v[0-9]*" $commit` && git checkout $ver && rm -fr .git
RUN bash -c '. /opt/nvm/nvm.sh && nvm install --lts node'

# RUN echo 'export NVM_DIR=/opt/nvm; . $NVM_DIR/nvm.sh' > /etc/profile.d/nodejs.sh
RUN echo 'export NVM_DIR=/opt/nvm' > /etc/profile.d/nodejs.sh
RUN echo '. $NVM_DIR/nvm.sh' >> /etc/profile.d/nodejs.sh

# configurable-http-proxyのインストールのため
# corepackとyarnをインストールしたが、
# npmでもインストールできたので
# corepackとyarnはインストールしない。
# RUN echo 'export COREPACK_HOME=/opt/corepack' >> /etc/profile.d/nodejs.sh
# RUN echo 'corepack enable' >> /etc/profile.d/nodejs.sh
# RUN echo 'corepack prepare yarn@stable --activate' >> /etc/profile.d/nodejs.sh

# RUN . /etc/profile.d/nodejs.sh && export COREPACK_HOME=/opt/corepack && corepack prepare yarn@stable
RUN . /etc/profile.d/nodejs.sh

# RUN tar Jcf /pkg.tar.xz opt/nvm etc/profile.d/nodejs.sh /opt/corepack
RUN tar Jcf /pkg.tar.xz opt/nvm etc/profile.d/nodejs.sh

RUN echo 'tar Jxf /pkg.tar.xz && rm /pkg.tar.xz' > /install
RUN echo '. /etc/profile.d/nodejs.sh' >> /install
RUN echo 'ln -s $NVM_DIR/versions/node/$(nvm version default) /opt/nodejs' >> /install

RUN chmod +x /install

# ------------------------------------------------------------------
FROM scratch AS package-stage
LABEL maintainer="Kazuyuki Shima <shima@hiroshima-cu.ac.jp>"

COPY --from=download-stage /pkg.tar.xz /
COPY --from=download-stage /install /

# ------------------------------------------------------------------
FROM base AS test-stage
ARG DEBIAN_FRONTEND="noninteractive"

COPY --from=package-stage / /
RUN . /install
ENV PATH=/opt/nodejs/bin:$PATH

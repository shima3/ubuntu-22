FROM base AS download-stage
ARG DEBIAN_FRONTEND="noninteractive"
# ARG PACKAGE

# RUN apt-get clean
# RUN curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
# RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
# RUN apt-get update && apt-get install --yes --download-only --fix-missing $PACKAGE

# RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh > /install
RUN git clone https://github.com/nvm-sh/nvm.git /opt/nvm && cd /opt/nvm && commit=`git rev-list --tags --max-count=1` && ver=`git describe --abbrev=0 --tags --match "v[0-9]*" $commit` && git checkout $ver && rm -fr .git
RUN bash -c '. /opt/nvm/nvm.sh && nvm install --lts node'
RUN echo '. /opt/nvm/nvm.sh' > /etc/profile.d/nvm.sh

# RUN tar Jcf /pkg.tar.xz /var/cache/apt/archives /var/lib/apt/lists /etc/apt/sources.list.d /etc/apt/preferences.d /usr/share/keyrings
RUN tar Jcf /pkg.tar.xz /opt/nvm /etc/profile.d/nvm.sh

RUN echo 'tar Jxf /pkg.tar.xz && rm /pkg.tar.xz' > /install
# RUN echo 'apt-get update' >> /install
# RUN echo "apt-get install --yes --no-download --fix-missing $PACKAGE" >> /install
# RUN echo '. /opt/nvm/nvm.sh' >> /install
# RUN echo 'echo ". /opt/nvm/nvm.sh" > /etc/profile.d/nvm.sh' >> /install
# RUN echo 'cp /opt/nvm/nvm.sh /etc/profile.d/nvm.sh' >> /install

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
RUN /install

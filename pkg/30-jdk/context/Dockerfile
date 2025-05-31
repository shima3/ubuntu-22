# FROM utils AS download-stage
FROM base AS download-stage
ARG PACKAGE

# COPY javase8docs.zip /tmp/
# RUN mkdir -p /var/www/html/javase/8 && cd /var/www/html/javase/8 && unzip /tmp/javase8docs.zip
RUN mkdir -p /var/www/html/javase && cd /var/www/html/javase && curl -sL http://download.oracle.com/docs/cds/javase/8.zip | bsdtar -xf - && mv E[0-9]*_[0-9]? 8

# COPY javase8docs-jp.zip /tmp/
# RUN mkdir -p /var/www/html/javase/jp && cd /var/www/html/javase/jp && unzip /tmp/javase8docs-jp.zip && mv E54527_01 8
RUN mkdir -p /var/www/html/javase/jp && cd /var/www/html/javase/jp && curl -sL http://download.oracle.com/docs/cds/javase/jp/8.zip | bsdtar -xf - && mv E[0-9]*_[0-9]? 8

# RUN apt-get install --yes --download-only --fix-missing --no-install-recommends $PACKAGE
RUN apt-get install --yes --download-only --fix-missing $PACKAGE
RUN tar Jcf /pkg.tar.xz /var/cache/apt/archives /var/lib/apt/lists /var/www/html/javase

RUN echo 'tar Jxf /pkg.tar.xz && rm /pkg.tar.xz' > /install
# RUN echo "apt-get install --no-install-recommends --yes --no-download $PACKAGE" >> /install
RUN echo "apt-get install --yes --no-download $PACKAGE" >> /install
# RUN echo 'apt-get remove --yes openjdk-11-jre-headless' >> /install
RUN echo 'apt-get autoclean' >> /install

RUN chmod +x /install

# -----------------------------------------------------------------------------
FROM scratch AS package-stage
LABEL maintainer="Kazuyuki Shima <shima@hiroshima-cu.ac.jp>"

COPY --from=download-stage /pkg.tar.xz /
COPY --from=download-stage /install /

# ------------------------------------------------------------------
# FROM utils AS test-stage
FROM base AS test-stage

COPY --from=package-stage / /
RUN /install

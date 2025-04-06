# FROM ubuntu AS update-stage
FROM utils AS download-stage
ARG DEBIAN_FRONTEND="noninteractive"
# ARG PACKAGES="apache2 php"
ARG PACKAGE

# RUN apt-get clean && apt-get update
RUN apt-get install --yes --download-only --fix-missing $PACKAGE
RUN tar Jcf /pkg.tar.xz /var/cache/apt/archives /var/lib/apt/lists
COPY / /context
RUN tar Jcf /context.tar.xz --directory=/context .

RUN echo 'tar Jxf /pkg.tar.xz && rm /pkg.tar.xz' > /install
# RUN echo "apt-get install --yes --no-download --no-install-recommends $PACKAGE" >> /install
RUN echo "apt-get install --yes --no-download $PACKAGE" >> /install
RUN echo "sed -i 's/#AddDefaultCharset/AddDefaultCharset/' /etc/apache2/conf-enabled/charset.conf" >> /install
RUN echo 'tar Jxf /context.tar.xz && rm /context.tar.xz' >> /install
RUN echo 'a2dismod -f autoindex' >> /install
# RUN echo 'certbot --apache' >> /install
RUN chmod +x /install

# ------------------------------------------------------------------
FROM scratch AS package-stage
LABEL maintainer="Kazuyuki Shima <shima@hiroshima-cu.ac.jp>"

COPY --from=download-stage /pkg.tar.xz /
COPY --from=download-stage /context.tar.xz /
COPY --from=download-stage /install /

# ------------------------------------------------------------------
# FROM update-stage AS install-stage
FROM utils AS test-stage
ARG DEBIAN_FRONTEND="noninteractive"

# COPY --from=pkg_locales / /
# RUN /install && rm /install

COPY --from=package-stage / /
# RUN /install && rm /install
RUN /install
EXPOSE 80
# ENTRYPOINT ["bash", "/usr/local/sbin/start.sh"]

# COPY --from=pkg_japan / /
# RUN /install && rm /install

# COPY --from=pkg_utils / /
# RUN /install && rm /install

# CMD ["bash"]
# CMD ["/usr/bin/supervisord", "-nc", "/etc/supervisor/supervisord.conf"]

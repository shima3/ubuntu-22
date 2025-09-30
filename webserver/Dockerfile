FROM base
LABEL maintainer="Kazuyuki Shima <shima@hiroshima-cu.ac.jp>"
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get clean

COPY --from=pkg:emacs / /
RUN /install

COPY --from=pkg:apache2 / /
RUN /install
EXPOSE 80

COPY --from=pkg:utils / /
RUN /install

COPY --from=pkg:nodejs / /
RUN /install

RUN rm /install

RUN a2enmod userdir ssl proxy_http rewrite headers cgi cgid

COPY html /var/www/html
COPY config-apache2.sh /usr/local/sbin/
COPY certbot-apache.sh /usr/local/sbin/

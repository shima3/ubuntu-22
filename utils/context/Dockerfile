# FROM ubuntu AS download-stage
FROM ubuntu
ARG DEBIAN_FRONTEND="noninteractive"
ARG PACKAGE

RUN rm /etc/dpkg/dpkg.cfg.d/excludes
RUN echo "Y" | unminimize

RUN apt-get clean && apt-get update
RUN apt-get install --yes --fix-missing locales tzdata

# ENV TZ=Japan
ENV TZ=Asia/Tokyo
RUN echo "TZ=$TZ" >> /etc/default/locale
RUN ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime
RUN echo "$TZ" > /etc/timezone

ENV LANG=ja_JP.UTF-8
RUN echo LANG="$LANG" >> /etc/default/locale
RUN echo LANGUAGE="$LANG" >> /etc/default/locale
RUN echo LC_ALL="$LANG" >> /etc/default/locale
RUN locale-gen "$LANG"
RUN update-locale LANG="$LANG"

RUN apt-get install --yes --fix-missing $PACKAGE
RUN apt-get clean

CMD ["/usr/bin/supervisord", "-nc", "/etc/supervisor/supervisord.conf"]

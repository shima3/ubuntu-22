FROM base
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update --yes
RUN apt-get install --yes mailutils postfix fail2ban dovecot-core dovecot-imapd dovecot-pop3d dovecot-common
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

COPY mail.conf /etc/supervisor/conf.d/
COPY dovecot.conf /etc/dovecot/

# postfix 設定
RUN echo "postfix postfix/mailname string mail.example.com" | debconf-set-selections && \
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections && \
dpkg-reconfigure -f noninteractive postfix

COPY --from=pkg:utils / /
RUN /install

RUN sed -i 's/^\(myhostname\s*=.*\)$/# \1/' /etc/postfix/main.cf

# RUN useradd --home-dir HOME_DIR --gid GROUP --system _mailrecord
RUN useradd --create-home --system _mailrecord
COPY _mailrecord.sh /usr/local/bin/
COPY dot.forward /home/_mailrecord/.forward

ENV PAGER=less

COPY master.cf /etc/postfix/master.cf

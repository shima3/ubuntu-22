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

RUN apt-get update && apt-get install -y docker-cli
RUN useradd --create-home --system --shell /bin/bash --gid docker edulinux
COPY edulinux.forward /home/edulinux/.forward
COPY handle.sh /home/edulinux/

RUN sed -i 's/^\(myhostname\s*=.*\)$/# \1/' /etc/postfix/main.cf

# RUN useradd --home-dir HOME_DIR --gid GROUP --system _mailrecord
RUN useradd --create-home --system _mailrecord

ENV PAGER=less

COPY master.cf /etc/postfix/master.cf

# LDAP
# RUN apt-get update && apt-get install -y libnss-sss
RUN apt-get install -y libnss-sss
RUN apt-get install -y sssd-tools
RUN apt-get install -y gettext
# 初回ログイン時にホーム作成
# RUN apt-get install -y libpam-modules
# RUN apt-get install -y slapd

# COPY ldap/pam.d/ /etc/pam.d/
# RUN pam-auth-update --force --enable sss mkhomedir

# COPY ldap/sssd.sh /usr/local/sbin/sssd.sh
# RUN chmod +x /usr/local/sbin/sssd.sh
# COPY ldap/sss.conf /etc/supervisor/conf.d/sss.conf

# COPY ldap/sssd/no-tls.conf /etc/sssd/sssd.template.conf
# COPY ldap/sssd/start-tls.conf /etc/sssd/sssd.template.conf
# COPY ldap/sssd/tls.conf /etc/sssd/sssd.template.conf

RUN useradd --create-home --system reset-password

# COPY _mailrecord.sh /usr/local/bin/
COPY bin /usr/local/bin
COPY _mailrecord.forward /home/_mailrecord/.forward

RUN useradd --create-home --system qrgen
COPY qrgen /home/qrgen
RUN apt-get update && apt-get install -y openjdk-25-jdk
RUN cd /home/qrgen && javac -cp ".:/home/qrgen/zxing/*" QRCodeGenerator.java

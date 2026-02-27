FROM base
LABEL maintainer="Kazuyuki Shima <shima@hiroshima-cu.ac.jp>"
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get clean

COPY --from=pkg:xrdp / /
RUN /install && rm /install
EXPOSE 3389

COPY --from=pkg:mate / /
RUN /install && rm /install

COPY --from=pkg:japanese / /
RUN /install && rm /install

COPY --from=pkg:gcc / /
RUN /install && rm /install

COPY --from=pkg:opam / /
RUN /install && rm /install

COPY --from=pkg:chromium / /
RUN /install && rm /install

COPY --from=pkg:emacs / /
RUN /install && rm /install

COPY --from=pkg:vscode / /
RUN /install && rm /install

COPY --from=pkg:pdf / /
RUN /install && rm /install

COPY --from=pkg:java / /
RUN /install && rm /install

COPY --from=pkg:latex / /
RUN /install && rm /install

COPY --from=pkg:ssh / /
RUN /install && rm /install
EXPOSE 22

COPY --from=pkg:gimp / /
RUN /install

COPY --from=pkg:python / /
RUN /install

COPY --from=pkg:meld / /
RUN /install

COPY --from=pkg:utils / /
RUN /install

COPY --from=pkg:ttyd / /
RUN /install

COPY --from=pkg:frama-c / /
RUN /install

COPY --from=pkg:nodejs / /
RUN /install
ENV PATH=/opt/nodejs/bin:$PATH

COPY --from=pkg:haskell / /
RUN /install

COPY --from=pkg:bison / /
RUN /install

COPY --from=pkg:llvm / /
RUN /install

COPY --from=pkg:z3 / /
RUN /install

COPY --from=pkg:k-framework / /
RUN /install

COPY --from=pkg:apache2 / /
RUN /install
EXPOSE 80

COPY --from=pkg:jupyter / /
RUN /install
EXPOSE 8000

RUN rm /install
 
# Ctrl+Shift+SpaceでIME切り替え
# COPY dconf /etc/skel/.config/dconf
# mozcの設定：効かない
# COPY mozc /etc/skel/.config/mozc

# CMD ["/usr/bin/supervisord", "-nc", "/etc/supervisor/supervisord.conf"]

# RUN apt-get autoremove --yes

# スクリーンセーバーをオフにする。
# COPY profile.d/screensaver.sh /etc/profile.d/
COPY screensaver.sh /etc/X11/Xsession.d/99screensaver

# リダイレクトフォルダがあればデスクトップからリンクする。
# COPY client_folder.sh /etc/X11/Xsession.d/99client_folder
COPY client_folder.desktop /etc/skel/.config/autostart/

# PATH, history, nano, clientの設定
COPY skel/ /etc/skel/
RUN chmod -R go-w /etc/skel

# thinclient_drives -> .thinclient_drives
# COPY xrdp/sesman.ini /etc/xrdp/
COPY sesman.ini /etc/xrdp/
# 授業用スクリプト
COPY local/ /usr/local/

# シャットダウンメニューを非表示にしようとしたが上手くいかなかった。
# COPY disable-shutdown.pkla /etc/polkit-1/localauthority/50-local.d/
# COPY polkit.conf /etc/supervisor/conf.d/
# COPY dbus.conf /etc/supervisor/conf.d/
# COPY 00-mate-settings /etc/dconf/db/local.d/
# COPY user /etc/dconf/profile/
# dbusの設定
# RUN mkdir -p /run/dbus && chown messagebus:messagebus /run/dbus && chmod 755 /run/dbus
# RUN dconf update

# 自動バックアップの設定
COPY cron.conf /etc/supervisor/conf.d/
COPY rsnapshot.conf /etc/
COPY cron.d/rsnapshot /etc/cron.d/

# RUN groupadd fuse

RUN cd /usr/local && cc src/sush.c -o sbin/sush && chmod 4755 sbin/sush bin/p3e bin/p3eb

RUN cd /usr/local && cc src/user2port.c -lpthread -o bin/user2port
COPY profile.d /etc/profile.d

# security update
# RUN apt-get update && apt-get upgrade --yes && apt-get clean
# bin/push.shでアップデートする。

# SSHログイン時、*** System restart required ***などのメッセージを表示しない。
RUN sed -i.bak '/pam_motd\.so/ s/^/#/' /etc/pam.d/sshd

# 英語キーボードを削除する。
COPY dconf /etc/skel/.config/dconf

# Ctrl+SpaceでIME有効化/無効化
COPY mozc /etc/skel/.config/mozc

# coreファイルの出力を無効化する。
# RUN echo '* hard core 0' >> /etc/security/limits.conf
# 効かなかった。

# coreファイルの出力を無効化する。
# COPY 99ulimit /etc/X11/Xsession.d/
# RUN ulimit -c 0

COPY apache2/ /etc/apache2/
RUN a2enmod userdir ssl proxy_http rewrite headers authnz_external proxy_wstunnel

COPY cgi-bin/ /usr/lib/cgi-bin/
RUN a2enmod cgi cgid

COPY html/ /var/www/html/
RUN chgrp sudo /var/www/html && chmod g+w /var/www/html

RUN chmod a+s /usr/local/bin/p3shb

# ENV PATH="/usr/local/bin:/usr/bin:/bin"
COPY root.profile /root/.profile
RUN chmod +x /root/.profile
COPY etc.profile /etc/profile

# RUN bash -c '. /opt/nvm/nvm.sh && cd /etc/skel && npm init -y && npm install express cors'
COPY nodejs /etc/skel/nodejs
WORKDIR /etc/skel/nodejs
RUN bash -c '. /opt/nvm/nvm.sh && npm init -y && npm install cors express pegjs'
# テスト用
# RUN git config --global user.email "shima@hiroshima-cu.ac.jp" && git config --global user.name 'Kazuyuki Shima' && git init && git add . && git commit -m 'Initial commit'
WORKDIR /

RUN cd /usr/local/sbin && gcc -o pam-auth pam-auth.c -lpam -lpam_misc && chmod u+s pam-auth

# 確認用削除
# RUN cd /etc/supervisor/conf.d && rm dbus.conf sshd.conf xrdp.conf
# 削除すると起動しなくなるので残す。

# 起動時 fsck は不要なので削除する。
RUN rm /etc/update-motd.d/98-fsck-at-reboot

# LDAP
RUN apt-get update && apt-get install -y libnss-sss
RUN apt-get install -y sssd-tools
RUN apt-get install -y gettext
# 初回ログイン時にホーム作成
RUN apt-get install -y libpam-modules

# COPY ldap/common-auth /etc/pam.d/common-auth
# COPY ldap/common-session /etc/pam.d/common-session
COPY ldap/pam.d/ /etc/pam.d/
RUN pam-auth-update --force --enable sss mkhomedir

COPY ldap/sssd.sh /usr/local/sbin/sssd.sh
RUN chmod +x /usr/local/sbin/sssd.sh
COPY ldap/sss.conf /etc/supervisor/conf.d/sss.conf

# COPY ldap/sssd/no-tls.conf /etc/sssd/sssd.template.conf
# COPY ldap/sssd/start-tls.conf /etc/sssd/sssd.template.conf
COPY ldap/sssd/tls.conf /etc/sssd/sssd.template.conf
# RUN chmod 600 /etc/sssd/sssd.conf && chown root:root /etc/sssd/sssd.conf

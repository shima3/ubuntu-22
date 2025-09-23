# FROM utils
FROM base
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

# utilsにインストール済み
# COPY --from=pkg:git / /
# RUN /install && rm /install

COPY --from=pkg:java / /
RUN /install && rm /install

COPY --from=pkg:latex / /
RUN /install && rm /install

COPY --from=pkg:ssh / /
RUN /install && rm /install
EXPOSE 22

COPY --from=pkg:apache2 / /
RUN /install
EXPOSE 80

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

COPY userdir.conf /etc/apache2/mods-available/
RUN a2enmod userdir

COPY cgi-bin/ /usr/lib/cgi-bin/
RUN a2enmod cgi
RUN a2enmod cgid

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
RUN git config --global user.email "shima@hiroshima-cu.ac.jp" && git config --global user.name 'Kazuyuki Shima' && git init && git add . && git commit -m 'Initial commit'
WORKDIR /

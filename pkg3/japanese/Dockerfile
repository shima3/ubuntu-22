# FROM ubuntu AS update-stage
FROM utils AS update-stage
ARG DEBIAN_FRONTEND="noninteractive"
# ENV LANG="ja_JP.UTF-8"
# ENV TZ="Japan"

RUN apt-get clean

COPY --from=pkg:xrdp / /
RUN /install

COPY --from=pkg:mate / /
RUN /install

RUN apt-get clean
RUN apt-get update

# ------------------------------------------------------------------
FROM update-stage AS download-stage
# ARG PACKAGE="fonts-ipafont fonts-noto-cjk fonts-noto-cjk-extra fonts-takao ibus ibus-mozc language-pack-ja language-pack-ja-base language-pack-gnome-ja libreoffice-help-ja libreoffice-l10n-ja mozc-utils-gui texlive-lang-japanese"
ARG PACKAGE

# RUN apt-get install --yes --download-only $PACKAGE
# RUN apt-get install --yes --download-only --fix-missing $PACKAGE
RUN apt-get install --yes --download-only --fix-broken --fix-missing $PACKAGE
# RUN apt-get clean && apt-get install --yes --download-only --fix-missing $PACKAGE
# COPY 99keyboard-layout /etc/X11/Xsession.d/
# RUN tar Jcf /pkg.tar.xz /var/cache/apt/archives /var/lib/apt/lists /etc/X11/Xsession.d/99keyboard-layout
# COPY keyboard /etc/default/
# RUN tar Jcf /pkg.tar.xz /var/cache/apt/archives /var/lib/apt/lists /etc/default/keyboard
COPY kbdtg /usr/local/bin/
RUN tar Jcf /pkg.tar.xz /var/cache/apt/archives /var/lib/apt/lists /usr/local/bin/kbdtg

RUN echo 'apt-get clean' > /install
RUN echo 'tar Jxf /pkg.tar.xz' >> /install
RUN echo "rm /pkg.tar.xz" >> /install

# ARG TZ="Asia/Tokyo"
# RUN echo "echo TZ=$TZ >> /etc/default/locale" >> /install
# RUN echo "ln -snf /usr/share/zoneinfo/$TZ /etc/localtime" >> /install
# RUN echo "ln -snf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime" >> /install
# RUN echo "echo $TZ > /etc/timezone" >> /install

# RUN echo "locale-gen $LANG" >> /install
# RUN echo "echo LANG=$LANG >> /etc/default/locale" >> /install

# RUN echo "apt-get install --yes $PACKAGE" >> /install
# RUN echo "apt-get install --yes --no-download $PACKAGE" >> /install
# RUN echo "apt-get install --yes --no-download --fix-missing $PACKAGE" >> /install
RUN echo "apt-get install --yes --no-download --fix-broken $PACKAGE" >> /install
# RUN echo 'dpkg -i /var/cache/apt/archives/*.deb' >> /install

# RUN echo 'if which kanji-config-updmap-sys; then if ! kanji-config-updmap-sys --ja haranoaji; then kanji-config-updmap-sys --ja ipa; fi; fi' >> /install
# RUN echo 'echo setxkbmap -layout "us,jp" -option "grp:alt_shift_toggle" > /etc/X11/Xsession.d/99keyboard-layout' >> /install
# RUN echo 'dpkg-reconfigure keyboard-configuration' >> /install

RUN chmod +x /install

# ------------------------------------------------------------------
FROM scratch AS package-stage

COPY --from=download-stage /pkg.tar.xz /
COPY --from=download-stage /install /

# ------------------------------------------------------------------
FROM update-stage AS test-stage

COPY --from=package-stage / /
# RUN /install && rm /install
# RUN apt-get clean && /install
RUN /install

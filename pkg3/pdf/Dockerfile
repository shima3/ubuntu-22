# FROM ubuntu AS update-stage
FROM utils AS update-stage
ARG DEBIAN_FRONTEND="noninteractive"

RUN apt-get clean

# COPY --from=pkg_xz-utils / /
# RUN /install && rm /install

COPY --from=pkg:xrdp / /
RUN /install && rm /install

RUN apt-get clean
RUN apt-get update

# ------------------------------------------------------------------
FROM update-stage AS download-stage
ARG DEBIAN_FRONTEND="noninteractive"
# ARG PACKAGE="pdftk poppler-utils printer-driver-cups-pdf xpdf"
ARG PACKAGE

#  fonts-ipafont
#  cups-pdf -> printer-driver-cups-pdf

# latex関連は pkg/latex へ移動する。
#  texlive-extra-utils texlive-fonts-extra
#  texlive-latex-base texlive-latex-extra

# texlive-full
# cups-pdf（仮想プリンタとしてPDF出力）
# pdftk（ページの結合・分割・回転）
# poppler-utils（PDF のテキスト抽出や変換）
# Unable to locate package ptex-fontmaps

RUN apt-get install --yes --download-only --fix-missing $PACKAGE
# COPY tex2pdf.sh /usr/local/bin/
# RUN tar Jcf /pkg.tar.xz /var/cache/apt/archives /var/lib/apt/lists /usr/local/bin
RUN tar Jcf /pkg.tar.xz /var/cache/apt/archives /var/lib/apt/lists

RUN echo 'tar Jxf /pkg.tar.xz && rm /pkg.tar.xz' > /install
RUN echo "apt-get install --yes --no-download $PACKAGE" >> /install
RUN chmod +x /install

# ------------------------------------------------------------------
FROM scratch AS package-stage
LABEL maintainer="Kazuyuki Shima <shima@hiroshima-cu.ac.jp>"

COPY --from=download-stage /pkg.tar.xz /
COPY --from=download-stage /install /

# ------------------------------------------------------------------
FROM update-stage AS test-stage
ARG DEBIAN_FRONTEND="noninteractive"

COPY --from=package-stage / /
RUN /install

# COPY --from=pkg:mate / /
# RUN /install

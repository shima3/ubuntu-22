# FROM ubuntu AS update-stage
# FROM utils AS download-stage
FROM utils AS update-stage

RUN apt-get clean && apt-get update --yes

# ------------------------------------------------------------------
FROM update-stage AS download-stage
ARG DEBIAN_FRONTEND="noninteractive"
# ARG PACKAGE="texlive texlive-latex-recommended texlive-latex-extra texlive-fonts-recommended texlive-bibtex-extra"
ARG PACKAGE

RUN apt-get install --yes --download-only --fix-missing $PACKAGE
# RUN tar Jcf /pkg.tar.xz /var/cache/apt/archives /var/lib/apt/lists
COPY tex2pdf.sh /usr/local/bin/
RUN tar Jcf /pkg.tar.xz /var/cache/apt/archives /var/lib/apt/lists /usr/local/bin

RUN echo "tar Jxf /pkg.tar.xz && rm /pkg.tar.xz" > /install
RUN echo "apt-get install --yes --no-download $PACKAGE" >> /install
RUN echo "if ! kanji-config-updmap-sys --ja haranoaji; then kanji-config-updmap-sys --ja ipa; fi" >> /install
RUN chmod +x /install

# ------------------------------------------------------------------
FROM scratch AS package-stage

COPY --from=download-stage /pkg.tar.xz /
COPY --from=download-stage /install /

# ------------------------------------------------------------------
# FROM utils AS test-stage
FROM update-stage AS test-stage
ARG DEBIAN_FRONTEND=noninteractive

COPY --from=package-stage / /
RUN /install

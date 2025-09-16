FROM base AS prepare-stage

COPY --from=pkg:python / /
RUN /install

# -----------------------------------------------------------------------------
FROM prepare-stage AS download-stage
ARG PACKAGE

# RUN apt-get update
# RUN apt-get install --yes --download-only --fix-missing $PACKAGE

RUN cd /opt && git clone https://github.com/Z3Prover/z3.git
RUN cd /opt/z3 && git checkout z3-4.12.1 && python3 scripts/mk_make.py --prefix=/usr && cd build && make -j"$(nproc)"

RUN tar Jcf /pkg.tar.xz opt/z3

RUN echo 'tar Jxf /pkg.tar.xz && rm /pkg.tar.xz' > /install
RUN echo 'cd /opt/z3/build && make install' >> /install

RUN chmod +x /install

# -----------------------------------------------------------------------------
FROM scratch AS package-stage
LABEL maintainer="Kazuyuki Shima <shima@hiroshima-cu.ac.jp>"

COPY --from=download-stage /pkg.tar.xz /
COPY --from=download-stage /install /

# ------------------------------------------------------------------
FROM prepare-stage AS test-stage

COPY --from=package-stage / /
RUN /install

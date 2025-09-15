FROM base AS prepare-stage
ARG DEBIAN_FRONTEND="noninteractive"

COPY --from=pkg:gcc / /
RUN /install

COPY --from=pkg:jdk / /
RUN /install

COPY --from=pkg:maven / /
RUN /install

COPY --from=pkg:haskell / /
RUN /install

# ------------------------------------------------------------------
FROM prepare-stage AS download-stage

RUN cd /opt && git clone https://github.com/runtimeverification/mpfr-java.git
# RUN cd /opt/mpfr-java && mvn -B -DskipTest install
RUN cd /opt/mpfr-java && mvn -B -Dmaven.test.skip=true install

RUN cd /opt && git clone --recursive https://github.com/runtimeverification/k.git
RUN cd /opt/k && ./install-build-deps
RUN cd /opt/k/haskell-backend/src/main/native/haskell-backend && stack setup

# RUN cd /tmp && jar xf /root/.m2/repository/org/kframework/mpfr_java/mpfr_java/1.4/mpfr_java-1.4-linux64.jar META-INF/native/linux64/libmpfr_java.so && mv META-INF/native/linux64/libmpfr_java.so /root/.hawtjni/mpfr_java/
RUN mkdir -p /root/.hawtjni/mpfr_java && cd /tmp && jar xf /opt/mpfr-java/target/mpfr_java-1.4-linux64.jar META-INF/native/linux64/libmpfr_java.so && mv META-INF/native/linux64/libmpfr_java.so /root/.hawtjni/mpfr_java/
RUN cd /opt/k && mvn -B -DskipTests package

RUN echo 'export PATH="/opt/k/k-distribution/target/release/k/bin:$PATH"' > /etc/profile.d/k-framework.sh

RUN tar Jcf /pkg.tar.xz opt/k etc/profile.d/k-framework.sh root/.hawtjni/mpfr_java opt/mpfr-java root/.stack

RUN echo 'tar Jxf /pkg.tar.xz && rm /pkg.tar.xz' > /install

RUN chmod +x /install

# ------------------------------------------------------------------
FROM scratch AS package-stage
LABEL maintainer="Kazuyuki Shima <shima@hiroshima-cu.ac.jp>"

COPY --from=download-stage /pkg.tar.xz /
COPY --from=download-stage /install /

# ------------------------------------------------------------------
FROM prepare-stage AS test-stage

COPY --from=package-stage / /
RUN /install

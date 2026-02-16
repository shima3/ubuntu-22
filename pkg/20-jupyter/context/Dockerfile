FROM base AS clean-stage
ARG DEBIAN_FRONTEND=noninteractive

COPY --from=pkg:nodejs / /
RUN /install && rm /install
ENV PATH=/opt/nodejs/bin:$PATH

COPY --from=pkg:python / /
RUN /install && rm /install

# RUN apt-get clean && apt-get update -y
RUN apt-get clean

# -----------------------------------------------------------------------------
FROM clean-stage AS download-stage
ARG DEBIAN_FRONTEND=noninteractive
ARG TARGETARCH

RUN pip3 download jupyterhub jupyterlab -d /opt/jupyterlab
RUN cd /root && rm -rf node_modules package-lock.json && npm cache clean --force
RUN npm install -g configurable-http-proxy
RUN npm cache verify
COPY jupyter.conf /etc/supervisor/conf.d/jupyter.conf
COPY jupyterhub_config.py /etc/jupyter/jupyterhub_config.py
RUN tar cf /pkg.tar opt/jupyterlab /root/.npm /etc/supervisor/conf.d /etc/jupyter/jupyterhub_config.py && xz /pkg.tar

RUN echo 'tar Jxf /pkg.tar.xz && rm /pkg.tar.xz' > /install
RUN echo 'pip3 install --no-index --find-links=/opt/jupyterlab jupyterhub jupyterlab' >> /install
RUN echo 'npm install -g configurable-http-proxy --offline' >> /install
RUN chmod +x /install

# -----------------------------------------------------------------------------
FROM scratch AS package-stage
LABEL maintainer="Kazuyuki Shima <shima@hiroshima-cu.ac.jp>"

COPY --from=download-stage /pkg.tar.xz /
COPY --from=download-stage /install /

# -----------------------------------------------------------------------------
FROM clean-stage AS test-stage
ARG DEBIAN_FRONTEND=noninteractive

COPY --from=package-stage / /
RUN /install

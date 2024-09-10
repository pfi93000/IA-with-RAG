FROM rockylinux:9-minimal

ARG http_proxy_arg
ARG https_proxy_arg
ARG nexus_hostname
ARG nexus_proto="http"
ARG nexus_port="8081"
ARG nexus_pypi="pypi-all"

ENV HTTP_PROXY=${http_proxy_arg:-""}
ENV HTTPS_PROXY=${https_proxy_arg:-""}
ENV NO_PROXY=${nexus_hostname:-""}

ENV TZ=${TZ:-"Europe/Paris"}

# Prerequisite python version for llama-index
RUN microdnf upgrade -y && microdnf install -y python3.12 python3.12-pip git && microdnf clean all

RUN set -eux; \
    echo "[global]" > /etc/pip.conf; \
    if test -n "${HTTPS_PROXY}" -a -z "${NO_PROXY}" ; then \
      echo "proxy=${HTTPS_PROXY}" >> /etc/pip.conf; \
    fi; \
    if test -n "${NO_PROXY}" ; then \
      echo "trusted-host=${nexus_hostname}:${nexus_port}" >> /etc/pip.conf; \
      echo "index-url=${nexus_proto}://${nexus_hostname}:${nexus_port}/repository/${nexus_pypi}/simple" >> /etc/pip.conf; \
      echo "no-cache-dir=false" >> /etc/pip.conf; \
    fi; 

ENV PIP_CONFIG_FILE=/etc/pip.conf

RUN groupadd --gid 10001 jupyter \
    && useradd --uid 10001 --gid jupyter --shell /bin/bash --create-home jupyter
   
# the "jupyter" user created above, represented numerically for optimal compatibility with Kubernetes security policies
USER 10001
WORKDIR /home/jupyter
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/jupyter/.local/bin

COPY requirements.txt .
RUN pip3.12 install --upgrade -r requirements.txt

COPY --chmod=0755 --chown=jupyter Embedding.ipynb .

CMD [ "ipython", "-c", "\"%run Embedding.ipynb\"" ]
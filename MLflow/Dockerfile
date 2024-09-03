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

# Prerequisite python version for mlflow : https://pypi.org/project/mlflow/
RUN microdnf upgrade -y && microdnf install -y python3.12 python3.12-pip git && microdnf clean all

RUN set -eux; \
    echo "[global]" > /etc/pip.conf; \
    if test -n "${https_proxy_arg}" -a -z "${nexus_hostname}" ; then \
      echo "proxy=${HTTPS_PROXY}" >> /etc/pip.conf; \
    fi; \
    if test -n "${nexus_hostname}" ; then \
      echo "trusted-host=${nexus_hostname}:${nexus_port}" >> /etc/pip.conf; \
      echo "index-url=${nexus_proto}://${nexus_hostname}:${nexus_port}/repository/${nexus_pypi}/simple" >> /etc/pip.conf; \
      echo "no-cache-dir=false" >> /etc/pip.conf; \
    fi; 

ENV PIP_CONFIG_FILE=/etc/pip.conf

RUN groupadd --gid 10001 mlflow \
    && useradd --uid 10001 --gid mlflow --shell /bin/bash --create-home mlflow
# the "mlflow" user created above, represented numerically for optimal compatibility with Kubernetes security policies
USER 10001
WORKDIR /home/mlflow
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/mlflow/.local/bin

# version 1 : requirements.txt contient uniquement "mlflow"
# version 2 : requirements.txt contient le résultat de la commande docker run -it --rm mlflow:v1 pip-3.12 freeze > .\requirements.txt
COPY requirements.txt .
RUN pip-3.12 install --upgrade -r requirements.txt

HEALTHCHECK --interval=5m --timeout=3s --start-period=60s --retries=2 \
  CMD curl -f http://localhost:8080/ 2>&1 | grep MLflow || exit 1

EXPOSE 8080
CMD ["mlflow", "server", "--host", "0.0.0.0", "--port", "8080"]
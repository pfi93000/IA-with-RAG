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

# https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=Rocky&target_version=9
RUN microdnf install -y 'dnf-command(config-manager)' dnf && microdnf clean all
RUN rpm --import https://developer.download.nvidia.com/compute/cuda/repos/fedora32/x86_64/D42D0685.pub  && \
dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel9/x86_64/cuda-rhel9.repo && \
  dnf clean all && dnf clean expire-cache && \
  dnf -y install cuda-toolkit-12-4 && \
  dnf clean all && dnf clean expire-cache && \
  ln -fs /usr/lib64/libcuda.so.1 /usr/local/cuda-12.4/lib64/libcuda.so.1

RUN groupadd --gid 10001 jupyter \
    && useradd --uid 10001 --gid jupyter --shell /bin/bash --create-home jupyter
   
# the "jupyter" user created above, represented numerically for optimal compatibility with Kubernetes security policies
USER 10001
WORKDIR /home/jupyter
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/jupyter/.local/bin:/usr/local/cuda-12.4/bin

RUN mkdir -p models data && curl -L https://raw.githubusercontent.com/run-llama/llama_index/main/docs/docs/examples/data/paul_graham/paul_graham_essay.txt -o ./data/paul_graham_essay.txt
ADD --chmod=0555 --chown=jupyter https://huggingface.co/QuantFactory/Meta-Llama-3-8B-Instruct-GGUF/resolve/main/Meta-Llama-3-8B-Instruct.Q4_K_M.gguf models/llama.gguf
COPY --chmod=0755 --chown=jupyter LangChain_MLflow.ipynb .

# README de llama-cpp : https://github.com/abetlen/llama-cpp-python/blob/main/README.md
COPY requirements.txt .
RUN pip3.12 install --upgrade -r requirements.txt llama-cpp-python --extra-index-url https://abetlen.github.io/llama-cpp-python/whl/cu124

HEALTHCHECK --interval=5m --timeout=3s --start-period=60s --retries=2 \
  CMD curl -f http://localhost:8888/ 2>/dev/null || exit 1

EXPOSE 8888
CMD [ "jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--NotebookApp.token=2FROw06Ur6Hi3ozYEy6U" ]

COPY --chmod=0755 --chown=jupyter llama_cpp.ipynb .

.PHONY: up down clean embedding langchain mlflow ollama help k8s all
.DEFAULT_GOAL := all

SHELL := /bin/bash

# Si les variables d'environnement en MAJSUCULE existent, elles seront utilisée, sinon ce seront les valeurs en dessous :
http_proxy = ""
https_proxy = ""
nexus_hostname = ""
nexus_proto = ""
nexus_port = ""
nexus_pypi = ""

ifeq ($(origin HTTP_PROXY), undefined)
	ifeq ($(origin http_proxy), undefined)
		HTTP_PROXY = ""
	else
		HTTP_PROXY = $(http_proxy)
	endif
endif
ifeq ($(origin HTTPS_PROXY), undefined)
	ifeq ($(origin https_proxy), undefined)
		HTTPS_PROXY = ""
	else
		HTTPS_PROXY = $(https_proxy)
	endif
endif
ifeq ($(origin NEXUS_HOSTNAME), undefined)
	ifeq ($(origin nexus_hostname), undefined)
		NEXUS_HOSTNAME = ""
	else
		NEXUS_HOSTNAME = $(nexus_hostname)
	endif
endif
ifeq ($(origin NEXUS_PROTO), undefined)
	ifeq ($(origin nexus_proto), undefined)
		NEXUS_PROTO = ""
	else
		NEXUS_PROTO = $(nexus_proto)
	endif
endif
ifeq ($(origin NEXUS_PORT), undefined)
	ifeq ($(origin nexus_port), undefined)
		NEXUS_PORT = ""
	else
		NEXUS_PORT = $(nexus_port)
	endif
endif
ifeq ($(origin NEXUS_PYPI), undefined)
	ifeq ($(origin nexus_pypi), undefined)
		NEXUS_PYPI = ""
	else
		NEXUS_PYPI = $(nexus_pypi)
	endif
endif

# Embedding
INFINITY ?= 0.0.55
MODEL_EMBEDDING ?= "intfloat/multilingual-e5-base"
# LangChain
# -
# MLFlow
# -
# Ollama
OLLAMA ?= 0.3.10
LLM ?= llama3

embedding: ## build a docker image with an embedding API
	@docker pull michaelf34/infinity:$(INFINITY)

langchain: ## build a docker image with a Notebook able to launch LangChain
	@cd LangChain && \
	docker build . -t llamacpp:v1 \
	--target PROD \
	--build-arg nexus_hostname=$(NEXUS_HOSTNAME) \
	--build-arg nexus_proto=$(NEXUS_PROTO) \
	--build-arg nexus_port=$(NEXUS_PORT) \
	--build-arg nexus_pypi=$(NEXUS_PYPI) \
	--build-arg http_proxy_arg=$(HTTP_PROXY) \
	--build-arg https_proxy_arg=$(HTTPS_PROXY) \
	--cache-from llamacpp:v1 \
	--pull

mlflow: ## build a docker image with a Notebook able to launch LangChain
	@cd MLflow && \
	docker build . -t mlflow:v1 \
	--build-arg nexus_hostname=$(NEXUS_HOSTNAME) \
	--build-arg nexus_proto=$(NEXUS_PROTO) \
	--build-arg nexus_port=$(NEXUS_PORT) \
	--build-arg nexus_pypi=$(NEXUS_PYPI) \
	--build-arg http_proxy_arg=$(HTTP_PROXY) \
	--build-arg https_proxy_arg=$(HTTPS_PROXY) \
	--cache-from mlflow:v1 \
	--pull

ollama: ## build a docker image with a MLflow server
	@cd Ollama && \
	docker build . -t ollama:v1 \
	--build-arg OLLAMA=$(OLLAMA) \
	--build-arg LLM=$(LLM) \
	--build-arg nexus_hostname=$(NEXUS_HOSTNAME) \
	--build-arg nexus_proto=$(NEXUS_PROTO) \
	--build-arg nexus_port=$(NEXUS_PORT) \
	--build-arg nexus_pypi=$(NEXUS_PYPI) \
	--build-arg http_proxy_arg=$(HTTP_PROXY) \
	--build-arg https_proxy_arg=$(HTTPS_PROXY) \
	--cache-from ollama:v1 \
	--pull

up: all ## build docker images and run them on Docker
	@cd docker-compose && \
	INFINITY=$(INFINITY) MODEL_EMBEDDING=$(MODEL_EMBEDDING) docker compose up --detach --force-recreate --remove-orphans --build

all: embedding langchain mlflow ollama ## build docker images

down: ## stop docker-compose environment. Docker volumes are keeped
	@cd docker-compose && \
	INFINITY=$(INFINITY) MODEL_EMBEDDING=$(MODEL_EMBEDDING) docker compose down

clean: down ## stop containers, delete docker images, docker volumes et k8s objects
	@cd docker-compose && \
	INFINITY=$(INFINITY) MODEL_EMBEDDING=$(MODEL_EMBEDDING) docker compose down --volumes
	@docker rmi michaelf34/infinity:$(INFINITY) || true
	@docker rmi llamacpp:v1 || true
	@docker rmi mlflow:v1 || true
	@docker rmi ollama:v1 || true
	@docker image prune --force || true
	@kubectl delete -f k8s || true

k8s: all ## build docker images and deploy them into a k8s
	@cd docker-compose && \
	docker build . -t llamacpp:rag --cache-from llamacpp:rag
	@kubectl apply -f k8s

help: ## print this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {gsub("\\\\n",sprintf("\n%22c",""), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

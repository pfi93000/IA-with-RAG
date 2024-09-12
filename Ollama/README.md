# Ollama

Ollama permet d'exposer un (ou des) LLM sous la forme d'une [API](https://github.com/ollama/ollama/blob/main/docs/api.md)

## Création de l'image docker

Le Dockerfile proposé contient le téléchargement d'un LLM, afin que l'image soit opérationnelle hors ligne

```bash
docker build . -t ollama:v1  --build-arg OLLAMA=0.3.10 --build-arg LLM=llama3
```

variables possibles :

- OLLAMA : la version de l'image docker d'Ollama
- LLL : le LLM à précharger dans l'image docker en cours de construction

## Test de l'image

```bash
docker run -it --rm ollama:v1 help

trivy image --scanners vuln --severity CRITICAL,HIGH ollama:v1

cd test
docker compose build
docker compose up -d
docker compose logs
http://127.0.0.1:8888/notebooks/Ollama.ipynb?token=2FROw06Ur6Hi3ozYEy6U
http://127.0.0.1:8080/#/experiments/0
    Experiment: ollama
        Traces
docker compose down
cd ..
```

### Utilisation de l'image

```bash
docker run -it --rm -p 11434:11434 -v volume_llms:/root/.ollama  --runtime=nvidia --gpus all ollama:v1
```

variables possibles :

- TZ : TimeZone, fuseau horaire, pour les logs
- HTTPS_PROXY
- HTTP_PROXY
- NO_PROXY

Puis l'interface est accessible avec l'URL suivante :
[Jupyter](http://127.0.0.1:8888/tree?token=2FROw06Ur6Hi3ozYEy6U)

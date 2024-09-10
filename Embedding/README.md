# Modèle d'embedding disponible sur API

Le projet [infinity](https://github.com/michaelfeil/infinity) permet créer une API avec le modèle d'embedding de son choix.

## Création de l'image docker

```bash
docker pull michaelf34/infinity:0.0.55
```

## Test de l'image

```bash
docker compose build
docker compose up -d
docker compose logs
http://127.0.0.1:8080/#/experiments/0
    Experiment: embedding
docker compose down

trivy image --scanners vuln --severity CRITICAL,HIGH michaelf34/infinity:0.0.55

cd test
docker compose up -d
docker compose logs
http://127.0.0.1:8888/notebooks/Embedding.ipynb?token=2FROw06Ur6Hi3ozYEy6U
http://127.0.0.1:8080/#/experiments/0
    Experiment: embedding
docker compose down
cd ..
```

### Utilisation de l'image

```bash
port=7997
model1=michaelfeil/bge-small-en-v1.5
model2=mixedbread-ai/mxbai-rerank-xsmall-v1
volume=$PWD/data

docker run -it --gpus all \
 -v $volume:/app/.cache \
 -p $port:$port \
 michaelf34/infinity:0.0.55 \
 v2 \
 --model-id $model1 \
 --model-id $model2 \
 --port $port
 ```

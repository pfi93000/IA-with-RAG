# pile LLMOps simple pour mettre à disposition des LLMs sur un environnement Docker/Kubernetes

## Description de la pile

### MLflow

MLflow est utilisé pour suivre le cycle de vie des LLMs

[site officiel](https://www.mlflow.org/)

### Infinity

Infinity est utilisé pour exposer une API dédiée à l'Embedding

[site github](https://github.com/michaelfeil/infinity/tree/main)

### Ollama

Ollama est utilisé par exposer une API dédiée au LLMs.

Remarque : Ollama pourrait être utilisé aussi pour exposer un modèle dédié à l'embedding.

### LangChain

LangChain est utilisé pour montrer l'accès aux LLMs (local ou OpenAI) avec un exemple simple.

## Installation

Tous les logiciels seront packagés puis installés sur un serveur Docker avec la commande suivante :

```bash
make up
```

Accès locaux :

- MLflow : http://127.0.0.1:8080/
- Jupyter Notebook pour lancer LangChain : http://127.0.0.1:8888/notebooks/rag.ipynb?token=2FROw06Ur6Hi3ozYEy6U

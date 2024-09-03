# MLflow

## Création de l'image docker

```bash
docker build . -t mlflow:v1 --no-cache
```

## Test de l'image

```bash
docker run -it --rm mlflow:v1 mlflow --help
```

### Utilisation de l'image

```bash
docker run -it -d --rm --env TZ="Europe/Paris" --name mlflow -p 8080:8080 mlflow:v1
```

variables possibles :

- TZ : TimeZone, fuseau horaire, pour les logs

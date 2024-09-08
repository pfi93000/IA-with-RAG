# MLflow

## Création de l'image docker

```bash
docker build . -t llamacpp:v1
```

Il est possible d'ajouter des arguments lors du Build :

- http_proxy_arg
- https_proxy_arg
- nexus_proto (par défaut http)
- nexus_hostname
- nexus_port (par défaut 8081)
- nexus_pypi (par défaut pypi-all)

Exemple :

```bash
docker build . -t llamacpp:v1 --build-arg https_proxy_arg=192.168.5.54:8085 --build-arg nexus_hostname=192.168.5.6 --build-arg nexus_pypi=pypi
```

## Test de l'image

```bash
docker run -it --rm --runtime=nvidia --gpus all llamacpp:v1 ipython -c "%run llama_cpp.ipynb"

trivy image --scanners vuln,secret,misconfig,license --license-full --severity CRITICAL,HIGH llamacpp:v1
trivy fs .
trivy fs --scanners misconfig .

cd test
docker compose build
docker compose up -d
docker compose logs
docker compose down
cd ..
```

### Utilisation de l'image

```bash
docker run -it -d --rm --env TZ="Europe/Paris" --name llamacpp -p 8888:8888 --runtime=nvidia --gpus all llamacpp:v1
```

variables possibles :

- TZ : TimeZone, fuseau horaire, pour les logs
- HTTPS_PROXY
- HTTP_PROXY
- NO_PROXY

Puis l'interface est accessible avec l'URL suivante :
[Jupyter](http://127.0.0.1:8888/tree?token=2FROw06Ur6Hi3ozYEy6U)

# Metricbeat

Metricbeat est utilisé dans la suite Elastic / Kibana pour remonter des métriques

## Création de l'image docker

```bash
docker build . -t metricbeat:ia
```

## Test de l'image

```bash
docker run -it --rm metricbeat:ia export config
```

### Utilisation de l'image

```bash
docker run -d --name=metricbeat --user=root --volume="metric_module:/usr/share/metricbeat" --volume="/var/run/docker.sock:/var/run/docker.sock:ro"  metricbeat:ia metricbeat -e -E output.elasticsearch.hosts=["https://192.168.5.6:9200"] -E output.elasticsearch.ssl.verification_mode="none" -E output.elasticsearch.username="elastic" -E output.elasticsearch.password="8UveHLt9E2zTXboykFfJ"
```

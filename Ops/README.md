# Ops

## SonarQube

[Calcul de la qualité du code](https://www.sonarsource.com/products/sonarqube/downloads/)

```bash
docker run -itd --volume="sonarqube_data=/opt/sonarqube/data" --volume="sonarqube_logs=/opt/sonarqube/logs" --volume="sonarqube_extensions=/opt/sonarqube/extensions" --name sonarqube-custom -p 9000:9000 sonarqube:lts-community
```

## Trivy (et Harbor)

[Pour tester les images](https://github.com/aquasecurity/trivy)

## Nexus

[Proxy pour les modules python](https://www.sonatype.com/products/sonatype-nexus-repository)

```bash
docker run -itd --rm --volume="nexus:/nexus-data" -p 8081:8081 --name nexus sonatype/nexus3:3.71.0-java17-alpine
```

## LemonLDAP

[Exposition des services de façon sécurisée](https://lemonldap-ng.org/)

```bash
cd LemonLDAP
docker compose up --build -d
```
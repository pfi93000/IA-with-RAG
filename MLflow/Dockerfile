FROM rockylinux:9-minimal

ENV TZ=${TZ:-"Europe/Paris"}

# Prerequisite python version for mlflow : https://pypi.org/project/mlflow/
RUN microdnf upgrade -y && microdnf install -y python3.12 python3.12-pip git && microdnf clean all

# version 1 : requirements.txt contient uniquement "mlflow"
# version 2 : requirements.txt contient le résultat de la commande docker run -it --rm -p 8080:8080 pfi:latest pip-3.12 freeze > .\requirements.txt
COPY requirements.txt .
RUN pip-3.12 install --no-cache-dir --upgrade -r requirements.txt

EXPOSE 8080
CMD ["mlflow", "server", "--host", "0.0.0.0", "--port", "8080"]
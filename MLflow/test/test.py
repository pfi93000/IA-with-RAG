import mlflow
import sys
import time
import requests

mlflow_url=sys.argv[1]
check_url=True
while check_url:
    try:
        r = requests.get(mlflow_url)
        check_url=False
    except requests.exceptions.RequestException as e:
        print("Checking MLflow URL...")
        time.sleep(3)
    
print("configuring...")
mlflow.set_tracking_uri(mlflow_url)

print("adding 1 mlflow experiment...")
r = mlflow.set_experiment("check-docker-compose-connection")
print(r)
# on remonte dans MLflow 2 paramètres (qui devraient être utilisés pour personnaliser notre apprentissage)
with mlflow.start_run():
    mlflow.log_metric("foo", 1)
    mlflow.log_metric("bar", 2)

print("reading experiments using API...")
response = requests.get(
    mlflow_url + 'api/2.0/mlflow/experiments/get-by-name',
    params={'experiment_name': 'check-docker-compose-connection'}
)
print(response.json())

print('done')

# spark-streaming-k8s

## Starting minikube

```bash
minikube stop
minikube delete
minikube start --insecure-registry="192.168.0.1:5000" --memory 8192 --cpus 4
```

### Geting minikube ip and master address

```bash
minikube ip
kubectl cluster-info
```
### Running minikube dashboard

```bash
minikube dashboard --url &
kubectl proxy --address='0.0.0.0' --disable-filter=true --port=5885 &
```

## App Development

### Build Kafka

```bash
make kafka
```

### Build Postgres

```bash
make pg
```

### Bulding Spark docker image

#### Download jar files

```bash
make jars_dl
```
#### Build the image

```bash
make build-app
```
### Push Location Dataset to Kafka

```bash
make push-kafka
```
### Check the Kafka Topic

```bash
make kafkacat
```

## App K8s Deployment

```bash
cd k8s/
```

### Spark Image in Registery

#### start registery

```bash
make start-registery
```
#### tag and push image to registery

```bash
docker tag spark-streaming-k8s_spark 192.168.0.1:5000/stream-spark:v4
docker push 192.168.0.1:5000/stream-spark:v4
```
##### check registery

```bash
curl -X GET http://192.168.0.1:5000/v2/stream-spark/tags/list
```

### Run Spark Streaming

#### Download Spark

```bash
wget --no-verbose https://archive.apache.org/dist/spark/spark-3.1.1/spark-3.1.1-bin-hadoop3.2.tgz && \
tar -xzvf spark-3.1.1-bin-hadoop3.2.tgz && \
rm -rf spark-3.1.1-bin-hadoop3.2.tgz && \
cd spark-3.1.1-bin-hadoop3.2/
```
#### Create Spark Service Account

```bash
kubectl create serviceaccount spark
kubectl create clusterrolebinding spark-role --clusterrole=edit  --serviceaccount=default:spark --namespace=default
```

#### Spark Submit Streaming

```bash
make run-k8s-streaming
```

## Results

### Logs

### Spark UI

### Postgres
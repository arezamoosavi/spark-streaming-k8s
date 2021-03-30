set-params-ip:
	docker network inspect bridge
	code /etc/docker/daemon.json
	sudo systemctl daemon-reload
	sudo systemctl stop docker
	sudo systemctl start docker

start-registery:
	docker-compose -f docker-registery.yml up --build -d

clean-registery:
	docker-compose -f docker-registery.yml down -v

docker-build:
	docker images
	docker tag spark-streaming-k8s_spark 192.168.0.1:5000/stream-spark:v4
	
docker-push:
	docker push 192.168.0.1:5000/stream-spark:v4

check-registry:
	curl -X GET http://192.168.0.1:5000/v2/stream-spark/tags/list

del-minikube:
	minikube stop
	minikube delete

init-minikube:
	minikube start --insecure-registry="192.168.0.1:5000" --memory 8192 --cpus 4
	minikube ip
	minikube status
	minikube addons list
	minikube dashboard --url &
	minikube addons enable dashboard
	minikube addons enable metrics-server 
	kubectl proxy --address='0.0.0.0' --disable-filter=true --port=5885 &
	hostname -I | cut -d' ' -f1
	curl -X GET http://ip_add:5885/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/#/overview?namespace=default

all-deploy:
	kubectl apply -f deployment/

delete-all-deploy:
	kubectl delete -f deployment/

logging:
	kubectl delete daemonsets,replicasets,services,deployments,pods,rc --all
	kubectl delete all --all --all-namespaces
	kubectl get pods --field-selector 'status.phase=Failed' -o name | xargs kubectl delete
	kubectl get all
	kubectl logs -f pod/pod-id
	kubectl port-forward --address 0.0.0.0 service/spark-master 8080:8080 18080:18080 7077:7077 &
	kubectl port-forward --address 0.0.0.0 pod/locations-streaming-4b74cd78597bef51-driver 4040:4040 &


run_k8s:
	kubectl create serviceaccount spark
	kubectl create clusterrolebinding spark-role --clusterrole=edit  --serviceaccount=default:spark --namespace=default
	kubectl cluster-info
	kubectl proxy --address='0.0.0.0' --disable-filter=true --port=8443 &

run-k8s-streaming:
	./bin/spark-submit --verbose --master k8s://https://192.168.0.2:8443 --deploy-mode cluster --conf spark.executor.instances=1 --jars local:///opt/spark/jars/commons-pool2-2.9.0.jar,local:///opt/spark/jars/postgresql-42.2.5.jar,local:///opt/spark/jars/spark-streaming_2.12-3.1.1.jar,local:///opt/spark/jars/spark-token-provider-kafka-0-10_2.12-3.1.1.jar,local:///opt/spark/jars/kafka-clients-2.6.0.jar,local:///opt/spark/jars/spark-sql-kafka-0-10_2.12-3.1.1.jar,local:///opt/spark/jars/spark-streaming-kafka-0-10-assembly_2.12-3.1.1.jar --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark --conf spark.kubernetes.container.image=192.168.0.1:5000/stream-spark:v4 --name locations-streaming local:///opt/work-dir/stream_process.py 192.168.0.1 192.168.0.1:9092


run-more-adv-streaming:
	./bin/spark-submit --verbose --master k8s://https://192.168.0.2:8443 \
	--deploy-mode cluster \
	--conf spark.kubernetes.driver.pod.name=location-streaming-app \
	--conf spark.kubernetes.container.image.pullPolicy=Always \
	--conf spark.executor.instances=1 \
	--conf spark.executor.memory=2G \
	--conf spark.executor.cores=1 \
	--conf spark.driver.memory=1G \
	--conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
	--conf spark.kubernetes.container.image=192.168.0.1:5000/stream-spark:v4 \
	--name locations-streaming \
	--jars local:///opt/spark/jars/commons-pool2-2.9.0.jar,\
	local:///opt/spark/jars/postgresql-42.2.5.jar,\
	local:///opt/spark/jars/spark-streaming_2.12-3.1.1.jar,\
	local:///opt/spark/jars/spark-token-provider-kafka-0-10_2.12-3.1.1.jar,\
	local:///opt/spark/jars/kafka-clients-2.6.0.jar,\
	local:///opt/spark/jars/spark-sql-kafka-0-10_2.12-3.1.1.jar,\
	local:///opt/spark/jars/spark-streaming-kafka-0-10-assembly_2.12-3.1.1.jar \
	local:///opt/work-dir/stream_process.py 192.168.0.1 192.168.0.1:9092
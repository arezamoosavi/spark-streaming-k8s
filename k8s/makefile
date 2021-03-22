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
	docker tag spark-streaming-k8s_spark 192.168.0.1:5000/stream-spark:v2
	
docker-push:
	docker push 192.168.0.1:5000/stream-spark:v1

check-registry:
	curl -X GET http://192.168.0.1:5000/v2/stream-spark/tags/list

del-minikube:
	minikube delete

init-minikube:
	minikube start --insecure-registry="192.168.0.1:5000" --memory 8192 --cpus 4
	minikube ip
	minikube status
	minikube dashboard --url &
	kubectl proxy --address='0.0.0.0' --disable-filter=true --port=5885 &
	curl -X GET http://ip_add:5885/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/#/overview?namespace=default

all-deploy:
	kubectl apply -f deployment/

delete-all-deploy:
	kubectl delete -f deployment/

logging:
	kubectl get all
	kubectl logs -f pod/pod-id
	kubectl port-forward --address 0.0.0.0 service/spark-master 8080:8080 18080:18080 7077:7077 &


run_k8s:
	kubectl create serviceaccount spark
	kubectl create clusterrolebinding spark-role --clusterrole=edit  --serviceaccount=default:spark --namespace=default
	kubectl cluster-info
	kubectl proxy --address='0.0.0.0' --disable-filter=true --port=8443 & 
	./bin/spark-submit --verbose --packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.1.1 --master k8s://https://192.168.0.2:8443 --deploy-mode cluster --conf spark.executor.instances=1 --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark --conf spark.kubernetes.container.image=192.168.0.1:5000/stream-spark:v2 --name locations-streaming local:///opt/work-dir/stream_process.py 192.168.0.1 192.168.0.1:9092
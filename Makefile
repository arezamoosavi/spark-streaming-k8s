.PHONY: logs kafka pg up-app build-app exec-app stop-app down kafkacat

logs:
	docker-compose logs -f

kafka:
	docker-compose up -d zookeeper
	docker-compose up -d kafka

pg:
	docker-compose up -d postgres

up-app:
	docker-compose up -d local-spark

build-app:
	docker-compose up --build -d local-spark

exec-app:
	docker-compose exec local-spark bash

stop-app:
	docker-compose stop local-spark
	docker-compose rm local-spark

down:
	docker-compose down -v

kafkacat:
	kafkacat -b localhost:9092 -o beginning -t locations -C -c2 | jq
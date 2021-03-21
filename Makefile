.PHONY: logs kafka pg up-app build-app exec-app stop-app down kafkacat pg-exec

logs:
	docker-compose logs -f

kafka:
	docker-compose up -d zookeeper kafka

pg:
	docker-compose up -d postgres

up-app:
	docker-compose up -d spark

build-app:
	docker-compose up --build -d spark

exec-app:
	docker-compose exec spark bash

stop-app:
	docker-compose stop spark
	docker-compose rm spark

down:
	docker-compose down -v

kafkacat:
	kafkacat -b localhost:9092 -o beginning -t locations -C -c2 | jq

pg-exec:
	docker-compose exec postgres psql -h localhost -U admin appdb
.PHONY: jars_dl logs kafka pg up-app build-app exec-app stop-app down kafkacat pg-exec

jars_dl:
	sh jarfile_download.sh
logs:
	docker-compose logs -f

kafka:
	export KAFKA_HOSTNAME_COMMAND=`hostname -I | cut -d' ' -f1` && \
	docker-compose up --build -d zookeeper kafka

pg:
	docker-compose up --build -d postgres

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
	docker-compose exec postgres psql -h localhost -U admin appdb; \dt+

push-kafka:
	docker-compose exec spark python produce_data.py

run-local-streaming:
	docker-compose exec spark \
	spark-submit --verbose --packages org.apache.spark:spark-sql-kafka-0-10_2.12:3.1.1 \
	--master local --jars /opt/spark/jars/postgresql-42.2.5.jar \
	stream_process.py postgres kafka:29092

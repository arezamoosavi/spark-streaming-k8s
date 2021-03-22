cd container/jars
echo ${PWD}
wget --no-verbose https://repo1.maven.org/maven2/org/apache/spark/spark-streaming_2.12/3.1.1/spark-streaming_2.12-3.1.1.jar
wget --no-verbose https://repo1.maven.org/maven2/org/apache/spark/spark-streaming-kafka-0-10-assembly_2.12/3.1.1/spark-streaming-kafka-0-10-assembly_2.12-3.1.1.jar
wget --no-verbose https://repo1.maven.org/maven2/org/apache/kafka/kafka-clients/2.6.0/kafka-clients-2.6.0.jar
wget --no-verbose https://repo1.maven.org/maven2/org/apache/commons/commons-pool2/2.9.0/commons-pool2-2.9.0.jar
wget --no-verbose https://repo1.maven.org/maven2/org/apache/spark/spark-sql-kafka-0-10_2.12/3.1.1/spark-sql-kafka-0-10_2.12-3.1.1.jar
wget --no-verbose https://repo1.maven.org/maven2/org/apache/spark/spark-token-provider-kafka-0-10_2.12/3.1.1/spark-token-provider-kafka-0-10_2.12-3.1.1.jar
wget --no-verbose https://repo1.maven.org/maven2/org/postgresql/postgresql/42.2.5/postgresql-42.2.5.jar
cd ../..
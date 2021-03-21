import os, sys
from functools import partial

from pyspark.sql import SparkSession
from pyspark.sql.functions import from_json
from pyspark.sql.types import *
from pyspark.sql.functions import col, udf

# pg_url = os.getenv("db_url")
# TOPIC_NAME = os.getenv("TOPIC_NAME")
# brokerAddresses = os.getenv("brokerAddresses")

pg_host = str(sys.argv[1])
pg_url = "jdbc:postgresql://{}:5432/appdb".format(pg_host)
pg_usr = "admin"
pg_psw = "admin"
TOPIC_NAME = "locations"
brokerAddresses = str(sys.argv[2])
# brokerAddresses = "kafka:29092"


def postgres_sink(df, epoch_id, table_name):
    properties = {
        "driver": "org.postgresql.Driver",
        "user": pg_usr,
        "password": pg_psw,
    }

    df.write.jdbc(url=pg_url, table=table_name, mode="append", properties=properties)


def apply_location_requirement(df):

    df = df.withColumn("driverId", df["driverId"].cast("int").alias("driverId"))
    df = df.withColumn("lng", df["lng"].cast("float").alias("lng"))
    df = df.withColumn("lat", df["lat"].cast("float").alias("lat"))
    df = df.withColumn("time", df["time"].cast("timestamp").alias("time"))

    return df


def main():

    # Read from kafka
    spark = SparkSession.builder.appName("Driver GPS Streaming").getOrCreate()

    # log4j
    # log4jLogger= spark._jvm.org.apache.log4j.Logger
    # logger = log4jLogger.getLogger(__name__)

    log4jLogger = spark._jvm.org.apache.log4j
    logger = log4jLogger.LogManager.getLogger("spark_app_logs")
    # logger = log4jLogger.LogManager.getRootLogger("catfish_logs")

    logger.setLevel(log4jLogger.Level.DEBUG)

    logger.info("pyspark script logger initialized")

    sdf_locations = (
        spark.readStream.format("kafka")
        .option("kafka.bootstrap.servers", brokerAddresses)
        .option("subscribe", TOPIC_NAME)
        .option("startingOffsets", "earliest")
        .load()
        .selectExpr("CAST(value AS STRING)",)
    )

    sdf_locations_schema = StructType(
        [
            StructField("driverId", StringType(), True),
            StructField("lat", StringType(), True),
            StructField("lng", StringType(), True),
            StructField("time", StringType(), True),
        ]
    )

    sdf_locations_data = sdf_locations.select(
        from_json("value", sdf_locations_schema).alias("a")
    ).select("a.*")

    sdf_locations_data = apply_location_requirement(sdf_locations_data)

    sdf_locations_data.printSchema()

    # sdf_locations_data.writeStream.format("console").start().awaitTermination()

    sdf_locations_data.writeStream.outputMode("append").foreachBatch(
        partial(postgres_sink, table_name="locations")
    ).trigger(processingTime="15 minute").start()

    spark.streams.awaitAnyTermination()


if __name__ == "__main__":
    main()

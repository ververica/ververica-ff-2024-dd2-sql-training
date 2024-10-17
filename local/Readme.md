Ververica Flink SQL Training
-----------------------------

<p align="center">
    <img src="assets/logo.png">
</p>

This repository contains the code for the **Ververica Flink SQL Trainings**.


### Table of Contents
1. [Environment Setup](#environment-setup)
2. [Register UDF](#register-udf)
3. [Deploy a JAR file](#deploy-a-jar-file)


### Environment Setup
In order to run the code samples we will need a Kafka and Flink cluster up and running.
You can also run the Flink examples from within your favorite IDE in which case you don't need a Flink Cluster.

If you want to run the examples inside a Flink Cluster run to start the Pulsar and Flink clusters.
```shell
docker-compose up
```

When the cluster is up and running successfully run the following command for redpanda:
```shell
./redpanda-setup.sh

```

or this command for kafka setup
```shell
./kafka-setup.sh
```


### Register UDFs
```shell
CREATE FUNCTION maskfn  AS 'com.ververica.udfs.MaskingFn'             LANGUAGE JAVA USING JAR '/opt/flink/jars/ververica-flink-sql-training-0.1.0.jar';
CREATE FUNCTION lookup  AS 'com.ververica.udfs.AsyncLookupFn'         LANGUAGE JAVA USING JAR '/opt/flink/jars/ververica-flink-sql-training-0.1.0.jar';
CREATE FUNCTION agg     AS 'com.ververica.udfs.TestAgg'               LANGUAGE JAVA USING JAR '/opt/flink/jars/ververica-flink-sql-training-0.1.0.jar';
CREATE FUNCTION arragg  AS 'com.ververica.udfs.ArrayListAggFunction'  LANGUAGE JAVA USING JAR '/opt/flink/jars/ververica-flink-sql-training-0.1.0.jar';
```

### Use UDFs
```sql
CREATE TEMPORARY VIEW purchases AS
SELECT UUID() AS cc_num, * 
FROM clickstream 
WHERE event_type='purchase';

SELECT 
  maskfn(cc_num) AS masked_cc_num, cc_num 
FROM purchases;

SELECT 
  user_session,
  user_id,
  event_time,
  event_type,
  product_id,
  serviceResponse, 
  responseTime 
FROM purchases, LATERAL TABLE(lookup(product_id));

SELECT 
  user_session,
  agg(event_type) AS events_per_session_occ 
FROM clickstream 
GROUP BY user_session;

SELECT 
  user_session,
  arragg(event_type) AS unique_event_occ_per_session
FROM clickstream 
GROUP BY user_session;
```

### Deploy a JAR file
#### 1. Package the application and create an executable jar file
```shell
mvn clan package
```
#### 2. Copy it under the jar files to be included in the custom Flink images

#### 3. Start the cluster to build the new images by running
```shell
docker-compose up
```

#### 4. Deploy the flink job
```shell
docker exec -it jobmanager ./bin/flink run \
  --class com.ververica.table.SQLRunner \
  jars/ververica-flink-sql-training-0.1.0.jar
```
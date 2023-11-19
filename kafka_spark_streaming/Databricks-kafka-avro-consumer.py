# Databricks Notebook Source
# MAGIC %pip install confluent_kafka

# COMMAND ----------

from delta.tables import *
from pyspark.sql.avro.functions import from_avro
from pyspark.sql.functions import col, unbase64, explode,map_keys, map_values
from confluent_kafka.schema_registry import SchemaRegistryClient
from pyspark.sql.types import *
from dotenv import load_dotenv
import os
import json

# COMMAND ----------

server_uri='pkc-7xoy1.eu-central-1.aws.confluent.cloud:9092'
topic='poc-pageviews'
kafka_user=os.getenv('CLUSTER_API_KEY')
kafka_pass=os.getenv('CLUSTER_API_SECRET')


registery_uri='https://psrc-v9krz.eu-central-1.aws.confluent.cloud'
confluentRegistryApiKey=os.getenv('SCHEMA_REGISTRY_API_KEY')
confluentRegistrySecret=os.getenv('SCHEMA_REGISTRY_API_SECRET')
schema_registry_conf = {
    'url': registery_uri,
    'basic.auth.user.info': f'{confluentRegistryApiKey}:{confluentRegistrySecret}'}

schema_registry_options = {
  "confluent.schema.registry.basic.auth.credentials.source": "USER_INFO",
  "confluent.schema.registry.basic.auth.user.info": f"{confluentRegistryApiKey}:{confluentRegistrySecret}"
}



sr = SchemaRegistryClient(schema_registry_conf)
schema_id=sr.get_latest_version(subject_name=f'{topic}-value').schema_id
my_schema = sr.get_schema(schema_id).schema_str

# COMMAND ----------

# %sql
# drop table default.streaming

# COMMAND ----------

df = (spark
      .readStream 
      .format("kafka") 
      .option("kafka.bootstrap.servers", server_uri) 
     .option("subscribe", topic) 
      .option("startingOffsets", "earliest") 
      .option("kafka.security.protocol","SASL_SSL") 
      .option("kafka.sasl.mechanism", "PLAIN") 
      .option("kafka.sasl.jaas.config", f"""kafkashaded.org.apache.kafka.common.security.plain.PlainLoginModule required username="{kafka_user}" password="{kafka_pass}";""")
      .load()
      .select(
            from_avro(
                  data = col("value"),
                  options = schema_registry_options,
                  subject = f"{topic}-value",
                  schemaRegistryAddress = registery_uri
            ).alias("value")
      )
)

final_df=df.select([col("value.*")])

# COMMAND ----------

# schema_fileds=json.loads(my_schema)["fields"]
# final_schema_list=[]
# final_schema_list.append('StructType()')
# for field in schema_fileds:
#     name=field['name']
#     field_type=field['type'].capitalize()
#     final_schema_list.append(f'.add("{name}", {field_type}Type())')
# final_schema=eval(''.join(final_schema_list))

# COMMAND ----------

primary_key='userid'

# COMMAND ----------

def upsertToDelta(microBatchOutputDF, batchId):
  uri='/user/hive/warehouse/streaming'
  if DeltaTable.isDeltaTable(spark, uri):
    currentDf = DeltaTable.forPath(spark, uri)
    # currentDf=spark.read.format('delta').load(uri)
    (currentDf.alias("c").merge(
        microBatchOutputDF.alias("u"),
        f"c.{primary_key} = u.{primary_key}")
      .whenMatchedUpdateAll()
      .whenNotMatchedInsertAll()
      .execute()
    )
  else:
    microBatchOutputDF.dropDuplicates([primary_key]).write.format('delta').saveAsTable('default.streaming')

# COMMAND ----------

(final_df.dropDuplicates([primary_key]).writeStream
      .format("delta")
      .foreachBatch(upsertToDelta)
      .option('overwriteSchema', 'true')
      # .option('checkpointLocation', 'dbfs:/user/hive/warehouse/logs')
      .start()
      )

# COMMAND ----------



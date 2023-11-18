from confluent_kafka import KafkaError
from confluent_kafka.schema_registry import SchemaRegistryClient
from confluent_kafka.schema_registry.avro import AvroDeserializer, Schema
from confluent_kafka.avro.cached_schema_registry_client import (
    CachedSchemaRegistryClient,
)
from confluent_kafka import DeserializingConsumer
from confluent_kafka.avro import AvroConsumer
from dotenv import load_dotenv
import os

conf = {
    "bootstrap.servers": "pkc-7xoy1.eu-central-1.aws.confluent.cloud:9092",
    "security.protocol": "SASL_SSL",
    "sasl.mechanism": "PLAIN",
    "sasl.username": f"{os.getenv('CLUSTER_API_KEY')}",
    "sasl.password": f"{os.getenv('CLUSTER_API_SECRET')}",
    "group.id": "python-consumer-powerbi",
    "auto.offset.reset": "earliest",
    "schema.registry.url": "https://psrc-o268o.eu-central-1.aws.confluent.cloud",
    "schema.registry.basic.auth.credentials.source": "USER_INFO",
    "schema.registry.basic.auth.user.info": f"{os.getenv('SCHEMA_REGISTRY_API_KEY')}:{os.getenv('SCHEMA_REGISTRY_API_SECRET')}",
}

# schema_registry_conf = {
#     "url": "https://psrc-o268o.eu-central-1.aws.confluent.cloud",
#     "basic.auth.user.info": f"{os.getenv('SCHEMA_REGISTRY_API_KEY')}:{os.getenv('SCHEMA_REGISTRY_API_SECRET')}",
# }

kafka_topic = "tst-credit-card"
# schema_registry_client = SchemaRegistryClient(schema_registry_conf)
# schema = schema_registry_client.get_latest_version(f"{kafka_topic}-value")
# print(schema)

# value_schema = schema_registry_conf.get_latest_version(f"{kafka_topic}-value")

# print(schema_registry_conf.get_schema("100002"))
# key_schema= schema_registry_conf.get_latest_schema("orders-key")[1]


if __name__ == "__main__":
    # schema_registry_client = SchemaRegistryClient(schema_registry_conf)

    # # Get the schema for the topic
    # schema = schema_registry_client.get_latest_version(f"{kafka_topic}-value")

    # Create an AvroDeserializer object with the schema and the SchemaRegistryClient object
    # avro_deserializer = AvroDeserializer(schema, schema_registry_client)

    # Use the DeserializingConsumer class instead of the Consumer class to automatically deserialize messages
    consumer = AvroConsumer(conf)
    # consumer = DeserializingConsumer(conf)
    consumer.subscribe([kafka_topic])

    while True:
        msg = consumer.poll(1.0)

        if msg is None:
            continue
        if msg.error():
            if msg.error().code() == KafkaError._PARTITION_EOF:
                print("End of partition event")
            else:
                print("Error while polling for message: {}".format(msg.error()))
        else:
            # The message is automatically deserialized using the AvroDeserializer object
            # deserialized_msg = avro_deserializer(msg.value())
            print("Received message: {}".format(msg.value()))

            # print('Received message: {}'.format(deserialized_msg))
            print("Received message: {}".format(msg.value()))

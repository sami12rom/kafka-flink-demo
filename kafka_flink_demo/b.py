
from confluent_kafka import DeserializingConsumer
from confluent_kafka.schema_registry import SchemaRegistryClient
from confluent_kafka.schema_registry.avro import AvroDeserializer
# from confluent_kafka.serialization import DeserializerError
from dotenv import load_dotenv
import os


# Set up the Confluent Schema Registry configuration
schema_registry_conf = {
    "url": "https://psrc-o268o.eu-central-1.aws.confluent.cloud",
    "basic.auth.user.info": f"{os.getenv('SCHEMA_REGISTRY_API_KEY')}:{os.getenv('SCHEMA_REGISTRY_API_SECRET')}",
}

# Set up the Confluent Kafka configuration
kafka_conf = {
    "bootstrap.servers": "pkc-7xoy1.eu-central-1.aws.confluent.cloud:9092",
    "security.protocol": "SASL_SSL",
    "sasl.mechanism": "PLAIN",
    "sasl.username": f"{os.getenv('CLUSTER_API_KEY')}",
    "sasl.password": f"{os.getenv('CLUSTER_API_SECRET')}",
    "group.id": "python-consumer-powerbi",
    "auto.offset.reset": "earliest",
}

# Set up the Avro deserializer
schema_registry_client = SchemaRegistryClient(schema_registry_conf)
avro_deserializer = AvroDeserializer(schema_registry_client)

# Set up the DeserializingConsumer
consumer = DeserializingConsumer({
    **kafka_conf,
    # 'key.deserializer': lambda key: key.decode('utf-8'),
    'value.deserializer': lambda value: avro_deserializer(value),
    # 'schema.registry.url': schema_registry_conf['url'],
    'default.topic.config': {'auto.offset.reset': 'smallest'}
})

# Subscribe to the Kafka topic
consumer.subscribe(['tst-credit-card'])

# Continuously poll for new messages
while True:
    msg = consumer.poll(1.0)

    if msg is None:
        continue
    if msg.error():
        print("Consumer error: {}".format(msg.error()))
        continue

    # Print the message key and value
    print('Received message: key={}, value={}'.format(msg.key(), msg.value()))

    # Access the message value fields using the Avro schema
    try:
        value = msg.value()
        print('Message value fields: {}'.format(value))
    except e as e:
        print("Message deserialization failed for {}: {}".format(msg, e))

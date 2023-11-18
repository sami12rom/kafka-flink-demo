from confluent_kafka import avro
from confluent_kafka.avro import AvroConsumer
from confluent_kafka.avro.serializer import SerializerError
import os
from dotenv import load_dotenv

# Set up the consumer configuration
consumer_conf = {
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

# Set up the Avro consumer
consumer = AvroConsumer(consumer_conf)

# Subscribe to the Kafka topic
consumer.subscribe(['tst-credit-card'])

# Continuously poll for new messages
while True:
    try:
        msg = consumer.poll(1.0)

        if msg is None:
            continue

        if msg.error():
            print("Consumer error: {}".format(msg.error()))
            continue

        # Deserialize the Avro message
        value = msg.value().decode('utf-8')
        schema = avro.loads(consumer._client.get_schema(msg.topic() + '-value', msg.value()['schema_id']))
        deserialized_value = schema.deserialize(value)
        print(deserialized_value)

    except SerializerError as e:
        print("Message deserialization failed for {}: {}".format(msg, e))
        break

# Close the consumer when finished
consumer.close()

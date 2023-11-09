from kafka_connect import KafkaConnect
from collections import MutableMapping
from collections.abc import MutableMapping

connect = KafkaConnect()

print(connect.api.version)
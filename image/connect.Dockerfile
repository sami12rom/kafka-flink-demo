FROM confluentinc/cp-kafka-connect:latest
RUN confluent-hub install debezium/debezium-connector-postgresql:latest --no-prompt --verbose
RUN confluent-hub install confluentinc/kafka-connect-azure-blob-storage:latest --no-prompt --verbose
RUN confluent-hub install microsoftcorporation/kafka-connect-cosmos:1.10.0 --no-prompt --verbose
RUN curl -sL --http1.1 https://cnfl.io/cli | sh -s -- latest
# RUN confluent-hub install  --no-prompt --verbose

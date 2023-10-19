FROM confluentinc/cp-kafka-connect:latest
RUN confluent-hub install debezium/debezium-connector-postgresql:latest --no-prompt --verbose
RUN confluent-hub install confluentinc/kafka-connect-azure-blob-storage:latest --no-prompt --verbose
RUN confluent-hub install microsoftcorporation/kafka-connect-cosmos:1.10.0 --no-prompt --verbose
RUN wget -P /usr/tmp/ https://github.com/castorm/kafka-connect-http/releases/download/v0.8.11/castorm-kafka-connect-http-0.8.11.zip;
RUN confluent-hub install /usr/tmp/castorm-kafka-connect-http-0.8.11.zip --no-prompt --verbose

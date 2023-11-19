
# # Sink Page Views to PowerBI
# resource "confluent_connector" "PowerBI" {
#   environment {
#     id = confluent_environment.cc_demo_env.id
#   }
#   kafka_cluster {
#     id = confluent_kafka_cluster.cc_kafka_cluster.id
#   }
#   config_sensitive = {
#     "kafka.api.secret" : confluent_api_key.clients_kafka_cluster_key.secret,
#   }
#   config_nonsensitive = {
#     "connector.class" : "HttpSink",
#     "topics" : var.TOPIC_2_PBI,
#     "schema.context.name" : "default",
#     "input.data.format" : "AVRO",
#     "name" : "HttpSinkConnectorToPBI",
#     "kafka.auth.mode" : "KAFKA_API_KEY",
#     "kafka.api.key" : confluent_api_key.clients_kafka_cluster_key.id,
#     "http.api.url" : var.PBI_API_URL,
#     "request.method" : "POST",
#     "behavior.on.null.values" : "ignore",
#     "behavior.on.error" : "ignore",
#     "report.errors.as" : "error_string",
#     "request.body.format" : "json",
#     "batch.max.size" : "1",
#     "auth.type" : "NONE",
#     "oauth2.token.property" : "access_token",
#     "oauth2.client.auth.mode" : "header",
#     "oauth2.client.scope" : "any",
#     "oauth2.jwt.enabled" : "false",
#     "retry.on.status.codes" : "400-",
#     "max.retries" : "3",
#     "retry.backoff.ms" : "3000",
#     "http.connect.timeout.ms" : "30000",
#     "http.request.timeout.ms" : "30000",
#     "https.ssl.protocol" : "TLSv1.3",
#     "https.host.verifier.enabled" : "true",
#     "max.poll.interval.ms" : "60000",
#     "max.poll.records" : "500",
#     "tasks.max" : "1",
#     # "transforms" : "InsertMetadata, TimeStampConverter",
#     # "transforms.InsertMetadata.type" : "org.apache.kafka.connect.transforms.InsertField$Value",
#     # "transforms.InsertMetadata.offset.field" : "offset",
#     # "transforms.InsertMetadata.partition.field" : "partition",
#     # "transforms.InsertMetadata.timestamp.field" : "timestamp",
#     # "transforms.InsertMetadata.topic.field" : "topic",
#     # "transforms.TimeStampConverter.type": "org.apache.kafka.connect.transforms.TimestampConverter$Value",
#     # "transforms.TimeStampConverter.target.type": "string",
#     # "transforms.TimeStampConverter.field": "timestamp",
#     # "transforms.TimeStampConverter.format": "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
#   }
#   depends_on = [
#     confluent_kafka_acl.connectors_acls_demo_topic,
#     confluent_kafka_acl.connectors_acls_dlq_topic,
#     confluent_connector.datagen_pageviews
#   ]
#   lifecycle {
#     prevent_destroy = false
#   }
# }
# output "PowerBISink" {
#   description = "CC Sink to API - PowerBI"
#   value       = resource.confluent_connector.PowerBI.id
# }
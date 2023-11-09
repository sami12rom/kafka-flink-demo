# --------------------------------------------------------
# Service Accounts (Connectors)
# --------------------------------------------------------
resource "confluent_service_account" "connectors" {
  display_name = "connectors-${random_id.id.hex}"
  description  = local.description
  lifecycle {
    prevent_destroy = false
  }
}


# --------------------------------------------------------
# Create Kafka topics for the DataGen Connectors
# --------------------------------------------------------
resource "confluent_kafka_topic" "pageviews" {
  kafka_cluster {
    id = confluent_kafka_cluster.cc_kafka_cluster.id
  }
  topic_name    = "demo-pageviews"
  rest_endpoint = confluent_kafka_cluster.cc_kafka_cluster.rest_endpoint
  partitions_count = 6
  credentials {
    key    = confluent_api_key.app_manager_kafka_cluster_key.id
    secret = confluent_api_key.app_manager_kafka_cluster_key.secret
  }
  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_kafka_topic" "credit_card" {
  kafka_cluster {
    id = confluent_kafka_cluster.cc_kafka_cluster.id
  }
  topic_name    = "demo-credit-card"
  rest_endpoint = confluent_kafka_cluster.cc_kafka_cluster.rest_endpoint
  partitions_count = 6
  credentials {
    key    = confluent_api_key.app_manager_kafka_cluster_key.id
    secret = confluent_api_key.app_manager_kafka_cluster_key.secret
  }
  lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# Connectors
# --------------------------------------------------------

# # datagen_pageviews
# resource "confluent_connector" "datagen_pageviews" {
#   environment {
#     id = confluent_environment.cc_demo_env.id
#   }
#   kafka_cluster {
#     id = confluent_kafka_cluster.cc_kafka_cluster.id
#   }
#   config_sensitive = {}
#   config_nonsensitive = {
#     "connector.class"          = "DatagenSource"
#     "name"                     = "DSoC_pageviews"
#     "kafka.auth.mode"          = "SERVICE_ACCOUNT"
#     "kafka.service.account.id" = confluent_service_account.connectors.id
#     "kafka.topic"              = confluent_kafka_topic.pageviews.topic_name
#     "output.data.format"       = "AVRO"
#     "quickstart"               = "PAGEVIEWS"
#     "tasks.max"                = "1"
#     "max.interval"             = "500"
#   }
# #   depends_on = [
# #     confluent_kafka_acl.connectors_source_create_topic_demo,
# #     confluent_kafka_acl.connectors_source_write_topic_demo,
# #     confluent_kafka_acl.connectors_source_read_topic_demo,
# #     confluent_kafka_acl.connectors_source_create_topic_dlq,
# #     confluent_kafka_acl.connectors_source_write_topic_dlq,
# #     confluent_kafka_acl.connectors_source_read_topic_dlq,
# #     confluent_kafka_acl.connectors_source_consumer_group,
# #   ]
#   lifecycle {
#     prevent_destroy = false
#   }
# }
# output "datagen_pageviews" {
#   description = "CC Datagen Pageviews Connector ID"
#   value       = resource.confluent_connector.datagen_pageviews.id
# }
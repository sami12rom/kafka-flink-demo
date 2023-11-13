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
  topic_name       = "tst-pageviews"
  rest_endpoint    = confluent_kafka_cluster.cc_kafka_cluster.rest_endpoint
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
  topic_name       = "tst-credit-card"
  rest_endpoint    = confluent_kafka_cluster.cc_kafka_cluster.rest_endpoint
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
# Custom Connectors
# --------------------------------------------------------
resource "confluent_custom_connector_plugin" "sink" {
  # https://docs.confluent.io/cloud/current/connectors/bring-your-connector/custom-connector-qs.html#custom-connector-quick-start
  display_name                = "Azure Blob Storage Sink Connector"
  documentation_link          = "https://docs.confluent.io/kafka-connectors/azure-blob-storage-sink/current/overview.html"
  connector_class             = "io.confluent.connect.azure.blob.AzureBlobStorageSinkConnector"
  connector_type              = "SINK"
  sensitive_config_properties = ["azblob.account.key"]
  filename                    = "../confluent_platform_demo/plugins/confluentinc-kafka-connect-azure-blob-storage-1.6.18.zip"
}

# --------------------------------------------------------
# Connectors
# --------------------------------------------------------

# datagen_pageviews
resource "confluent_connector" "datagen_pageviews" {
  environment {
    id = confluent_environment.cc_demo_env.id
  }
  kafka_cluster {
    id = confluent_kafka_cluster.cc_kafka_cluster.id
  }
  config_sensitive = {}
  config_nonsensitive = {
    "connector.class"          = "DatagenSource"
    "name"                     = "DSoC_pageviews"
    "kafka.auth.mode"          = "SERVICE_ACCOUNT"
    "kafka.service.account.id" = confluent_service_account.connectors.id
    "kafka.topic"              = confluent_kafka_topic.pageviews.topic_name
    "output.data.format"       = "AVRO"
    "quickstart"               = "PAGEVIEWS"
    "tasks.max"                = "1"
    "max.interval"             = "500"
  }
  depends_on = [
    confluent_kafka_acl.connectors_acls_demo_topic,
    confluent_kafka_acl.connectors_acls_dlq_topic,
  ]
  lifecycle {
    prevent_destroy = false
  }
}
output "datagen_pageviews" {
  description = "CC Datagen Pageviews Connector ID"
  value       = resource.confluent_connector.datagen_pageviews.id
}

# datagen_credit_card
resource "confluent_connector" "datagen_credit_card" {
  environment {
    id = confluent_environment.cc_demo_env.id
  }
  kafka_cluster {
    id = confluent_kafka_cluster.cc_kafka_cluster.id
  }
  config_sensitive = {}
  config_nonsensitive = {
    "connector.class"          = "DatagenSource"
    "name"                     = "DSoC_credit_card"
    "kafka.auth.mode"          = "SERVICE_ACCOUNT"
    "kafka.service.account.id" = confluent_service_account.connectors.id
    "kafka.topic"              = confluent_kafka_topic.credit_card.topic_name
    "output.data.format"       = "AVRO"
    # "quickstart"               = "credit_cards"
    "schema.string"            = file("./schemas/credit_card.avsc")
    "schema.keyfield"          = "userid"
    "tasks.max"                = "1"
    "max.interval"             = "500"
  }
  depends_on = [
    confluent_kafka_acl.connectors_acls_demo_topic,
    confluent_kafka_acl.connectors_acls_dlq_topic,
  ]
  lifecycle {
    prevent_destroy = false
  }
}
output "datagen_credit_card" {
  description = "CC Datagen Credit Card Connector ID"
  value       = resource.confluent_connector.datagen_credit_card.id
}

# --------------------------------------------------------
# Access Control List (ACL)
# --------------------------------------------------------
resource "confluent_kafka_acl" "connectors_acls_demo_topic" {
  for_each = toset(var.acl_operation)

  kafka_cluster {
    id = confluent_kafka_cluster.cc_kafka_cluster.id
  }
  resource_type = "TOPIC"
  resource_name = "tst-"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.connectors.id}"
  operation     = each.value
  permission    = "ALLOW"
  host          = "*"
  rest_endpoint = confluent_kafka_cluster.cc_kafka_cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.app_manager_kafka_cluster_key.id
    secret = confluent_api_key.app_manager_kafka_cluster_key.secret
  }
  lifecycle {
    prevent_destroy = false
  }
}
resource "confluent_kafka_acl" "connectors_acls_dlq_topic" {
  for_each = toset(var.acl_operation)

  kafka_cluster {
    id = confluent_kafka_cluster.cc_kafka_cluster.id
  }
  resource_type = "TOPIC"
  resource_name = "dlq-"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.connectors.id}"
  operation     = each.value
  permission    = "ALLOW"
  host          = "*"
  rest_endpoint = confluent_kafka_cluster.cc_kafka_cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.app_manager_kafka_cluster_key.id
    secret = confluent_api_key.app_manager_kafka_cluster_key.secret
  }
  lifecycle {
    prevent_destroy = false
  }
}
# Consumer group
resource "confluent_kafka_acl" "connectors_source_consumer_group" {
  kafka_cluster {
    id = confluent_kafka_cluster.cc_kafka_cluster.id
  }
  resource_type = "GROUP"
  resource_name = "connect"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.connectors.id}"
  operation     = "READ"
  permission    = "ALLOW"
  host          = "*"
  rest_endpoint = confluent_kafka_cluster.cc_kafka_cluster.rest_endpoint
  credentials {
    key    = confluent_api_key.app_manager_kafka_cluster_key.id
    secret = confluent_api_key.app_manager_kafka_cluster_key.secret
  }
  lifecycle {
    prevent_destroy = false
  }
}
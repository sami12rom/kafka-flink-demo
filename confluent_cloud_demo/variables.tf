locals {
  description = "Resource created using terraform"
}
# --------------------------------------------------------
# This 'random_id_4' will make whatever you create (names, etc)
# unique in your account.
# --------------------------------------------------------
resource "random_id" "id" {
  byte_length = 1
}

# ----------------------------------------
# Confluent Cloud Kafka cluster variables
# ----------------------------------------
variable "cc_cloud_provider" {
  type    = string
  default = "AWS"
}

variable "cc_cloud_region" {
  type    = string
  default = "eu-central-1"
}

variable "cc_env_name" {
  type    = string
  default = "kafka_flink_demo"
}

variable "cc_cluster_name" {
  type    = string
  default = "cc_demo_cluster"
}

variable "cc_availability" {
  type    = string
  default = "SINGLE_ZONE"
}


# ------------------------------------------
# Confluent Cloud Connectors variables
# ------------------------------------------
variable "acl_operation" {
  type = list
  default = ["CREATE", "WRITE", "READ"]
}

# ------------------------------------------
# Confluent Cloud Schema Registry variables
# ------------------------------------------
variable "sr_cloud_provider" {
  type    = string
  default = "AWS"
}

variable "sr_cloud_region" {
  type    = string
  default = "eu-central-1"
}

variable "sr_package" {
  type    = string
  default = "ESSENTIALS"
}

# --------------------------------------------
# Confluent Cloud Flink Compute Pool variables
# --------------------------------------------
variable "cc_dislay_name" {
  type    = string
  default = "standard_compute_pool"
}

variable "cc_compute_pool_name" {
  type    = string
  default = "cc_demo_flink"
}

variable "cc_compute_pool_cfu" {
  type    = number
  default = 5
}

# --------------------------------------------
# Azure
# --------------------------------------------
#variable "admin_username" {}
#variable "admin_password" {}
variable "PBI_API_URL" {}
variable "TOPIC_2_PBI" {}

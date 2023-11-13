![logo](docs/logos.png)


# Elevating Analytics with Real-Time Data Streaming: A Deep Dive into Kafka
![Azure](https://img.shields.io/badge/azure-%230072C6.svg?style=for-the-badge&logo=microsoftazure&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![Power Bi](https://img.shields.io/badge/power_bi-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)

![Apache Kafka](https://img.shields.io/badge/Apache%20Kafka-000?style=for-the-badge&logo=apachekafka)
![Apache Flink](https://img.shields.io/badge/Apache%20Flink-E6526F?style=for-the-badge&logo=Apache%20Flink&logoColor=white)
![Databricks](https://img.shields.io/badge/Databricks-FF3621?style=for-the-badge&logo=Databricks&logoColor=white)
![Pyspark](https://img.shields.io/badge/Apache_Spark-FFFFFF?style=for-the-badge&logo=apachespark&logoColor=#E35A16)



Welcome to our repository, crafted to highlight the seamless integration and ease of use of Kafka. Dive into:

1. Set up Confluent Cloud, Connectors & Flink.
2. Set up Confluent Kafka Platform Locally


## Created by

This repo has been created by:
|#|Name|Contact|
|----|---|---|
|1|Sami Alashabi|[![](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/sami-alashabi)|
|2|Maria Berinde-Tampanariu|[![](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/maria-berinde-tampanariu)|



## Design
[![infrastructure](./docs/infrastructure.png)](https://app.cloudcraft.co/view/a1e84540-b924-4a33-b1c9-f8044601c945?key=3m40jn0enpfd2t90&interactive=true&embed=true)


## Slides
[![Google Slides Badge](https://img.shields.io/badge/Google%20Slides-FBBC04?logo=googleslides&logoColor=000&style=for-the-badge)](https://docs.google.com/presentation/d/1lTWvNwJgJphgH6YUYEL9AiE-nlDidsqMNJF_MiJryl4/edit?exids=71471483,71471477&pli=1#slide=id.g1ea5efd3fa5_0_3148)


# Installation
Installation needs to be do once

## Pre-requisites
- User account on [Confluent Cloud](https://www.confluent.io/confluent-cloud/tryfree)
- Local install of [Terraform](https://www.terraform.io) (details below)
- Local install of [jq](https://jqlang.github.io/jq/download) (details below)

## Install Terraform
```
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
brew update
brew upgrade hashicorp/tap/terraform
```

## Install jq
```
brew install jq
```

# Set up services for the demo

## Set environment variables
- Create file `.env`
```
#!/bin/bash

# Confluent Platform
export CONFLUENT_CLOUD_API_KEY="Enter credentials here"
export CONFLUENT_CLOUD_API_SECRET="Enter credentials here"
```
## Start Demo
- Run command: `./demo_start.sh`
- Access Confluent Cloud: https://confluent.cloud/login
- Select your Environment
- Select tab `Flink (preview)`
- Access your Flink Compute Pool
- Click `Open SQL Workspace`
<img src="docs/flinktTab.png" width="70%">


## Flink Compute Pool
- Select Catalog: `kafka_flink_demo_xx`
- Select Database: `cc-demo-cluster`
<img src="docs/flinkSQL.png" width="70%">
- Proceed to submit the below SQL queries (one at each tab):

```sql

--------------------------------------------------------
-- View demo-pageviews table (from topic with same name)
--------------------------------------------------------
describe extended `demo-pageviews`;

---------------------------------------
select * from `demo-pageviews`;
---------------------------------------

---------------------------------------------------------------
-- Create table demo-users (topic with same name to be created)
---------------------------------------------------------------
CREATE TABLE `demo-users` (
  `userid` STRING,
  `full_name` STRING,
  `regionid` STRING,
  `gender` STRING,
  `avg_credit_spend` DOUBLE
) WITH (
  'changelog.mode' = 'retract'
);

----------------------------------------------------------------------
-- Populate table demo-users (see new messages published in the topic)
----------------------------------------------------------------------
INSERT INTO `demo-users` (`userid`, `full_name`, `regionid`, `gender`,  `avg_credit_spend`) 
VALUES
  ('User_1', 'Blake Lambert', 'Region_10', 'MALE', 2650.0),
  ('User_2', 'Olivia Anderson', 'Region_20', 'FEMALE', 5721.0),
  ('User_3', 'Evan Hughes', 'Region_30', 'MALE', 4822.0),
  ('User_4', 'Sonia Marshall', 'Region_40', 'FEMALE', 2629.0),
  ('User_5', 'Benjamin Stewart', 'Region_50', 'MALE', 1455.0),
  ('User_6', 'Caroline Coleman', 'Region_60', 'FEMALE', 3999.0),
  ('User_7', 'Oliver Chapman', 'Region_70', 'MALE', 40233.0),
  ('User_8', 'Rose Skinner', 'Region_80', 'FEMALE', 4611.0),
  ('User_9', 'Bernadette Cameron', 'Region_90', 'OTHER', 5623.0);

---------------------------------------
select * from `demo-users`;
---------------------------------------

```


## Stop Demo
- Run command: `./demo_stop.sh`


# Terraform Documentation
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | =3.0.0 |
| <a name="requirement_confluent"></a> [confluent](#requirement\_confluent) | 1.55.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~>3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.0.0 |
| <a name="provider_confluent"></a> [confluent](#provider\_confluent) | 1.55.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |

## Resources

| Name | Type |
|------|------|
| [azurerm_dev_test_global_vm_shutdown_schedule.myschedule](https://registry.terraform.io/providers/hashicorp/azurerm/3.0.0/docs/resources/dev_test_global_vm_shutdown_schedule) | resource |
| [azurerm_network_interface.my_terraform_nic](https://registry.terraform.io/providers/hashicorp/azurerm/3.0.0/docs/resources/network_interface) | resource |
| [azurerm_network_interface_security_group_association.example](https://registry.terraform.io/providers/hashicorp/azurerm/3.0.0/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_network_security_group.my_terraform_nsg](https://registry.terraform.io/providers/hashicorp/azurerm/3.0.0/docs/resources/network_security_group) | resource |
| [azurerm_public_ip.my_terraform_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/3.0.0/docs/resources/public_ip) | resource |
| [azurerm_storage_account.mystorage](https://registry.terraform.io/providers/hashicorp/azurerm/3.0.0/docs/resources/storage_account) | resource |
| [azurerm_storage_container.example](https://registry.terraform.io/providers/hashicorp/azurerm/3.0.0/docs/resources/storage_container) | resource |
| [azurerm_subnet.my_terraform_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/3.0.0/docs/resources/subnet) | resource |
| [azurerm_virtual_network.my_terraform_network](https://registry.terraform.io/providers/hashicorp/azurerm/3.0.0/docs/resources/virtual_network) | resource |
| [azurerm_windows_virtual_machine.main](https://registry.terraform.io/providers/hashicorp/azurerm/3.0.0/docs/resources/windows_virtual_machine) | resource |
| [confluent_api_key.app_manager_kafka_cluster_key](https://registry.terraform.io/providers/confluentinc/confluent/1.55.0/docs/resources/api_key) | resource |
| [confluent_api_key.clients_kafka_cluster_key](https://registry.terraform.io/providers/confluentinc/confluent/1.55.0/docs/resources/api_key) | resource |
| [confluent_api_key.sr_cluster_key](https://registry.terraform.io/providers/confluentinc/confluent/1.55.0/docs/resources/api_key) | resource |
| [confluent_custom_connector_plugin.sink](https://registry.terraform.io/providers/confluentinc/confluent/1.55.0/docs/resources/custom_connector_plugin) | resource |
| [confluent_environment.cc_demo_env](https://registry.terraform.io/providers/confluentinc/confluent/1.55.0/docs/resources/environment) | resource |
| [confluent_flink_compute_pool.cc_flink_compute_pool](https://registry.terraform.io/providers/confluentinc/confluent/1.55.0/docs/resources/flink_compute_pool) | resource |
| [confluent_kafka_cluster.cc_kafka_cluster](https://registry.terraform.io/providers/confluentinc/confluent/1.55.0/docs/resources/kafka_cluster) | resource |
| [confluent_kafka_topic.credit_card](https://registry.terraform.io/providers/confluentinc/confluent/1.55.0/docs/resources/kafka_topic) | resource |
| [confluent_kafka_topic.pageviews](https://registry.terraform.io/providers/confluentinc/confluent/1.55.0/docs/resources/kafka_topic) | resource |
| [confluent_role_binding.app_manager_environment_admin](https://registry.terraform.io/providers/confluentinc/confluent/1.55.0/docs/resources/role_binding) | resource |
| [confluent_role_binding.clients_cluster_admin](https://registry.terraform.io/providers/confluentinc/confluent/1.55.0/docs/resources/role_binding) | resource |
| [confluent_role_binding.demo-rb](https://registry.terraform.io/providers/confluentinc/confluent/1.55.0/docs/resources/role_binding) | resource |
| [confluent_role_binding.sr_environment_admin](https://registry.terraform.io/providers/confluentinc/confluent/1.55.0/docs/resources/role_binding) | resource |
| [confluent_schema_registry_cluster.cc_sr_cluster](https://registry.terraform.io/providers/confluentinc/confluent/1.55.0/docs/resources/schema_registry_cluster) | resource |
| [confluent_service_account.app_manager](https://registry.terraform.io/providers/confluentinc/confluent/1.55.0/docs/resources/service_account) | resource |
| [confluent_service_account.clients](https://registry.terraform.io/providers/confluentinc/confluent/1.55.0/docs/resources/service_account) | resource |
| [confluent_service_account.connectors](https://registry.terraform.io/providers/confluentinc/confluent/1.55.0/docs/resources/service_account) | resource |
| [confluent_service_account.demo-sa](https://registry.terraform.io/providers/confluentinc/confluent/1.55.0/docs/resources/service_account) | resource |
| [confluent_service_account.sr](https://registry.terraform.io/providers/confluentinc/confluent/1.55.0/docs/resources/service_account) | resource |
| [confluent_tag.pii](https://registry.terraform.io/providers/confluentinc/confluent/1.55.0/docs/resources/tag) | resource |
| [random_id.id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_pet.prefix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [azurerm_resource_group.demo](https://registry.terraform.io/providers/hashicorp/azurerm/3.0.0/docs/data-sources/resource_group) | data source |
| [confluent_schema_registry_region.cc_demo_sr](https://registry.terraform.io/providers/confluentinc/confluent/1.55.0/docs/data-sources/schema_registry_region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | n/a | `any` | n/a | yes |
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | -------------------------------------------- Azure -------------------------------------------- | `any` | n/a | yes |
| <a name="input_cc_availability"></a> [cc\_availability](#input\_cc\_availability) | n/a | `string` | `"SINGLE_ZONE"` | no |
| <a name="input_cc_cloud_provider"></a> [cc\_cloud\_provider](#input\_cc\_cloud\_provider) | ---------------------------------------- Confluent Cloud Kafka cluster variables ---------------------------------------- | `string` | `"AWS"` | no |
| <a name="input_cc_cloud_region"></a> [cc\_cloud\_region](#input\_cc\_cloud\_region) | n/a | `string` | `"eu-central-1"` | no |
| <a name="input_cc_cluster_name"></a> [cc\_cluster\_name](#input\_cc\_cluster\_name) | n/a | `string` | `"cc_demo_cluster"` | no |
| <a name="input_cc_compute_pool_cfu"></a> [cc\_compute\_pool\_cfu](#input\_cc\_compute\_pool\_cfu) | n/a | `number` | `5` | no |
| <a name="input_cc_compute_pool_name"></a> [cc\_compute\_pool\_name](#input\_cc\_compute\_pool\_name) | n/a | `string` | `"cc_demo_flink"` | no |
| <a name="input_cc_dislay_name"></a> [cc\_dislay\_name](#input\_cc\_dislay\_name) | -------------------------------------------- Confluent Cloud Flink Compute Pool variables -------------------------------------------- | `string` | `"standard_compute_pool"` | no |
| <a name="input_cc_env_name"></a> [cc\_env\_name](#input\_cc\_env\_name) | n/a | `string` | `"kafka_flink_demo"` | no |
| <a name="input_sr_cloud_provider"></a> [sr\_cloud\_provider](#input\_sr\_cloud\_provider) | ------------------------------------------ Confluent Cloud Schema Registry variables ------------------------------------------ | `string` | `"AWS"` | no |
| <a name="input_sr_cloud_region"></a> [sr\_cloud\_region](#input\_sr\_cloud\_region) | n/a | `string` | `"eu-central-1"` | no |
| <a name="input_sr_package"></a> [sr\_package](#input\_sr\_package) | n/a | `string` | `"ESSENTIALS"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cc_demo_env"></a> [cc\_demo\_env](#output\_cc\_demo\_env) | CC Environment |
| <a name="output_cc_demo_sa"></a> [cc\_demo\_sa](#output\_cc\_demo\_sa) | CC Service Account |
| <a name="output_cc_demo_sr"></a> [cc\_demo\_sr](#output\_cc\_demo\_sr) | CC Schema Registry Region |
| <a name="output_cc_kafka_cluster"></a> [cc\_kafka\_cluster](#output\_cc\_kafka\_cluster) | CC Kafka Cluster ID |
| <a name="output_cc_sr_cluster"></a> [cc\_sr\_cluster](#output\_cc\_sr\_cluster) | CC SR Cluster ID |
| <a name="output_id"></a> [id](#output\_id) | n/a |

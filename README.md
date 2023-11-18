# Elevating Analytics with Real-Time Data Streaming: A Deep Dive into Kafka
![Azure](https://img.shields.io/badge/azure-%230072C6.svg?style=for-the-badge&logo=microsoftazure&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![Power Bi](https://img.shields.io/badge/power_bi-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)

![Apache Kafka](https://img.shields.io/badge/Apache%20Kafka-000?style=for-the-badge&logo=apachekafka)
![Apache Flink](https://img.shields.io/badge/Apache%20Flink-E6526F?style=for-the-badge&logo=Apache%20Flink&logoColor=white)
![Pyspark](https://img.shields.io/badge/Apache_Spark-FFFFFF?style=for-the-badge&logo=apachespark&logoColor=#E35A16)
![Databricks](https://img.shields.io/badge/Databricks-FF3621?style=for-the-badge&logo=Databricks&logoColor=white)



Welcome to our repository, crafted to highlight the seamless integration and ease of use of Kafka. Dive into:

1. Set up Confluent Cloud, Connectors & Flink.
<!-- 2. Set up Confluent Kafka Platform Locally -->


## Created by

This repo has been created by:
|#|Name|Contact|
|----|---|---|
|1|Sami Alashabi|[![](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/sami-alashabi)|
|2|Maria Berinde-Tampanariu|[![](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/maria-berinde-tampanariu)|
|3|Ramzi Alashabi|[![](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/ramzialashabi/)|



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

---------------------------------------------------------------
-- Create table users (A topic with same name will be created)
---------------------------------------------------------------
CREATE TABLE `users` (
  `userid` INT,
  `fullname` STRING,
  `credit_card_last_four_digits` STRING,
  `gender` STRING,
  `email` STRING,  
  `ipaddress` STRING,
  `company` STRING,  
  `avg_credit_spend` DOUBLE
) WITH (
  'changelog.mode' = 'retract'
);

describe extended `users`;

--------------------------------------------------------------------------
-- Populate table users (You will see new messages published in the topic)
--------------------------------------------------------------------------
INSERT INTO `users` (`userid`, `fullname`,`credit_card_last_four_digits`, `gender`, `email`, `ipaddress`, `company`, `avg_credit_spend`) VALUES
(1, 'Lodovico Hinemoor', '1234', 'Male', 'lhinemoor0@wix.com', '72.197.144.165', 'Dynabox', 2650.0),
(2, 'Panchito Mitchiner', '2345', 'Genderfluid', 'pmitchiner1@senate.gov', '13.246.111.16', 'Aivee', 4119.27),
(3, 'Zachery Townley', '3456', 'Male', 'ztownley2@mail.ru', '197.231.118.1', 'Fanoodle', 2119.76),
(4, 'Juli Barcroft', '4567', 'Female', 'jbarcroft3@t-online.de', '138.246.248.76', 'Yodo', 1271.58),
(5, 'Elisabeth Gentry', '5678', 'Female', 'egentry4@homestead.com', '236.176.123.77', 'Skaboo', 2783.47),
(6, 'Richart Bradfield', '6789', 'Male', 'rbradfield5@amazon.co.uk', '71.180.87.61', 'Meejo', 2154.45),
(7, 'Helene Hargrove', '7890', 'Female', 'hhargrove6@51.la', '240.88.89.167', 'Browsebug', 2333.36),
(8, 'Benji Geck', '8901', 'Male', 'bgeck7@sun.com', '250.2.253.193', 'Yombu', 3999.74),
(9, 'Gannie O''Brollachain', '9012', 'Non-binary', 'gobrollachain8@technorati.com', '185.20.56.89', 'Einti', 3817.99),
(10, 'Elyn Cromarty', '0123', 'Female', 'ecromarty9@ask.com', '167.68.56.180', 'Shufflester', 5263.34),
(11, 'Hurley Cochrane', '1111', 'Male', 'hcochranea@businessinsider.com', '241.69.23.160', 'LiveZ', 4935.66),
(12, 'Elfrida Yegorshin', '2876', 'Female', 'eyegorshinb@odnoklassniki.ru', '36.208.43.205', 'Blognation', 2796.26),
(13, 'Free Pymm', '3211', 'Male', 'fpymmc@oakley.com', '4.232.220.231', 'Realcube', 4050.23),
(14, 'Prissie Avramovich', '4721', 'Female', 'pavramovichd@nhs.uk', '65.87.4.235', 'Vitz', 1637.76),
(15, 'Cindie Pinchbeck', '5005', 'Female', 'cpinchbecke@cmu.edu', '7.26.91.164', 'Youopia', 5038.34),
(16, 'Jerrold Strugnell', '1616', 'Male', 'jstrugnellf@netvibes.com', '15.38.20.244', 'Devpoint', 2947.57);

select * from `users` LIMIT 16;

----------------------------------------------------------------------------
-- Create table credit-card-enriched (topic with same name will be created)
----------------------------------------------------------------------------
CREATE TABLE `credit-card-enriched` (
  `userid` INT,
  `credit_card_last_four_digits` STRING,
  `fullname` STRING,
  `gender` STRING,
  `email` STRING,  
  `ipaddress` STRING,
  `company` STRING,  
  `avg_credit_spend` DOUBLE,
  `amount` DOUBLE,
  `transaction_id` BIGINT,
  `timestamp` TIMESTAMP(0),
  WATERMARK FOR `timestamp` AS `timestamp` - INTERVAL '1' MINUTES
) WITH (
  'changelog.mode' = 'retract'
);

describe extended `credit-card-enriched`;

----------------------------------------------------------------------------------
-- Merge tables poc-credit-card-transactions and users (non-transactional) 
----------------------------------------------------------------------------------
INSERT INTO `credit-card-enriched` (`userid`, `credit_card_last_four_digits`, `fullname`, `gender`, `email`, `ipaddress`, `company`, `amount`, `avg_credit_spend`, `transaction_id`, `timestamp`)
SELECT
  u.`userid`,
  c.`credit_card_last_four_digits`,
  u.`fullname`,
  u.`gender`,
  u.`email`,
  u.`ipaddress`,
  u.`company`,
  c.`amount`,
  u.`avg_credit_spend`,
  c.`transaction_id`,
  c.`timestamp`
FROM
  `poc-credit-card-transactions` as c
LEFT JOIN `users` AS u
ON
  c.`credit_card_last_four_digits` = u.`credit_card_last_four_digits`;

select * from `credit-card-enriched`;


------------------------------------------------------------------------
-- Create table possible-fraud (topic with same name will be created)
------------------------------------------------------------------------
CREATE TABLE `possible-fraud` (
  `userid` INT,
  `credit_card_last_four_digits` STRING,
  `fullname` STRING,
  `gender` STRING,
  `email` STRING, 
  `timestamp` TIMESTAMP(0),
  `sum_amount` DOUBLE,
  `max_avg_credit_spend` DOUBLE,
  WATERMARK FOR `timestamp` AS `timestamp` - INTERVAL '1' MINUTES
) WITH (
  'changelog.mode' = 'retract'
);

describe extended `possible-fraud`;

-------------------------------------------------------------------------------------------------
-- Populate table possible-fraud (If sum of amount if greater than average credit card spend)
-------------------------------------------------------------------------------------------------
INSERT INTO `possible-fraud`
SELECT
  `userid`,
  `credit_card_last_four_digits`,
  `fullname`,
  `gender`,
  `email`,
  `window_start`,
   SUM(`amount`),
   MAX(`avg_credit_spend`)
FROM
  TABLE(
    TUMBLE(TABLE `credit-card-enriched`, DESCRIPTOR(`timestamp`), INTERVAL '30' SECONDS)
  )
GROUP BY `credit_card_last_four_digits`, `userid`, `fullname`, `gender`,`email`, `window_start`
HAVING
  SUM(`amount`) > MAX(`avg_credit_spend`);

select * from `possible-fraud`;

```

### Review Running Flink SQL statements
  - Access your Environment: `kafka_flink_demo-xx`
 - Select tab `Flink (preview)`
 - Select tab `Flink statements`
 - Filter by Status `Running` (see example below)
 <img src="docs/flinkSQL.png" width="70%">

<!-- ### Table Model
[![See the Model]()](https://dbdiagram.io/e/655297567d8bbd64651b96b9/6552975f7d8bbd64651b975b) -->


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

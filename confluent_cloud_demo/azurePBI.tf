resource "random_pet" "prefix" {
  prefix = "win-vm-iis"
  length = 1
}

data "azurerm_resource_group" "demo" {
  name = "MCD_Sandbox_Sami"
}
output "id" {
  value = data.azurerm_resource_group.demo.id
}

# # Create virtual network
# resource "azurerm_virtual_network" "my_terraform_network" {
#   name                = "${random_pet.prefix.id}-vnet"
#   address_space       = ["10.0.0.0/16"]
#   resource_group_name = data.azurerm_resource_group.demo.name
#   location            = data.azurerm_resource_group.demo.location
# }

# # Create subnet
# resource "azurerm_subnet" "my_terraform_subnet" {
#   name                 = "${random_pet.prefix.id}-subnet"
#   resource_group_name  = data.azurerm_resource_group.demo.name
#   virtual_network_name = azurerm_virtual_network.my_terraform_network.name
#   address_prefixes     = ["10.0.1.0/24"]
# }

# # Create public IPs
# resource "azurerm_public_ip" "my_terraform_public_ip" {
#   name                = "${random_pet.prefix.id}-public-ip"
#   resource_group_name = data.azurerm_resource_group.demo.name
#   location            = data.azurerm_resource_group.demo.location
#   allocation_method   = "Static"
#   sku                 = "Standard"
# }

# # Create Network Security Group and rules
# resource "azurerm_network_security_group" "my_terraform_nsg" {
#   name                = "${random_pet.prefix.id}-nsg"
#   location            = data.azurerm_resource_group.demo.location
#   resource_group_name = data.azurerm_resource_group.demo.name

#   security_rule {
#     name                       = "RDP"
#     priority                   = 1000
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "*"
#     source_port_range          = "*"
#     destination_port_range     = "3389"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
#   security_rule {
#     name                       = "web"
#     priority                   = 1001
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "80"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
# }

# # Create network interface
# resource "azurerm_network_interface" "my_terraform_nic" {
#   name                = "${random_pet.prefix.id}-nic"
#   location            = data.azurerm_resource_group.demo.location
#   resource_group_name = data.azurerm_resource_group.demo.name

#   ip_configuration {
#     name                          = "my_nic_configuration"
#     subnet_id                     = azurerm_subnet.my_terraform_subnet.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip.id
#   }
# }
# # Connect the security group to the network interface
# resource "azurerm_network_interface_security_group_association" "example" {
#   network_interface_id      = azurerm_network_interface.my_terraform_nic.id
#   network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
# }


# # Create virtual machine
# resource "azurerm_windows_virtual_machine" "main" {
#   name                  = "${random_pet.prefix.prefix}-vm"
#   admin_username        = var.admin_username
#   admin_password        = var.admin_password
#   resource_group_name   = data.azurerm_resource_group.demo.name
#   location              = data.azurerm_resource_group.demo.location
#   network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]
#   size                  = "Standard_B4ms"

#   os_disk {
#     name                 = "myOsDisk"
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "MicrosoftWindowsDesktop"
#     offer     = "windows-11"
#     sku       = "win11-21h2-avd"
#     version   = "latest"
#   }
# }
# resource "azurerm_dev_test_global_vm_shutdown_schedule" "myschedule" {
#   virtual_machine_id = azurerm_windows_virtual_machine.main.id
#   location           = data.azurerm_resource_group.demo.location
#   enabled            = true

#   daily_recurrence_time = "1900"
#   timezone              = "W. Europe Standard Time"

#   notification_settings {
#     enabled         = false
#     time_in_minutes = "60"
#   }
# }

# # Storage
# resource "azurerm_storage_account" "mystorage" {
#   name                     = "winflinkstoragedemo"
#   resource_group_name      = data.azurerm_resource_group.demo.name
#   location                 = data.azurerm_resource_group.demo.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
#   is_hns_enabled           = true
# }

# resource "azurerm_storage_container" "example" {
#   name                  = "streaming-data"
#   storage_account_name  = azurerm_storage_account.mystorage.name
#   container_access_type = "container"
# }

# # Databricks
# resource "azurerm_databricks_workspace" "demo" {
#   name                = var.cc_env_name
#   resource_group_name = data.azurerm_resource_group.demo.name
#   location            = data.azurerm_resource_group.demo.location
#   sku                 = "trial"

#   tags = {
#     Environment = var.cc_env_name
#   }
# }

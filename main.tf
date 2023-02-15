# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.43.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# digital@deletoilleprooutlook.onmicrosoft.com
# Salut123!


# terraform init  ##scan tous les fichiers dans ./

# terraform apply

# terraform destroy

resource "azurerm_resource_group" "rg" {
  name     = "anhkhoal"
  location = "West Europe"
}

resource "azurerm_storage_account" "storage" {
  name                     = "storageanhkhoal"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  access_tier              = "Cool"

  tags = {
    environment = "staging"
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                        = "kvanhkhoal"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get", "Delete", "List", "Purge", "Recover", "Restore", "Set"
    ]
  }
}

resource "azurerm_key_vault_secret" "kvsecret" {
  name         = "kvsanhkhoal"
  value        = random_password.password.result
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_resource_group" "rgsakl" {
  for_each = var.rgs
  name     = each.value["name"]
  location = each.value["location"]
} 
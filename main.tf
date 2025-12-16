terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "tangerry-amr"
  location = "australiaeast"
}

resource "azurerm_managed_redis" "amr1" {
  name                = "tangerry-amr1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "australiaeast"
  sku_name            = "Balanced_B3"

  default_database {
    geo_replication_group_name = "tangerry-amr"
  }
}

resource "azurerm_managed_redis" "amr2" {
  name                = "tangerry-amr2"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "eastus2"
  sku_name            = "Balanced_B3"

  default_database {
    geo_replication_group_name = "tangerry-amr"
  }
}

resource "azurerm_managed_redis" "amr3" {
  name                = "tangerry-amr3"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "westeurope"
  sku_name            = "Balanced_B3"

  default_database {
    geo_replication_group_name = "tangerry-amr"
  }
}

resource "azurerm_managed_redis_geo_replication" "geo_replication" {
  managed_redis_id = azurerm_managed_redis.amr1.id

  linked_managed_redis_ids = [
    azurerm_managed_redis.amr2.id,
    azurerm_managed_redis.amr3.id,
  ]

  timeouts {
    create = "180m"
  }
}
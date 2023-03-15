
provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "mediawiki" {
  name     = var.name
  location = var.location
}

resource "azurerm_network_security_group" "mediawiki" {
  name                = "mediawiki-security-group"
  location            = azurerm_resource_group.mediawiki.location
  resource_group_name = azurerm_resource_group.mediawiki.name
}

resource "azurerm_virtual_network" "mediawiki" {
  name                = "mediawiki-network"
  location            = azurerm_resource_group.mediawiki.location
  resource_group_name = azurerm_resource_group.mediawiki.name
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"
    security_group = azurerm_network_security_group.mediawiki.id
  }

  tags = {
    environment = "Devlopment"
  }
}
data "azurerm_client_config" "current" {}
resource "azurerm_key_vault" "mediawiki-toughwork" {
  name                        = "mediawiki-vault"
  location                    = azurerm_resource_group.mediawiki.location
  resource_group_name         = azurerm_resource_group.mediawiki.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true
  

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

resource "azurerm_container_registry" "acr" {
  name                = "mediawikiacr"
  resource_group_name = azurerm_resource_group.mediawiki.name
  location            = azurerm_resource_group.mediawiki.location
  sku                 = "Premium"
}



resource "azurerm_kubernetes_cluster" "aks" {
  name                = "mediawiki-aks"
  location            = azurerm_resource_group.mediawiki.location
  resource_group_name = azurerm_resource_group.mediawiki.name

  dns_prefix = "mediawiki-aks"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

 
  identity {
    type = "SystemAssigned"
  }

  depends_on = [azurerm_resource_group.mediawiki]
}

resource "azurerm_role_assignment" "role_assignemt" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}

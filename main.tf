locals {
  subscription_id     = "SUB_ID"
  pe_name = "m-${var.pe_identity}-${var.pe_environment}-pe"
  pe_rg_name = "m-${var.pe_identity}-rg" 
}

provider "azurerm" {
  alias = "src"
}

data "azurerm_resource_group" "main" {
 name = var.pe_vnet_rg
} 

data "azurerm_virtual_network" "main" {
 name                = var.pe_vnet_name
 resource_group_name = data.azurerm_resource_group.main.name
}

data "azurerm_subnet" "subnet" {
 name                 = var.pe_subnet_name
 virtual_network_name = data.azurerm_virtual_network.main.name
 resource_group_name  = data.azurerm_resource_group.main.name 
}

resource "azurerm_resource_group" "rg" { 
 provider = azurerm.src 
 name = local.pe_rg_name
 location = var.location  
}

resource "azurerm_private_dns_zone" "main" {
  provider            = azurerm.src
  name                = var.dns_zone
  resource_group_name = azurerm_resource_group.rg.name  
}

resource "azurerm_private_dns_zone_virtual_network_link" "main" {
  provider              = azurerm.src
  name                  = var.vnet_link
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.main.name
  virtual_network_id    = data.azurerm_virtual_network.main.id
}

resource "azurerm_private_endpoint" "main" {
  depends_on         = [azurerm_resource_group.rg]  
  provider            = azurerm.src
  name                = local.pe_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.subnet.id

  private_service_connection {
    name                           = var.network_type
    private_connection_resource_id = var.private_connection
    is_manual_connection           = false
    subresource_names             = ["sites"]    
  } 

  private_dns_zone_group {
    name                 = var.zone_group
    private_dns_zone_ids = [azurerm_private_dns_zone.main.id]                      
  }
}

#enforce_private_link_endpoint_network_policies = true This need to be turned off to deploy pe
#enforce_private_link_service_network_policies  = true -> false

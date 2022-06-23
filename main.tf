locals {
  pe_name = "m-${var.pe_identity}-${var.pe_environment}-pe"
  pe_rg_name = "m-${var.pe_identity}-rg" 
  coreservicessubscriptionid = "" ## replace with the coreservicessubscriptionid from the .tfvars file
  spokesubscriptionid = "" ## replace with the spokesubscription id from the .tfvars file
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"  
      configuration_aliases = [azurerm.hub, azurerm.spoke]
    }    
  }
}

data "azurerm_resource_group" "main" {
 provider = azurerm.spoke
 name = var.pe_vnet_rg
} 

data "azurerm_virtual_network" "main" {
 provider            = azurerm.spoke
 name                = var.pe_vnet_name
 resource_group_name = data.azurerm_resource_group.main.name
}

data "azurerm_subnet" "subnet" {
 provider             = azurerm.spoke
 name                 = var.pe_subnet_name
 virtual_network_name = data.azurerm_virtual_network.main.name
 resource_group_name  = data.azurerm_resource_group.main.name 
}

data "azurerm_resource_group" "privateendpointrg" { 
 provider = azurerm.spoke 
 name =     var.pe_resourcegroupname
}

data "azurerm_resource_group" "dnsrg" {
  provider           = azurerm.hub
  name               = var.dns_resource_group
}

data "azurerm_private_dns_zone" "main" {
  provider            = azurerm.hub
  name                = var.dns_zone
  resource_group_name = data.azurerm_resource_group.dnsrg.name  
}

resource "azurerm_private_dns_zone_virtual_network_link" "main" {
  provider              = azurerm.hub
  name                  = var.vnet_link
  resource_group_name   = data.azurerm_resource_group.dnsrg.name
  private_dns_zone_name = data.azurerm_private_dns_zone.main.name
  virtual_network_id    = data.azurerm_virtual_network.main.id 
}

resource "azurerm_private_endpoint" "main" {
  depends_on          = [data.azurerm_resource_group.privateendpointrg]  
  provider            = azurerm.spoke
  name                = local.pe_name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.privateendpointrg.name
  subnet_id           = data.azurerm_subnet.subnet.id

  private_service_connection {
    name                           = var.network_type
    private_connection_resource_id = var.private_connection
    is_manual_connection           = false
    subresource_names              = var.subresource_names 
  } 

  private_dns_zone_group {
    name                 = var.zone_group
    private_dns_zone_ids = [data.azurerm_private_dns_zone.main.id]                      
  } 
}

#enforce_private_link_endpoint_network_policies = true  This need to be turned off to deploy pe, false to turn on.
#enforce_private_link_service_network_policies  = true -> false

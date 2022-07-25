data "azurerm_resource_group" "main" {
 provider = azurerm.spoke
 name = var.resource_group_name
} 

data "azurerm_virtual_network" "main" {
 provider            = azurerm.spoke
 name                = var.vnet_name
 resource_group_name = data.azurerm_resource_group.main.name
}

data "azurerm_network_security_group" "main" {
    provider = azurerm.spoke
    name = var.nsg_name
    resource_group_name = data.azurerm_resource_group.main.name
}

data "azurerm_resource_group" "dnsrg" {
  provider           = azurerm.hub
  name               = var.dns_resource_group
}

data "azurerm_private_dns_zone" "dns" {
  provider            = azurerm.hub
  name                = var.dns_zone
  resource_group_name = data.azurerm_resource_group.dnsrg.name  
}
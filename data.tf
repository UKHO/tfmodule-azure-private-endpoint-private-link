data "azurerm_resource_group" "main" {
 provider = azurerm.spoke
 name = var.pe_vnet_rg
} 

data "azurerm_virtual_network" "main" {
 provider            = azurerm.spoke
 name                = var.pe_vnet_name
 resource_group_name = data.azurerm_resource_group.main.name
}

data "azurerm_network_security_group" "main" {
    provider = azurerm.spoke
    name = var.nsgname
    resource_group_name = data.azurerm_resource_group.main.name
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
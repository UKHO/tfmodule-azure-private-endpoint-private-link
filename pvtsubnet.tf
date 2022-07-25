data "azurerm_subnet" "subnet" {
 provider             = azurerm.spoke
 name                 = var.pe_subnet_name
 virtual_network_name = data.azurerm_virtual_network.main.name
 resource_group_name  = data.azurerm_resource_group.main.name 
}

resource "azurerm_subnet" "spokepvtsubnet" {
  count                = length(var.subnets)
  name                 = "pvt${var.subnets[count.index].name}"
  provider             = azurerm.spoke
  resource_group_name  = data.azurerm_resource_group.main
  virtual_network_name = data.azurerm_virtual_network.main.name
  address_prefixes     = [cidrsubnet(data.azurerm_virtual_network.main.address_prefixes, var.newbits, var.subnets[count.index].number)]
  service_endpoints    = var.service_endpoints
  enforce_private_link_endpoint_network_policies = true
} 

resource "azurerm_subnet_network_security_group_association" "spokesubnetnsg" {
  provider                  = azurerm.spoke
  count                     = length(var.subnets)
  subnet_id                 = azurerm_subnet.spokesubnet[count.index].id
  network_security_group_id = data.azurerm_network_security_group.nsg.id
}
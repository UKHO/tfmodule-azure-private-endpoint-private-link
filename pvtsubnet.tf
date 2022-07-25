resource "azurerm_subnet" "spokepvtsubnet" {
  name                 = "pvt${var.subnet_name}"
  provider             = azurerm.spoke
  resource_group_name  = data.azurerm_resource_group.main
  virtual_network_name = data.azurerm_virtual_network.main.name
  address_prefixes     = [cidrsubnet(data.azurerm_virtual_network.main.address_prefixes, var.subnet_newbit, var.subnet_number)]
  service_endpoints    = var.service_endpoints
  enforce_private_link_endpoint_network_policies = true
} 

resource "azurerm_subnet_network_security_group_association" "spokesubnetnsg" {
  provider                  = azurerm.spoke
  subnet_id                 = azurerm_subnet.spokepvtsubnet.id
  network_security_group_id = data.azurerm_network_security_group.nsg.id
}
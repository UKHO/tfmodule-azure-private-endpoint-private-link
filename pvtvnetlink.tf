resource "azurerm_private_dns_zone_virtual_network_link" "main" {
  provider              = azurerm.hub
  name                  = var.vnet_link
  resource_group_name   = data.azurerm_resource_group.dnsrg.name
  private_dns_zone_name = data.azurerm_private_dns_zone.dns.name
  virtual_network_id    = data.azurerm_virtual_network.main.id
}
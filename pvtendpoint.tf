resource "azurerm_private_endpoint" "main" {
  provider            = azurerm.spoke
  name                = local.private_endpoint_name
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.spokepvtsubnet.id

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
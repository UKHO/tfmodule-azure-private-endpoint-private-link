resource "azurerm_private_endpoint" "main" {
  depends_on          = [azurerm_resource_group.rg]  
  provider            = azurerm.spoke
  name                = local.pe_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
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
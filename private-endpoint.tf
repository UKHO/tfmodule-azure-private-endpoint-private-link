locals {
  pe_rg_name = var.pe_resource_group
}

resource "azurerm_private_endpoint" "main" {
  provider            = azurerm.spoke
  name                = "m-${var.pe_identity[count.index]}-${var.pe_environment}-pe"
  count               = length(var.pe_identity)
  location            = var.pe_resource_group_locations[count.index]
  resource_group_name = var.pe_resource_group[count.index]
  subnet_id           = data.azurerm_subnet.subnet.id
  lifecycle { 
    ignore_changes = [
      tags,
      private_dns_zone_group,
      private_service_connection,
      subnet_id
    ] 
  }

  private_service_connection {
    name                           = var.network_type
    private_connection_resource_id = var.private_connection[count.index]
    is_manual_connection           = false
    subresource_names              = var.subresource_names 
  } 

  private_dns_zone_group {
    name                 = var.zone_group
    private_dns_zone_ids = [data.azurerm_private_dns_zone.main.id]                      
  } 
}
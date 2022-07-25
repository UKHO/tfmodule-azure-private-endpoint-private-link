resource "azurerm_resource_group" "rg" { 
 provider = azurerm.spoke 
 name = local.pe_rg_name
 location = var.location  
}
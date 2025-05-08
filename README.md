# Terraform Module: for Azure Private Endpoints

## Required Resources

- `Resource Group` exists or is created external to the module.
- `Provider` must be created external to the module.
- `Grant terraform-service account permission to create records in the respective private dns zones.
- **This module does not create the private dns zone vnet link resource** (azurerm_private_dns_zone_virtual_network_link), that must be done separately in the the terraform where you implement this module or or as part of the spoke setup.

## Usage

## Remember to disable network policies to add PE.
    #enforce_private_link_endpoint_network_policies = true  This need to be turned off to deploy pe, false to turn on.
    #enforce_private_link_service_network_policies  = true -> false

## IMPORTANT - If you require DNS records and vnet links to be created in the private dns zones make sure the terraform-SOMETHING account has "read" over core services resource group (business-rg or engineering-rg) and "contributor" on the private dns zone you require.

az network vnet subnet update --name SUBNETNAME-subnet --resource-group NAME-RG --vnet-name NAME-vnet --disable-private-endpoint-network-policies true
False will re-enable

```terraform
# Private Endpoint

## Creating Private Enpoints

## Usage Vars

variable "dns_zone" {
    description = "alias to create private dns zone - be aware this is dependant on the endpoint"
    default = "privatelink.azurewebsites.net"
}

variable "location" {
    default = "uksouth"
}

variable "network_type" {
  description = "type of connection"
  default = "network"
}

variable "private_connection" {
    description = "endpoint resource id (for example [/subscriptions/SUBID/resourceGroups/RGNAME/providers/Microsoft.Web/sites/APP_SERVICE_NAME])"
    type        = list(string)
    default = [""]
}

variable "zone_group" {
    description = "private dns zone group"
    default = ""   
}

variable "pe_identity" {
    description = "identity that will create all the private endpoint resources required"
    default = ""
}

variable "pe_environment" {
    description = "environment for private endpoint (for example dev | prd | qa | pre)"
    default = ""
}

variable "pe_vnet_rg" {
    description = "this is the rg for the spoke vnet"
    default = ""
}

variable "pe_vnet_name" {
    description = "vnet name for the private endpoint"
    default = ""
}

variable "pe_subnet_name" {
    description = "subnet name that the private endpoint will associate"
    default = ""
}

variable "pe_resource_group_locations" {
    description = "List of resource group names"
    type        = list(string)
    default     = [""]
}
variable "pe_resource_group" {
    description = "List of resource group names"
    type        = list(string)
    default     = [""]
}

variable "dns_resource_group" {
    description = "dns resource group name, please change default to either business-rg or engineering-rg" 
    default = ""
}

variable "subresource_names" {
    description = "array of sub resources, if you require additional subresources please define"
    default = ["sites"]
}


module "private_endpoint_link" {
  source              = "github.com/UKHO/tfmodule-azure-private-endpoint-private-link?ref=0.6.1"
  providers = {
    azurerm.src   = azurerm.alias
    azurerm.src   = azurerm.alias
  }
  private_connection  = [local.private_connection]
  zone_group          = local.zone_group 
  pe_identity         = [local.pe_identity] 
  pe_environment      = local.pe_environment 
  pe_vnet_rg          = local.pe_vnet_rg  
  pe_vnet_name        = local.pe_vnet_name
  pe_subnet_name      = local.pe_subnet_name
  dns_resource_group  = local.dns_resource_group
  pe_resource_group  = [
  azurerm_resource_group.example1.name,
  azurerm_resource_group.example2.name
]
pe_resource_group_locations = [
    azurerm_resource_group.example1.location,
    azurerm_resource_group.example2.location
  ]
}

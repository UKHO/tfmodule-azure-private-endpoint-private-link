# Terraform Module: for Azure Private Endpoints

##

## Required Resources

- `Resource Group` exists or is created external to the module.
- `Provider` must be created external to the module.
- `Grant terraform-service account permission to create records in the respective private dns zones.

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

variable "vnet_link" {
    description = "alias of the virtual network link"
    default = ""  
}

variable "location" {
    default = "uksouth"
}

variable "network_type" {
  description = "type of connection"
  default = "network"
}

variable "private_connection" {
    description = "endpoint resource id"	 
    default = "/subscriptions/SUBID/resourceGroups/RGNAME/providers/Microsoft.Web/sites/APP_SERVICE_NAME" 
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
    description = "environment for private endpoint"
    default = "dev | prd | qa | pre"
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
    description = "subname that the private endpoint will associate"
    default = ""
}

variable "pe_resource_group" {
  description = "value"
  type = object({
    name = string
    location = string
  })
}

variable "dns_resource_group" {
    description = "dns resource group"
    default="domain-rg"
}

variable "subresource_names" {
    description = "array of sub resources"
    default = ["sites"]
}


module "privatendpoint" {
  source                        = "github.com/ukho/tfmodule-azure-private-endpoint?ref=0.4.0-beta.1"
  providers = {
    azurerm.src = azurerm.alias
    azurerm.src = azurerm.alias
  }
  
  dns_zone                        = "${var.dns_zone}"
  vnet_link                       = "${var.vnet_link}"
  location                        = "${var.location}"
  network_type                    = "${var.network_type}"
  private_connection              = "${var.private_connection}"
  zone_group                      = "${var.zone_group}"
  pe_identity                     = "${var.pe_identity}"
  pe_resource_group               =  azurerm_resource_group.rg
  pe_environment                  = "${var.pe_environment}"
  pe_vnet_rg                      = "${var.pe_vnet_rg}"
  pe_vnet_name                    = "${var.pe_vnet_name}"
  pe_subnet_name                  = "${var.pe_subnet_name}"
  dns_resource_group              = "some-rg"
  subresource_names               = ["sites"]
 }

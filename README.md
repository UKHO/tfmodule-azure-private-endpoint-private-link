# Terraform Module: for Azure Private Endpoints

## Please Keep Private Endpoint configuration separate with its own TFstae file. 

## Required Resources

- `Resource Group` exists or is created external to the module.
- `Provider` must be created external to the module.

## Usage

## Remember to disable network policies to add PE.

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
    default = "dev | prd | qa"
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

variable "dns_resource_group" {
    description = "dns resource group"
    default="domain-rg"
}

variable "subresource_names" {
    description = "array of sub resources"
    default = ["sites"]
}


module "privatendpoint" {
  source                        = "github.com/ukho/tfmodule-azure-private-endpoint?ref=0.2.1"
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
  pe_environment                  = "${var.pe_environment}"
  pe_vnet_rg                      = "${var.pe_vnet_rg}"
  pe_vnet_name                    = "${var.pe_vnet_name}"
  pe_subnet_name                  = "${var.pe_subnet_name}"
  dns_resource_group              = "some-rg"
  subresource_names               = ["sites"]
 }

# Terraform Module: for Azure Private Endpoints

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
}

variable "private_endpoint_name" {
    description = "name that will be used to create the private endpoint resources required"
}

variable "environment" {
    description = "environment for private endpoint"
    default = "dev | prd | qa"
}

variable "resource_group_name" {
    description = "this is the rg for the spoke vnet"
    default = "m-spokeconfig-rg"
}

variable "vnet_name" {
    description = "vnet name for the private endpoint"
}

variable "vnet_address_prefixes" {
    description = "vnet address prefix"
    default = ["0.0.0.0/29"]
}

variable "subnet_name" {
    description = "subnet name for private endpoint"
}

variable "subnet_number" {
    description = "subnet number for private endpoint"
    default = 0
}

variable "subnet_newbit" {
    description = "subnet newbit for private endpoint"
    default = 3
}

variable "nsg_name" {
  description = "nsg to use on subnet"
}

variable "dns_resource_group_name" {
    description = "dns resource group"
}

variable "subresource_names" {
    description = "array of sub resources"
    default = ["sites"]
}

module "privatendpoint" {
  source                        = "github.com/ukho/tfmodule-azure-private-endpoint?ref=0.x.x"
  providers = {
    azurerm.hub = azurerm.hub
    azurerm.spoke = azurerm.spokename
  }
  
  dns_zone                        = "engineering or business"
  vnet_link                       = "name for vnet link"
  location                        = "${var.location}"
  network_type                    = "${var.network_type}"
  private_connection              = "${var.private_connection}"
  zone_group                      = "${var.zone_group}"
  private_endpoint_name           = "${var.private_endpoint_name}"
  environment                     = "${var.environment}"
  resource_group_name             = "${var.resource_group_name}"
  vnet_name                       = "${var.vnet_name}"
  subnet_name                     = "subnet_name"
  subnet_number                   = "Position on subnet range"
  subnet_newbit                   = "bit to add to address prefix"
  nsg_name                        = "name for nsg"
  dns_resource_group_name         = "${var.vnet_address_prefixes}"
  subresource_names               = ["sites"]
 }

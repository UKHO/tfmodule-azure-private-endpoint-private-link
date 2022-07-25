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





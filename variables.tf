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

variable "pe_resource_group" {
  description = "value"
  type = object({
    name = string
    location = string
  })
}

variable "dns_resource_group" {
    description = "dns resource group name, please change domain-rg to either business-rg or engineering-rg" 
    default="domain-rg"
}

variable "subresource_names" {
    description = "array of sub resources, if you require additional subresources please define"
    default = ["staticSites"]
}


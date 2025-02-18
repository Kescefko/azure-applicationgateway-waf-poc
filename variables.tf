variable "subscription_id" {
  default = "1c2b3b73-e5d4-4ab6-9ac4-c807cb39e0ef"
  sensitive = true
}

variable "resource_group_name" {
  default = "rg-gyorgy-shared-dev"
}

variable "location" {
  default = "Switzerland North"
}

variable "vnet_name" {
  default = "vnet"
}

variable "subnet_appgw_name" {
  default = "snet-appgw"
}

variable "subnet_web_name" {
  default = "snet-web"
}

variable "vm_admin_username" {
  default = "adM59448N"
}

variable "vm_admin_password" {
  default = "jfeoi456=_heo"
}
# resource group common vars
variable "name" {
  type        = string
  description = "Resource group name"
  default     = "mediawiki-rg"
}
variable "location" {
  type        = string
  description = "The Azure Region"
  default     = "West Europe"
}

#######################################################################
## Initialise variables
#######################################################################
variable "location" {
  description = "Region"
  type        = string
  default     = "UK West"
}
variable "prefix" {
  description = "Default Naming Prefix"
  type        = string
  default     = "orbital"
}
variable "tags" {
  type        = map(any)
  description = "Tags to be attached to azure resources"
  default = {
    "deployed" = "terraform"
    "env"      = "dev"
  }
}
variable "username" {
  description = "Username for Virtual Machines"
  type        = string
  default     = "adminuser"
}
variable "password" {
  description = "Virtual Machine password, must meet Azure complexity requirements"
  type        = string
  default     = "Pa55w0rd123!"
}
variable "vmsize" {
  description = "Size of the VMs"
  default     = "Standard_D4s_v5"
}

variable "aqua_tools_sa" {
  description = "Variable pulled from GitHub Secret that sets name of Storage Account where AQUA apps are"
}
#COMMON ########################################################################
variable "resource_group_name" {
  description = "(Required) resource Group name"
  type        = string
}
variable "location" {
  description = "(Required) Location"
  type        = string
}

variable "tags" {
  type = map(string)
}

#SQL SERVER ####################################################################
variable "sql_server_name" {
  type = string
}
variable "admin_login_username" {
  type    = string
  default = "MDRXAdmin"
}
variable "admin_login_password" {
  type    = string
  default = "Allscripts#1"
}
variable "sql_database_name" {
  type    = string
  default = "sqldatabase"
}


variable "secret_name" {
  description = "Secret Name"
  type        = string
}

variable "keyvault_name" {
  description = "(Required) Name for Key-Vault"
  type        = string
}

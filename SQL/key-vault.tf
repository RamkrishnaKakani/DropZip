data "azurerm_client_config" "current" {}
data "azurerm_mssql_database" "database" {
    name               		  = var.sql_database_name
    server_id           		= azurerm_mssql_server.sql-server.id
}

resource "azurerm_key_vault" "keyvault" {
  name                       = var.keyvault_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_enabled        = true
  soft_delete_retention_days = 7
  purge_protection_enabled   = true
  sku_name                   = "standard"

  tags                       = var.tags
}

resource "azurerm_key_vault_secret" "secret" {
    name                      = var.secret_name
    value                     = "Server=tcp:${azurerm_mssql_server.sql-server.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.sql-database.name};Persist Security Info=False;User ID=${azurerm_mssql_server.sql-server.administrator_login};Password=${azurerm_mssql_server.sql-server.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
    key_vault_id              = azurerm_key_vault.keyvault.id
} 

#database_connection_string    = "Server=tcp:${module.database.name}.database.windows.net,1433;Initial Catalog=${module.database.database_name};Persist Security Info=False;User ID=${var.database_user};Password=${var.database_password};MultipleActiveResultSets=True;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
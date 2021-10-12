resource "azurerm_mssql_server" "sql-server" {
  name                         	= var.sql_server_name
  resource_group_name          	= var.resource_group_name
  location                     	= var.location
  version                      	= "12.0"
  administrator_login          	= var.admin_login_username
  administrator_login_password 	= var.admin_login_password
  
  tags 			                  	= var.tags
}

resource "azurerm_mssql_database" "sql-database" {
  name               		  = var.sql_database_name
  server_id           		= azurerm_mssql_server.sql-server.id
  collation           		= "SQL_Latin1_General_CP1_CI_AS"
  license_type        		= "LicenseIncluded"
  max_size_gb         		= 1
  read_scale          		= false    
  sku_name            		= "Basic"
  zone_redundant      		= false

  tags 				            =  var.tags
}

resource "azurerm_mssql_firewall_rule" "azure-firewall" {
  name                        = "AzureServiceRule"
  server_id                   = azurerm_mssql_server.sql-server.id
  start_ip_address            = "0.0.0.0"
  end_ip_address              = "0.0.0.0"
}


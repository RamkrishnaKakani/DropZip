resource_group_name = "demo-rg"
location= "eastus"

sql_server_name      = "demopohglobalserver"
sql_database_name    = "demoPOHTenancyDB"
admin_login_username = "mdrxadmin"
admin_login_password = "Demo@123"

tags = {
  "created-by" = "Ramkrishna Kakani"
}

keyvault_name       = "DemoVaulthotoaisa"
secret_name         = "DBConnectionString"
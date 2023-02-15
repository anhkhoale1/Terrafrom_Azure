resource "azurerm_mssql_server" "mssql" {
  name                         = "mssqlserveranhkhoal"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = "anhkhoa"
  administrator_login_password = random_password.password.result
  minimum_tls_version          = "1.2"

  # azuread_administrator {
  #   login_username = "AzureAD Admin"
  #   object_id      = "00000000-0000-0000-0000-000000000000"
  # }
}

resource "azurerm_mssql_database" "mysqldb" {
  name                        = "mysqldbanhkhoal"
  server_id                   = azurerm_mssql_server.mssql.id
  max_size_gb                 = 4
  read_scale                  = false
  sku_name                    = "GP_S_Gen5_2"
  zone_redundant              = true
  min_capacity                = 1
  auto_pause_delay_in_minutes = 60
}

resource "random_password" "password" {
  length           = 16
  special          = true
  min_numeric      = 1
  min_lower        = 1
  min_upper        = 1
  min_special      = 1
  override_special = "!"
}

resource "azurerm_resource_group" "multipleresource" {
  count    = 10
  name     = "anhkhoalmultipleresource-${count.index}"
  location = "West Europe"
}

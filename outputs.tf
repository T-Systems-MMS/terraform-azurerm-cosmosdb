output "cosmosdb_account" {
  description = "azurerm_cosmosdb_account results"
  value = {
    for cosmosdb_account in keys(azurerm_cosmosdb_account.cosmosdb_account) :
    cosmosdb_account => {
      id   = azurerm_cosmosdb_account.cosmosdb_account[cosmosdb_account].id
      name = azurerm_cosmosdb_account.cosmosdb_account[cosmosdb_account].name
      endpoint = azurerm_cosmosdb_account.cosmosdb_account[cosmosdb_account].endpoint
      read_endpoints  = azurerm_cosmosdb_account.cosmosdb_account[cosmosdb_account].read_endpoints
      write_endpoints  = azurerm_cosmosdb_account.cosmosdb_account[cosmosdb_account].write_endpoints
      connection_strings  = azurerm_cosmosdb_account.cosmosdb_account[cosmosdb_account].connection_strings
    }
  }
}

output "cosmosdb_mongo_database" {
  description = "azurerm_cosmosdb_mongo_database results"
  value = {
    for cosmosdb_mongo_database in keys(azurerm_cosmosdb_mongo_database.cosmosdb_mongo_database) :
    cosmosdb_mongo_database => {
      id   = azurerm_cosmosdb_mongo_database.cosmosdb_mongo_database[cosmosdb_mongo_database].id
      name = azurerm_cosmosdb_mongo_database.cosmosdb_mongo_database[cosmosdb_mongo_database].name
    }
  }
}

output "cosmosdb_account" {
  description = "azurerm_cosmosdb_account results"
  value = {
    for cosmosdb_account in keys(azurerm_cosmosdb_account.cosmosdb_account) :
    cosmosdb_account => {
      id   = azurerm_cosmosdb_account.cosmosdb_account[cosmosdb_account].id
      name = azurerm_cosmosdb_account.cosmosdb_account[cosmosdb_account].name
    }
  }
}

module "cosmosdb" {
  source = "registry.terraform.io/T-Systems-MMS/cosmosdb/azurerm"
  cosmosdb_account = {
    service-cdb = {
      location                   = "westeurope"
      resource_group_name        = "service-rg"
      mongo_server_version       = "4.2"
      virtual_network_rule = {
        id = module.network.subnet.aks.id
      }
      backup = {
        type = "Continuous"
      }
      tags = {
        service = "service_name"
      }
    }
  }
  cosmosdb_mongo_database = {
    service = {
      resource_group_name        = "service-rg"
      account_name        = module.cosmosdb.cosmosdb_account["service-cdb"].name
    }
  }
}

module "cosmosdb" {
  source = "registry.terraform.io/T-Systems-MMS/cosmosdb/azurerm"
  cosmosdb_account = {
    service-cdb = {
      location                   = "westeurope"
      resource_group_name        = "service-rg"
      kind                       = "MongoDB"
      enable_free_tier           = true
      analytical_storage_enabled = false
      key_vault_key_id           = ""
      mongo_server_version       = "4.0"
      consistency_policy = {
        consistency_level = "Strong"
      }
      geo_location = {
        prefix            = "service-euw-cdb"
        location          = "westeurope"
        failover_priority = 0
      }
      virtual_network_rule = {
        id = module.network.subnet.aks.id
      }
      analytical_storage = {
        /** see https://docs.microsoft.com/de-de/azure/cosmos-db/configure-synapse-link#azure-cli
        * For MongoDB API accounts, always use -AnalyticalStorageSchemaType FullFidelity
        */
        schema_type = "FullFidelity"
      }
      capacity = {}
      capabilities = {
        name = "EnableMongo"
      }
      backup = {
        type = "Continuous"
      }
      tags = {
        service = "service_name"
      }
    }
  }
}

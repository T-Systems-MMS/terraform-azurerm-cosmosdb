variable "cosmosdb_account" {
  type        = any
  default     = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}
variable "cosmosdb_mongo_collection" {
  type        = any
  default     = {}
  description = "resource definition, default settings are defined within locals and merged with var settings"
}

locals {
  default = {
    # resource definition
    cosmosdb_account = {
      name                                  = ""
      offer_type                            = "Standard"
      default_identity_type                 = "FirstPartyIdentity"
      kind                                  = "GlobalDocumentDB"
      ip_range_filter                       = ""
      enable_free_tier                      = false
      analytical_storage_enabled            = false
      enable_automatic_failover             = false
      public_network_access_enabled         = false
      is_virtual_network_filter_enabled     = true
      enable_multiple_write_locations       = false
      access_key_metadata_writes_enabled    = true
      network_acl_bypass_for_azure_services = false
      network_acl_bypass_ids                = []
      local_authentication_disabled         = false
      consistency_policy = {
        consistency_level = "Strong"
      }
      geo_location = {
        zone_redundant = false
      }
      virtual_network_rule = {
        ignore_missing_vnet_service_endpoint = false
      }
      analytical_storage = {}
      capacity = {
        total_throughput_limit = "-1"
      }
      capabilities = {}
      backup = {
        type = "Periodic"
      }
      tags = {}
    }
    cosmosdb_mongo_collection = {
      name                   = ""
      default_ttl_seconds    = 0
      analytical_storage_ttl = 0
      autoscale_settings = {
        max_throughput = "4000"
      }
      index = {
        unique = false
      }
    }
  }

  # compare and merge custom and default values
  cosmosdb_account_values = {
    for cosmosdb_account in keys(var.cosmosdb_account) :
    cosmosdb_account => merge(local.default.cosmosdb_account, var.cosmosdb_account[cosmosdb_account])
  }
  cosmosdb_mongo_collection_values = {
    for cosmosdb_mongo_collection in keys(var.cosmosdb_mongo_collection) :
    cosmosdb_mongo_collection => merge(local.default.cosmosdb_mongo_collection, var.cosmosdb_mongo_collection[cosmosdb_mongo_collection])
  }
  # merge all custom and default values
  cosmosdb_account = {
    for cosmosdb_account in keys(var.cosmosdb_account) :
    cosmosdb_account => merge(
      local.cosmosdb_account_values[cosmosdb_account],
      {
        for config in ["consistency_policy", "geo_location", "virtual_network_rule", "analytical_storage", "capacity", "capabilities", "backup"] :
        config => merge(local.default.cosmosdb_account[config], local.cosmosdb_account_values[cosmosdb_account][config])
      }
    )
  }
  cosmosdb_mongo_collection = {
    for cosmosdb_mongo_collection in keys(var.cosmosdb_mongo_collection) :
    cosmosdb_mongo_collection => merge(
      local.cosmosdb_mongo_collection_values[cosmosdb_mongo_collection],
      {
        for config in ["autoscale_settings", "index"] :
        config => merge(local.default.cosmosdb_mongo_collection[config], local.cosmosdb_mongo_collection_values[cosmosdb_mongo_collection][config])
      }
    )
  }
}

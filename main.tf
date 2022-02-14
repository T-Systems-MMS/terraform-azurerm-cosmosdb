/**
 * # cosmosdb
 *
 * This module manages Azure CosmosDB.
 *
*/

resource "azurerm_cosmosdb_account" "cosmosdb_account" {
  for_each = var.cosmosdb_account

  name                = local.cosmosdb_account[each.key].name == "" ? each.key : local.cosmosdb_account[each.key].name
  resource_group_name = local.cosmosdb_account[each.key].resource_group_name
  location            = local.cosmosdb_account[each.key].location

  offer_type                            = local.cosmosdb_account[each.key].offer_type
  default_identity_type                 = local.cosmosdb_account[each.key].default_identity_type
  kind                                  = local.cosmosdb_account[each.key].kind
  ip_range_filter                       = local.cosmosdb_account[each.key].ip_range_filter
  enable_free_tier                      = local.cosmosdb_account[each.key].enable_free_tier
  analytical_storage_enabled            = local.cosmosdb_account[each.key].analytical_storage_enabled
  enable_automatic_failover             = local.cosmosdb_account[each.key].enable_automatic_failover
  public_network_access_enabled         = local.cosmosdb_account[each.key].public_network_access_enabled
  is_virtual_network_filter_enabled     = local.cosmosdb_account[each.key].is_virtual_network_filter_enabled
  enable_multiple_write_locations       = local.cosmosdb_account[each.key].enable_multiple_write_locations
  access_key_metadata_writes_enabled    = local.cosmosdb_account[each.key].access_key_metadata_writes_enabled
  mongo_server_version                  = local.cosmosdb_account[each.key].mongo_server_version
  network_acl_bypass_for_azure_services = local.cosmosdb_account[each.key].network_acl_bypass_for_azure_services
  network_acl_bypass_ids                = local.cosmosdb_account[each.key].network_acl_bypass_ids
  local_authentication_disabled         = local.cosmosdb_account[each.key].local_authentication_disabled

  dynamic "consistency_policy" {
    for_each = local.cosmosdb_account[each.key].consistency_policy.consistency_level == "BoundedStaleness" ? [1] : []
    content {
      consistency_level       = local.cosmosdb_account[each.key].consistency_policy.consistency_level
      max_interval_in_seconds = local.cosmosdb_account[each.key].consistency_policy.max_interval_in_seconds
      max_staleness_prefix    = local.cosmosdb_account[each.key].consistency_policy.max_staleness_prefix
    }
  }
  dynamic "consistency_policy" {
    for_each = local.cosmosdb_account[each.key].consistency_policy.consistency_level != "BoundedStaleness" ? [1] : []
    content {
      consistency_level = local.cosmosdb_account[each.key].consistency_policy.consistency_level
    }
  }

  geo_location {
    prefix            = local.cosmosdb_account[each.key].geo_location.prefix
    location          = local.cosmosdb_account[each.key].geo_location.location
    failover_priority = local.cosmosdb_account[each.key].geo_location.failover_priority
    zone_redundant    = local.cosmosdb_account[each.key].geo_location.zone_redundant
  }

  virtual_network_rule {
    id                                   = local.cosmosdb_account[each.key].virtual_network_rule.id
    ignore_missing_vnet_service_endpoint = local.cosmosdb_account[each.key].virtual_network_rule.ignore_missing_vnet_service_endpoint
  }

  dynamic "analytical_storage" {
    for_each = local.cosmosdb_account[each.key].analytical_storage_enabled == true ? [1] : []
    content {
      schema_type = local.cosmosdb_account_config[each.key].analytical_storage.schema_type
    }
  }

  capacity {
    total_throughput_limit = local.cosmosdb_account[each.key].capacity.total_throughput_limit
  }

  capabilities {
    name = local.cosmosdb_account[each.key].capabilities.name
  }

  dynamic "backup" {
    for_each = local.cosmosdb_account[each.key].backup.type == "Periodic" ? [1] : []
    content {
      type                = local.cosmosdb_account[each.key].backup.type
      interval_in_minutes = local.cosmosdb_account[each.key].backup.interval_in_minutes
      retention_in_hours  = local.cosmosdb_account[each.key].backup.retention_in_hours
      storage_redundancy  = local.cosmosdb_account[each.key].backup.storage_redundancy
    }
  }
  dynamic "backup" {
    for_each = local.cosmosdb_account[each.key].backup.type == "Continuous" ? [1] : []
    content {
      type = local.cosmosdb_account[each.key].backup.type
    }
  }

  // cors_rule {}
  // identity {}
  // restore {}

  tags = local.cosmosdb_account[each.key].tags
}

resource "azurerm_cosmosdb_mongo_collection" "cosmosdb_mongo_collection" {
  for_each = var.cosmosdb_mongo_collection

  name                   = local.cosmosdb_mongo_collection[each.key].name == "" ? each.key : local.cosmosdb_mongo_collection[each.key].name
  resource_group_name    = local.cosmosdb_mongo_collection[each.key].resource_group_name
  account_name           = local.cosmosdb_mongo_collection[each.key].account_name
  database_name          = local.cosmosdb_mongo_collection[each.key].database_name
  default_ttl_seconds    = local.cosmosdb_mongo_collection[each.key].default_ttl_seconds
  shard_key              = local.cosmosdb_mongo_collection[each.key].shard_key
  analytical_storage_ttl = local.cosmosdb_mongo_collection[each.key].analytical_storage_ttl

  dynamic "autoscale_settings" {
    for_each = local.cosmosdb_mongo_collection[each.key].autoscale_settings
    content {
      max_throughput = local.cosmosdb_mongo_collection[each.key].autoscale_settings.max_throughput
    }
  }

  dynamic "index" {
    for_each = local.cosmosdb_mongo_collection[each.key].index
    content {
      keys   = local.cosmosdb_mongo_collection[each.key].index.keys
      unique = local.cosmosdb_mongo_collection[each.key].index.unique
    }
  }
}

locals {
    resource_group_name = lower(replace(var.resource_group_name, " ", "-"))
    formatted_environment_tags = { for k, v in var.environment_tags : k => lower(replace(v, " ", "-")) }
    merged_tags = merge(var.default_tags, var.environment_tags)
    #3. Use of local variable and functions - replace(), lower() and substr()
    formatted_storage_account_name = substr(lower(replace(var.storage_account_name, "/[^a-z0-9]/ ", "")),0, 23)
    #4. Use split and join functions
    port_format_oneliner = join("-", formatlist("port-%s", split(",", var.port_list)))
    #5. use lookup and default values
    default_config = {
        instance_size = "Standard_B2s" # Your desired fallback size
        redundancy    = "Low"
  }
    vm_size = lookup(var.environments, "dev", local.default_config).instance_size
}


resource "azure_resource_group" "az-rg-sandbox-01" {
#1. Use of local variable and functions - replace() and lower()
  name     = "$(local.resource_group_name)" #replace with your resource group name
  location = "westus"
#2. Use of map variable and merge function
  tags     = local.merged_tags
}

output "merged_tags" {
    value = local.merged_tags
}

resource "azurerm_storage_account" "az-sa-sandbox-01" {
  name                     = local.formatted_storage_account_name #must be globally unique
  resource_group_name      = azure_resource_group.az-rg-sandbox-01.name #implicit dependency
  location                 = azure_resource_group.az-rg-sandbox-01.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = local.merged_tags
}

output "formatted_storage_account_name" {
  value = local.formatted_storage_account_name
}

output "port_format_split_join" {
  value = local.port_format_oneliner
}

output "vm_size" {
  value = local.vm_size
}
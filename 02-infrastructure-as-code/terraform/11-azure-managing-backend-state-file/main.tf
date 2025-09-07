resource "random_string" "storage_suffix" {
  length  = 8
  special = false
  upper   = false
  numeric = true
  lower   = true
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "${random_string.storage_suffix.result}tfstate"
  resource_group_name      = "1-d367967a-playground-sandbox"
  location                 = "eastus"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
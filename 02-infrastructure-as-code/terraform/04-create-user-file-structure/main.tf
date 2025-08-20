resource "random_password" "user_password" {
  length  = 12
  min_upper = 1
  min_numeric = 1
  min_special = 1
  special = true
}

resource "azuread_user" "user" {
  user_principal_name = "${var.username}@${var.domain}"
  display_name        = var.display_name
  password            = random_password.user_password.result
  force_password_change = true

  depends_on = [azurerm_resource_group.rg]
}
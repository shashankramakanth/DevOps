data "azuread_domains" "aad_domain" {
  only_initial = true
}

locals {
  domain_name = data.azuread_domains.aad_domain.domains[0].domain_name
  users      = csvdecode(file("users.csv"))

}


resource "azuread_user" "users" {
    for_each = {for user in local.users : "${user.first_name}.${user.last_name}" => user}
    user_principal_name = format("%s%s@%s",
  substr(each.value.first_name,0,1),
  lower(each.value.last_name),
  local.domain_name)


    password = format("%s%s%s!",
    each.value.first_name,
    substr(each.value.last_name,0,1),
    "123" )

    display_name = "${each.value.first_name} ${each.value.last_name}"
    force_password_change = true
    department = each.value.department
    job_title = each.value.job_title

}

resource "azuread_group" "job_title_groups" {
    for_each = { for user in local.users : user.job_title => user.job_title }
    display_name = each.key
    security_enabled = true
    types = ["Unified"]
}

resource "azuread_group_member" "add_users"{
    for_each = { for user in local.users : "${user.first_name}.${user.last_name}_${user.job_title}" => user }
    member_object_id = azuread_user.users["${each.value.first_name}.${each.value.last_name}"].object_id
    group_object_id = azuread_group.job_title_groups[each.value.job_title].id
}

output "domain_name" {
  value = local.domain_name
}

output "usernames"{
    value = [for user in local.users: "${user.first_name}.${user.last_name}"]
}
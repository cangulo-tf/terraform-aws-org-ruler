locals {
  accounts = {
    for account_name, account in var.accounts : account_name => {
      name              = account.name
      email             = account.email
      role_name         = "OrganizationAccountAccessRole" # default value
      close_on_deletion = true
    }
  }
}

resource "aws_organizations_account" "this" {
  for_each = local.accounts

  name  = each.value.name
  email = each.value.email
  # role_name         = each.value.role_name
  close_on_deletion = each.value.close_on_deletion
}

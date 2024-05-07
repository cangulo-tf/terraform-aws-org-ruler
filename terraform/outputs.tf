output "accounts" {
  value = {
    for k, v in local.accounts : k => {
      name       = v.name
      account_id = aws_organizations_account.this[k].id
      status     = aws_organizations_account.this[k].status
    }
  }
}

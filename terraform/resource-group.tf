locals {
  resource_groups = {
    main = {
      name        = local.service_name
      description = "resources for the service ${local.service_name}"
      query = {
        "ResourceTypeFilters" : [
          "AWS::AllSupported"
        ],
        "TagFilters" : [
          {
            "Key" : "Service",
            "Values" : ["${local.tags.Service}"]
          },
          {
            "Key" : "IacRepo",
            "Values" : ["${local.tags.IacRepo}"]
          }
        ]
      }
    }
  }
}

resource "aws_resourcegroups_group" "main" {
  for_each = local.resource_groups

  name        = each.value.name
  description = each.value.description
  resource_query {
    query = jsonencode(each.value.query)
  }
}

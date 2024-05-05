locals {
  tags = {
    IacRepo = "https://github.com/cangulo-tf/terraform-aws-org-ruler"
    Service = local.service_name
  }
}

provider "aws" {
  default_tags {
    tags = local.tags
  }
}

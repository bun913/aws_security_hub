terraform {
  required_version = "~> 1.1.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.8.0"
    }
  }
}

data "aws_caller_identity" "current" {}

locals {
  default_prefix = var.tags.Project
  account_id     = data.aws_caller_identity.current.account_id
}

/*
  CloudTrailの有効化
*/

module "cloudtrail" {
  source = "./modules/cloudtrail/"

  prefix = local.default_prefix
  region = var.region
}

module "notification" {
  source     = "./modules/notification/"
  account_id = local.account_id

  prefix = local.default_prefix
}

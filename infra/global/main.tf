terraform {
  required_version = "~> 1.1.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.8.0"
    }
  }
}

locals {
  default_prefix = var.tags.Project
}

/*
  CloudTrailの有効化
*/

module "cloudtrail" {
  source = "./modules/cloudtrail/"

  prefix = local.default_prefix
  region = var.region
}

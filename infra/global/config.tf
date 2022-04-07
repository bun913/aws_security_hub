/* ConfigのIAMロール作成 */
resource "aws_iam_role" "config" {
  name = "${local.default_prefix}-config-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": "",
      "Condition": {
        "StringEquals": {
          "AWS:SourceAccount": "${local.account_id}"
        }
      }
    }
  ]
}
POLICY
}

# 公式に従って管理ポリシーを利用
# https://docs.aws.amazon.com/ja_jp/config/latest/developerguide/iamrole-permissions.html#troubleshooting-recording-s3-bucket-policy
data "aws_iam_policy" "config" {
  name = "AWS_ConfigRole"
}

resource "aws_iam_role_policy_attachment" "config" {
  role       = aws_iam_role.config.name
  policy_arn = data.aws_iam_policy.config.arn
}

/* データを集めるS3バケットを作成 */

resource "aws_s3_bucket" "config" {
  bucket = "${local.default_prefix}-config"
}

resource "aws_s3_bucket_versioning" "config" {
  bucket = aws_s3_bucket.config.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "config" {
  bucket = aws_s3_bucket.config.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "config" {
  bucket = aws_s3_bucket.config.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "config" {
  bucket = aws_s3_bucket.config.id
  policy = templatefile("${path.root}/policy/config_bucket_policy.json", {
    BucketName = aws_s3_bucket.config.bucket
    AccountID  = local.account_id
    Prefix     = "config"
  })
}

/* Configを各リージョンで有効化 */
module "config_ap-northeast-1" {
  source = "./modules/config/"

  prefix         = local.default_prefix
  bucket_name    = aws_s3_bucket.config.bucket
  is_main_region = true
  config_role    = aws_iam_role.config.arn

}
module "config_us-east-1" {
  source = "./modules/config/"

  prefix         = local.default_prefix
  bucket_name    = aws_s3_bucket.config.bucket
  is_main_region = false
  config_role    = aws_iam_role.config.arn

  providers = {
    aws = aws.us-east-1
  }
}
module "config_us-east-2" {
  source = "./modules/config/"

  prefix         = local.default_prefix
  bucket_name    = aws_s3_bucket.config.bucket
  is_main_region = false
  config_role    = aws_iam_role.config.arn

  providers = {
    aws = aws.us-east-2
  }
}
module "config_us-west-1" {
  source = "./modules/config/"

  prefix         = local.default_prefix
  bucket_name    = aws_s3_bucket.config.bucket
  is_main_region = false
  config_role    = aws_iam_role.config.arn

  providers = {
    aws = aws.us-west-1
  }
}
module "config_us-west-2" {
  source = "./modules/config/"

  prefix         = local.default_prefix
  bucket_name    = aws_s3_bucket.config.bucket
  is_main_region = false
  config_role    = aws_iam_role.config.arn

  providers = {
    aws = aws.us-west-2
  }
}
module "config_ap-south-1" {
  source = "./modules/config/"

  prefix         = local.default_prefix
  bucket_name    = aws_s3_bucket.config.bucket
  is_main_region = false
  config_role    = aws_iam_role.config.arn

  providers = {
    aws = aws.ap-south-1
  }
}
module "config_ap-northeast-2" {
  source = "./modules/config/"

  prefix         = local.default_prefix
  bucket_name    = aws_s3_bucket.config.bucket
  is_main_region = false
  config_role    = aws_iam_role.config.arn

  providers = {
    aws = aws.ap-northeast-2
  }
}
module "config_ap-southeast-1" {
  source = "./modules/config/"

  prefix         = local.default_prefix
  bucket_name    = aws_s3_bucket.config.bucket
  is_main_region = false
  config_role    = aws_iam_role.config.arn

  providers = {
    aws = aws.ap-southeast-1
  }
}
module "config_ap-southeast-2" {
  source = "./modules/config/"

  prefix         = local.default_prefix
  bucket_name    = aws_s3_bucket.config.bucket
  is_main_region = false
  config_role    = aws_iam_role.config.arn

  providers = {
    aws = aws.ap-southeast-2
  }
}
module "config_ca-central-1" {
  source = "./modules/config/"

  prefix         = local.default_prefix
  bucket_name    = aws_s3_bucket.config.bucket
  is_main_region = false
  config_role    = aws_iam_role.config.arn

  providers = {
    aws = aws.ca-central-1
  }
}
module "config_eu-central-1" {
  source = "./modules/config/"

  prefix         = local.default_prefix
  bucket_name    = aws_s3_bucket.config.bucket
  is_main_region = false
  config_role    = aws_iam_role.config.arn

  providers = {
    aws = aws.eu-central-1
  }
}
module "config_eu-west-1" {
  source = "./modules/config/"

  prefix         = local.default_prefix
  bucket_name    = aws_s3_bucket.config.bucket
  is_main_region = false
  config_role    = aws_iam_role.config.arn

  providers = {
    aws = aws.eu-west-1
  }
}
module "config_eu-west-2" {
  source = "./modules/config/"

  prefix         = local.default_prefix
  bucket_name    = aws_s3_bucket.config.bucket
  is_main_region = false
  config_role    = aws_iam_role.config.arn

  providers = {
    aws = aws.eu-west-2
  }
}
module "config_eu-west-3" {
  source = "./modules/config/"

  prefix         = local.default_prefix
  bucket_name    = aws_s3_bucket.config.bucket
  is_main_region = false
  config_role    = aws_iam_role.config.arn

  providers = {
    aws = aws.eu-west-3
  }
}
module "config_eu-north-1" {
  source = "./modules/config/"

  prefix         = local.default_prefix
  bucket_name    = aws_s3_bucket.config.bucket
  is_main_region = false
  config_role    = aws_iam_role.config.arn

  providers = {
    aws = aws.eu-north-1
  }
}
module "config_sa-east-1" {
  source = "./modules/config/"

  prefix         = local.default_prefix
  bucket_name    = aws_s3_bucket.config.bucket
  is_main_region = false
  config_role    = aws_iam_role.config.arn

  providers = {
    aws = aws.sa-east-1
  }
}

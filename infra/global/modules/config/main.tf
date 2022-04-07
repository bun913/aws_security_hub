# 主要リージョンではGlobalリソースの監視をOnにする
# https://aws.amazon.com/jp/blogs/news/aws-config-best-practices/

# また全リージョンで全ルールを有効化しているがコストが嵩むため、必要なルールだけに絞ることを検討
resource "aws_config_configuration_recorder" "main" {
  name     = "${var.prefix}-config-recorder"
  role_arn = var.config_role

  recording_group {
    all_supported                 = true
    include_global_resource_types = var.is_main_region ? true : false
  }
}

resource "aws_config_configuration_recorder_status" "main" {
  name       = aws_config_configuration_recorder.main.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.main]
}

resource "aws_config_delivery_channel" "main" {
  name           = "${var.prefix}-config-delivery-channel"
  s3_bucket_name = var.bucket_name
  s3_key_prefix  = "config"
  depends_on     = [aws_config_configuration_recorder.main]
}

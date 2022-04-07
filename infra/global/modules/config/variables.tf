variable "is_main_region" {
  type        = bool
  description = "メインリージョンでのみGlobalリソース監視を行うように制御するための変数"
}
variable "prefix" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "config_role" {
  type = string
}

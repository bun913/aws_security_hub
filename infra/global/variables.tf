variable "tags" {
  type = map(string)
  default = {
    "Project"   = "security-sample"
    "Terraform" = "true"
  }
}

variable "region" {
  type    = string
  default = "ap-northeast-1"
}

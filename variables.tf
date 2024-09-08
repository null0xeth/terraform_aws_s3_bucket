variable "resource_tags" {}
variable "provider_aws" {}
variable "bucket" {}
variable "dynamodb-name" { default = "terraform-lock" }

variable "create" {
  type    = bool
  default = true
}


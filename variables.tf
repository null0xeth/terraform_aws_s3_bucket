variable "resource_tags" {
  description = "List of resource tags to be added to all created resources"
  type        = list(string)
  default     = ["terraform", "infrastructure"]
}

variable "provider_aws" {
  description = "Configuration passed to the Hashicorp/aws provider"
  type = object({
    region = optional(string)
  })
}

variable "bucket" {
  description = "Configuration of the S3 bucket where we will store remote state."
  type = object({
    name       = optional(string, "terraform-state")
    acl        = optional(string, "private")
    versioning = optional(string, "Enabled")
    lock       = optional(bool, true)
    key        = optional(string, "terraform/stacks/by-id/bucket/terraform.tfstate")
    table      = optional(string, "terraform-lock")
  })
}

variable "dynamodb-name" {
  type        = string
  description = "Name of the DynamoDB table"
  default     = "terraform-lock"
}

variable "create" {
  description = "Dormant. Whether to create the S3 bucket"
  type        = bool
  default     = true
}


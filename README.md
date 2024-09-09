<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.64.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.6.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.64.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.terraform-state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_kms_key.terraform-bucket-key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.terraform-state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_object_lock_configuration.terraform-state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object_lock_configuration) | resource |
| [aws_s3_bucket_public_access_block.block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.terraform-state-bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.state-bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [random_pet.env](https://registry.terraform.io/providers/hashicorp/random/3.6.2/docs/resources/pet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket"></a> [bucket](#input\_bucket) | Configuration of the S3 bucket where we will store remote state. | <pre>object({<br>    name       = optional(string, "terraform-state")<br>    acl        = optional(string, "private")<br>    versioning = optional(string, "Enabled")<br>    lock       = optional(bool, true)<br>    key        = optional(string, "terraform/stacks/by-id/bucket/terraform.tfstate")<br>    table      = optional(string, "terraform-lock")<br>  })</pre> | n/a | yes |
| <a name="input_create"></a> [create](#input\_create) | Dormant. Whether to create the S3 bucket | `bool` | `true` | no |
| <a name="input_dynamodb-name"></a> [dynamodb-name](#input\_dynamodb-name) | Name of the DynamoDB table | `string` | `"terraform-lock"` | no |
| <a name="input_provider_aws"></a> [provider\_aws](#input\_provider\_aws) | Configuration passed to the Hashicorp/aws provider | <pre>object({<br>    region = optional(string)<br>  })</pre> | n/a | yes |
| <a name="input_resource_tags"></a> [resource\_tags](#input\_resource\_tags) | List of resource tags to be added to all created resources | `list(string)` | <pre>[<br>  "terraform",<br>  "infrastructure"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket"></a> [bucket](#output\_bucket) | Map with s3 bucket-specific information |
| <a name="output_dynamodb"></a> [dynamodb](#output\_dynamodb) | Map with dynamodb table-specific information |
<!-- END_TF_DOCS -->
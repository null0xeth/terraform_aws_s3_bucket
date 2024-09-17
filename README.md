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
| [aws_kms_key.new](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.new](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.new](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_cors_configuration.new](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_cors_configuration) | resource |
| [aws_s3_bucket_lifecycle_configuration.new](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_logging.new](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_object_lock_configuration.new](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object_lock_configuration) | resource |
| [aws_s3_bucket_ownership_controls.new](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.new](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.new](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.new](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.new](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_object.new](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [random_pet.env](https://registry.terraform.io/providers/hashicorp/random/3.6.2/docs/resources/pet) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_canonical_user_id.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/canonical_user_id) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_parent_bucket_id"></a> [parent\_bucket\_id](#input\_parent\_bucket\_id) | Use an existing bucket instead of creating a new one | `string` | `null` | no |
| <a name="input_parent_expected_bucket_owner"></a> [parent\_expected\_bucket\_owner](#input\_parent\_expected\_bucket\_owner) | The owner ID of the bucket passed to `parent_bucket_id` | `string` | `null` | no |
| <a name="input_parent_kms_key_id"></a> [parent\_kms\_key\_id](#input\_parent\_kms\_key\_id) | Use an already existing KMS key instead of creating a new one | `string` | `null` | no |
| <a name="input_provider_aws"></a> [provider\_aws](#input\_provider\_aws) | Configuration passed to the Hashicorp/aws provider | <pre>object({<br>    region = optional(string, "eu-west-1")<br>  })</pre> | `{}` | no |
| <a name="input_resource_tags"></a> [resource\_tags](#input\_resource\_tags) | List of tags to be added to created resources | `map(string)` | <pre>{<br>  "Managed_by": "terraform",<br>  "Name": "Not-set-yet"<br>}</pre> | no |
| <a name="input_s3_acl_block"></a> [s3\_acl\_block](#input\_s3\_acl\_block) | General ACL configuration options | <pre>object({<br>    block_public_acls       = optional(bool, true)<br>    block_public_policy     = optional(bool, true)<br>    ignore_public_acls      = optional(bool, true)<br>    restrict_public_buckets = optional(bool, true)<br>  })</pre> | `{}` | no |
| <a name="input_s3_acl_config"></a> [s3\_acl\_config](#input\_s3\_acl\_config) | Fine-grained ACL configuration options | <pre>object({<br>    acl = optional(string)<br>    access_control_policy = optional(list(object({<br>      owner = optional(object({<br>        id           = optional(string)<br>        display_name = optional(string)<br>      }))<br>      grant = optional(list(object({<br>        grantee = optional(object({<br>          id   = optional(string)<br>          type = optional(string, "CanonicalUser")<br>        }), {})<br>        permission = optional(string, "FULL_CONTROL")<br>      })), [{}])<br>    })), [{}])<br>  })</pre> | `{}` | no |
| <a name="input_s3_bucket"></a> [s3\_bucket](#input\_s3\_bucket) | Configure which child-resources will be created for the S3 bucket | <pre>object({<br>    acl_type                         = optional(string, "acp")<br>    bucket                           = optional(string, "clucker-bucket")<br>    enable_acl                       = optional(bool, true)<br>    enable_cors_configuration        = optional(bool, false)<br>    enable_logging                   = optional(bool, false)<br>    enable_lifecycle_configuration   = optional(bool, true)<br>    enable_object_lock_configuration = optional(bool, true)<br>    enable_server_side_encryption    = optional(bool, true)<br>    enable_versioning                = optional(bool, true)<br>    store_s3_object                  = optional(bool, false)<br>    force_destroy                    = optional(bool, true)<br>    object_ownership                 = optional(string, "BucketOwnerPreferred")<br>  })</pre> | `{}` | no |
| <a name="input_s3_cors_rules"></a> [s3\_cors\_rules](#input\_s3\_cors\_rules) | Configure Cross-Origin Resource Sharing rules | <pre>list(object({<br>    allowed_headers = optional(list(string))<br>    allowed_methods = optional(list(string))<br>    allowed_origins = optional(list(string))<br>    expose_headers  = optional(list(string))<br>    max_age_seconds = optional(number)<br>  }))</pre> | `null` | no |
| <a name="input_s3_global_policy_config"></a> [s3\_global\_policy\_config](#input\_s3\_global\_policy\_config) | Configure which policies will be enabled for resources created by this module | <pre>object({<br>    enable_bucket_policy  = optional(bool, false)<br>    enable_kms_key_policy = optional(bool, false)<br>    bucket_policy         = optional(any)<br>    kms_key_policy        = optional(any)<br><br>  })</pre> | `{}` | no |
| <a name="input_s3_global_resource_creation_config"></a> [s3\_global\_resource\_creation\_config](#input\_s3\_global\_resource\_creation\_config) | Configure which resources will be created by this module | <pre>object({<br>    append_random_id      = optional(bool, true)<br>    create_bucket         = optional(bool, true)<br>    create_kms_key        = optional(bool, true)<br>    create_bucket_policy  = optional(bool, false)<br>    create_kms_key_policy = optional(bool, false)<br>  })</pre> | `{}` | no |
| <a name="input_s3_lifecycle"></a> [s3\_lifecycle](#input\_s3\_lifecycle) | Configure S3 bucket lifecycle rules | <pre>object({<br>    rule = optional(list(object({<br>      id     = optional(string, "default")<br>      status = optional(string, "Enabled")<br><br>      abort_incomplete_multipart_upload = optional(object({<br>        days_after_initiation = optional(number)<br>      }), {})<br><br>      expiration = optional(object({<br>        date                         = optional(string)<br>        days                         = optional(number, 90)<br>        expired_object_delete_marker = optional(bool)<br>      }), {})<br><br>      filter = optional(list(object({<br>        object_size_greater_than = optional(number)<br>        object_size_less_than    = optional(number)<br>        prefix                   = optional(string)<br><br>        and = optional(object({<br>          object_size_greater_than = optional(number)<br>          object_size_less_than    = optional(number)<br>          prefix                   = optional(string)<br>          tags                     = optional(map(any))<br>        }))<br><br>        tag = optional(list(object({<br>          key   = optional(string)<br>          value = optional(string)<br>        })))<br>      })))<br><br>      noncurrent_version_expiration = optional(list(object({<br>        newer_noncurrent_versions = optional(number)<br>        noncurrent_days           = optional(number, 90)<br>      })), [{}])<br><br>      noncurrent_version_transition = optional(list(object({<br>        newer_noncurrent_versions = optional(number)<br>        noncurrent_days           = optional(number, 30)<br>        storage_class             = optional(string, "STANDARD_IA")<br>      })), [{}])<br><br>      transition = optional(list(object({<br>        date          = optional(string)<br>        days          = optional(number, 30)<br>        storage_class = optional(string, "STANDARD_IA")<br>      })), [{}])<br>    })), [{}])<br>  })</pre> | `{}` | no |
| <a name="input_s3_logging"></a> [s3\_logging](#input\_s3\_logging) | Configure S3 Bucket logging | <pre>object({<br>    bucket        = optional(string)<br>    target_bucket = optional(string)<br>    target_prefix = optional(string)<br>    target_grant = optional(list(object({<br>      grant = optional(list(object({<br>        permission = optional(string)<br>        grantee = optional(object({<br>          id   = optional(string)<br>          type = optional(string)<br>        }), {})<br>      })), [{}])<br>    })), [{}])<br>    target_object_key_format = optional(object({<br>      partitioned_prefix = optional(object({<br>        partitioned_date_source = optional(string)<br>      }))<br>    }), {})<br>  })</pre> | `null` | no |
| <a name="input_s3_object"></a> [s3\_object](#input\_s3\_object) | Create a new object in an existing S3 bucket | <pre>object({<br>    bucket                        = optional(string)<br>    key                           = optional(string)<br>    acl                           = optional(string)<br>    bucket_key_enabled            = optional(bool)<br>    cache_control                 = optional(any)<br>    checksum_algorithm            = optional(string)<br>    content_base64                = optional(string)<br>    content_disposition           = optional(string)<br>    content_encoding              = optional(string)<br>    content_language              = optional(string)<br>    content_type                  = optional(string)<br>    content                       = optional(string)<br>    etag                          = optional(string)<br>    force_destroy                 = optional(bool)<br>    kms_key_id                    = optional(string)<br>    metadata                      = optional(map(any))<br>    object_lock_legal_hold_status = optional(string)<br>    object_lock_retain_until_date = optional(string)<br>    override_provider             = optional(any)<br>    server_side_encryption        = optional(string)<br>    source_hash                   = optional(string)<br>    source                        = optional(string)<br>    storage_class                 = optional(string)<br>    tags                          = optional(map(any))<br>  })</pre> | `null` | no |
| <a name="input_s3_object_lock_configuration"></a> [s3\_object\_lock\_configuration](#input\_s3\_object\_lock\_configuration) | Configure S3 bucket object locking | <pre>object({<br>    object_lock_enabled = optional(string, "Enabled")<br>    rule = optional(object({<br>      default_retention = optional(object({<br>        days  = optional(number, 5)<br>        mode  = optional(string, "COMPLIANCE")<br>        years = optional(number)<br>      }), {})<br>    }), {})<br>  })</pre> | `{}` | no |
| <a name="input_s3_server_side_encryption"></a> [s3\_server\_side\_encryption](#input\_s3\_server\_side\_encryption) | Configure S3 Bucket server-side encryption | <pre>object({<br>    rule = optional(object({<br>      apply_server_side_encryption_by_default = optional(object({<br>        sse_algorithm = optional(string)<br>      }))<br>      bucket_key_enabled = optional(bool)<br>    }))<br>  })</pre> | `{}` | no |
| <a name="input_s3_versioning"></a> [s3\_versioning](#input\_s3\_versioning) | Configure S3 Bucket versioning | <pre>object({<br>    mfa = optional(string)<br>    versioning_configuration = optional(object({<br>      status     = optional(string, "Enabled")<br>      mfa_delete = optional(string, "Disabled")<br>    }), {})<br>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_info"></a> [info](#output\_info) | n/a |
| <a name="output_out"></a> [out](#output\_out) | Map with s3 bucket-specific information |
<!-- END_TF_DOCS -->
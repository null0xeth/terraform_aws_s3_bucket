############# GLOBAL - MODULE SCOPED #####################################################################
variable "resource_tags" {
  type        = map(string)
  description = "List of tags to be added to created resources"
  default = {
    Managed_by = "terraform"
    Name       = "Not-set-yet"
  }
}

variable "parent_bucket_id" {
  type        = string
  description = "Use an existing bucket instead of creating a new one"
  default     = null
}

variable "parent_kms_key_id" {
  type        = string
  description = "Use an already existing KMS key instead of creating a new one"
  default     = null
}

variable "parent_expected_bucket_owner" {
  type        = string
  description = "The owner ID of the bucket passed to `parent_bucket_id`"
  default     = null
}

########### GLOBAL - PROVIDER SCOPED #####################################################################
variable "provider_aws" {
  type = object({
    region = optional(string, "eu-west-1")
  })
  description = "Configuration passed to the Hashicorp/aws provider"
  default     = {}
}

########### GLOBAL - RESOURCE SCOPED #####################################################################
variable "s3_global_resource_creation_config" {
  type = object({
    append_random_id      = optional(bool, true)
    create_bucket         = optional(bool, true)
    create_kms_key        = optional(bool, true)
    create_bucket_policy  = optional(bool, false)
    create_kms_key_policy = optional(bool, false)
  })
  description = "Configure which resources will be created by this module"
  default     = {}
}

########### GLOBAL - POLICY SCOPED #####################################################################
variable "s3_global_policy_config" {
  type = object({
    enable_bucket_policy  = optional(bool, true)
    enable_kms_key_policy = optional(bool, true)
    bucket_policy         = optional(any)
    kms_key_policy        = optional(any)

  })
  description = "Configure which policies will be enabled for resources created by this module"
  default     = {}
}

########### S3 - BUCKET CREATION ########################################################################
variable "s3_bucket" {
  type = object({
    acl_type                         = optional(string, "acp")
    bucket                           = optional(string, "clucker-bucket")
    enable_acl                       = optional(bool, true)
    enable_cors_configuration        = optional(bool, false)
    enable_logging                   = optional(bool, false)
    enable_lifecycle_configuration   = optional(bool, true)
    enable_object_lock_configuration = optional(bool, true)
    enable_server_side_encryption    = optional(bool, true)
    enable_versioning                = optional(bool, true)
    store_s3_object                  = optional(bool, false)
    force_destroy                    = optional(bool, true)
    object_ownership                 = optional(string, "BucketOwnerPreferred")
  })
  description = "Configure which child-resources will be created for the S3 bucket"
  default     = {}
}

########### S3 CONFIG - ACL - BLOCK ########################################################################
variable "s3_acl_block" {
  type = object({
    block_public_acls       = optional(bool, true)
    block_public_policy     = optional(bool, true)
    ignore_public_acls      = optional(bool, true)
    restrict_public_buckets = optional(bool, true)
  })
  description = "General ACL configuration options"
  default     = {}
}

########### S3 CONFIG - ACL - CONFIG ########################################################################
variable "s3_acl_config" {
  type = object({
    acl = optional(string)
    access_control_policy = optional(list(object({
      owner = optional(object({
        id           = optional(string)
        display_name = optional(string)
      }))
      grant = optional(list(object({
        grantee = optional(object({
          id   = optional(string)
          type = optional(string, "CanonicalUser")
        }), {})
        permission = optional(string, "FULL_CONTROL")
      })), [{}])
    })), [{}])
  })
  description = "Fine-grained ACL configuration options"
  default     = {}
}

########### S3 CONFIG - CORS - RULES ########################################################################
variable "s3_cors_rules" {
  type = list(object({
    allowed_headers = optional(list(string))
    allowed_methods = optional(list(string))
    allowed_origins = optional(list(string))
    expose_headers  = optional(list(string))
    max_age_seconds = optional(number)
  }))
  description = "Configure Cross-Origin Resource Sharing rules"
  default     = null
}

########### S3 CONFIG - LOGGING ##############################################################################
variable "s3_logging" {
  type = object({
    bucket        = optional(string)
    target_bucket = optional(string)
    target_prefix = optional(string)
    target_grant = optional(list(object({
      grant = optional(list(object({
        permission = optional(string)
        grantee = optional(object({
          id   = optional(string)
          type = optional(string)
        }), {})
      })), [{}])
    })), [{}])
    target_object_key_format = optional(object({
      partitioned_prefix = optional(object({
        partitioned_date_source = optional(string)
      }))
    }), {})
  })
  description = "Configure S3 Bucket logging"
  default     = null
}

########### S3 CONFIG - LIFECYCLE ##############################################################################
variable "s3_lifecycle" {
  type = object({
    rule = optional(list(object({
      id     = optional(string, "default")
      status = optional(string, "Enabled")

      abort_incomplete_multipart_upload = optional(object({
        days_after_initiation = optional(number)
      }), {})

      expiration = optional(object({
        date                         = optional(string)
        days                         = optional(number, 90)
        expired_object_delete_marker = optional(bool)
      }), {})

      filter = optional(list(object({
        object_size_greater_than = optional(number)
        object_size_less_than    = optional(number)
        prefix                   = optional(string)

        and = optional(object({
          object_size_greater_than = optional(number)
          object_size_less_than    = optional(number)
          prefix                   = optional(string)
          tags                     = optional(map(any))
        }))

        tag = optional(list(object({
          key   = optional(string)
          value = optional(string)
        })))
      })))

      noncurrent_version_expiration = optional(list(object({
        newer_noncurrent_versions = optional(number)
        noncurrent_days           = optional(number, 90)
      })), [{}])

      noncurrent_version_transition = optional(list(object({
        newer_noncurrent_versions = optional(number)
        noncurrent_days           = optional(number, 30)
        storage_class             = optional(string, "STANDARD_IA")
      })), [{}])

      transition = optional(list(object({
        date          = optional(string)
        days          = optional(number, 30)
        storage_class = optional(string, "STANDARD_IA")
      })), [{}])
    })), [{}])
  })
  description = "Configure S3 bucket lifecycle rules"
  default     = {}
}

########### S3 CONFIG - OBJECT LOCK CONFIG ##############################################################
variable "s3_object_lock_configuration" {
  type = object({
    object_lock_enabled = optional(string, "Enabled")
    rule = optional(object({
      default_retention = optional(object({
        days  = optional(number, 5)
        mode  = optional(string, "COMPLIANCE")
        years = optional(number)
      }), {})
    }), {})
  })
  description = "Configure S3 bucket object locking"
  default     = {}
}

########### S3 CONFIG - SERVER SIDE ENCRYPTION ###########################################################
variable "s3_server_side_encryption" {
  type = object({
    rule = optional(object({
      apply_server_side_encryption_by_default = optional(object({
        sse_algorithm = optional(string, "aws:kms")
      }), {})
      bucket_key_enabled = optional(bool, true)
    }), {})
  })
  description = "Configure S3 Bucket server-side encryption"
  default     = {}
}

########### S3 CONFIG - VERSIONING #####################################################################
variable "s3_versioning" {
  type = object({
    mfa = optional(string)
    versioning_configuration = optional(object({
      status     = optional(string, "Enabled")
      mfa_delete = optional(string, "Disabled")
    }), {})
  })
  description = "Configure S3 Bucket versioning"
  default     = {}
}

########### S3 - OBJECT IN BUCKET CREATION ##############################################################
variable "s3_object" {
  type = object({
    bucket                        = optional(string)
    key                           = optional(string)
    acl                           = optional(string)
    bucket_key_enabled            = optional(bool)
    cache_control                 = optional(any)
    checksum_algorithm            = optional(string)
    content_base64                = optional(string)
    content_disposition           = optional(string)
    content_encoding              = optional(string)
    content_language              = optional(string)
    content_type                  = optional(string)
    content                       = optional(string)
    etag                          = optional(string)
    force_destroy                 = optional(bool)
    kms_key_id                    = optional(string)
    metadata                      = optional(map(any))
    object_lock_legal_hold_status = optional(string)
    object_lock_retain_until_date = optional(string)
    override_provider             = optional(any)
    server_side_encryption        = optional(string)
    source_hash                   = optional(string)
    source                        = optional(string)
    storage_class                 = optional(string)
    tags                          = optional(map(any))
  })
  description = "Create a new object in an existing S3 bucket"
  default     = null
}



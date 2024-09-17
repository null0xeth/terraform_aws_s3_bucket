############# GLOBAL - MODULE SCOPED #####################################################################
#### TO BE UPDATED
variable "resource_tags" {
  description = "List of tags to be added to created resources"
  type        = map(string)
  default = {
    Managed_by = "terraform"
    Name       = "Not-set-yet"
  }
}

variable "parent_bucket_id" {
  description = "Pass existing bucket when calling this as a child module in another module."
  type        = string
  default     = null
}

variable "parent_kms_key_id" {
  description = "Pass existing kms key when calling this as a child module in another module."
  type        = string
  default     = null
}

variable "parent_expected_bucket_owner" {
  description = "Pass existing expected bucket owner when calling this as a child module in another module."
  type        = string
  default     = null
}

########### GLOBAL - PROVIDER SCOPED #####################################################################
variable "provider_aws" {
  description = "Configuration passed to the Hashicorp/aws provider"
  default     = {}
  type = object({
    region = optional(string, "eu-west-1")
  })
}

########### GLOBAL - RESOURCE SCOPED #####################################################################
#### TO BE UPDATED
variable "s3_global_resource_creation_config" {
  type = object({
    append_random_id      = optional(bool, true)
    create_bucket         = optional(bool, true)
    create_kms_key        = optional(bool, true)
    create_bucket_policy  = optional(bool, false)
    create_kms_key_policy = optional(bool, false)
  })
  default = {}
}

########### GLOBAL - POLICY SCOPED #####################################################################
#### TO BE UPDATED
variable "s3_global_policy_config" {
  type = object({
    # Enable [x] policy
    enable_bucket_policy  = optional(bool, false)
    enable_kms_key_policy = optional(bool, false)
    # Use existing resources when available
    bucket_policy  = optional(any)
    kms_key_policy = optional(any)

  })
  default = {}
}

########### S3 - BUCKET CREATION ########################################################################
variable "s3_bucket" {
  default     = {}
  description = "Parameters used to create an S3 bucket on AWS"
  type = object({
    acl_type = optional(string, "acp")
    #acl_canned_policy                = optional(string) # public-read|private
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
    object_ownership                 = optional(string, "BucketOwnerPreferred") # BucketOwnerPreferred|..
  })
}

########### S3 CONFIG - ACL - BLOCK ########################################################################
variable "s3_acl_block" {
  default = {}
  type = object({
    #bucket                  = optional(string)
    block_public_acls       = optional(bool, true)
    block_public_policy     = optional(bool, true)
    ignore_public_acls      = optional(bool, true)
    restrict_public_buckets = optional(bool, true)
  })
}

########### S3 CONFIG - ACL - CONFIG ########################################################################
variable "s3_acl_config" {
  default = {}
  type = object({
    acl = optional(string) # READ|READ_ACP
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
}

########### S3 CONFIG - CORS - RULES ########################################################################
#### TO BE UPDATED
variable "s3_cors_rules" {
  type = list(object({
    allowed_headers = optional(list(string))
    allowed_methods = optional(list(string))
    allowed_origins = optional(list(string))
    expose_headers  = optional(list(string))
    max_age_seconds = optional(number)
  }))
  default = null
}

########### S3 CONFIG - LOGGING ##############################################################################
variable "s3_logging" {
  default = null
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
}

########### S3 CONFIG - LIFECYCLE ##############################################################################
variable "s3_lifecycle" {
  default = {}
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
  default = {}
}

########### S3 CONFIG - SERVER SIDE ENCRYPTION ###########################################################
variable "s3_server_side_encryption" {
  default = {}
  type = object({
    rule = optional(object({
      apply_server_side_encryption_by_default = optional(object({
        ######## PARAMS: ##########################################
        sse_algorithm = optional(string)
      }))
      bucket_key_enabled = optional(bool)
    }))
  })
}

########### S3 CONFIG - VERSIONING #####################################################################
variable "s3_versioning" {
  default = {}
  type = object({
    mfa = optional(string)
    versioning_configuration = optional(object({
      status     = optional(string, "Enabled")
      mfa_delete = optional(string, "Disabled")
    }), {})
  })
}

########### S3 - OBJECT IN BUCKET CREATION ##############################################################
#### TO BE UPDATED
variable "s3_object" {
  default     = null
  description = "Parameters used to create an object inside an S3 bucket on AWS"
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
}



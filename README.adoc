<!-- BEGIN_TF_DOCS -->
== Requirements

[cols="a,a",options="header,autowidth"]
|===
|Name |Version
|[[requirement_aws]] <<requirement_aws,aws>> |~> 5.64.0
|[[requirement_random]] <<requirement_random,random>> |3.6.2
|===

== Providers

[cols="a,a",options="header,autowidth"]
|===
|Name |Version
|[[provider_aws]] <<provider_aws,aws>> |~> 5.64.0
|[[provider_random]] <<provider_random,random>> |3.6.2
|===

== Modules

No modules.

== Resources

[cols="a,a",options="header,autowidth"]
|===
|Name |Type
|https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key[aws_kms_key.new] |resource
|https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket[aws_s3_bucket.new] |resource
|https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl[aws_s3_bucket_acl.new] |resource
|https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_cors_configuration[aws_s3_bucket_cors_configuration.new] |resource
|https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration[aws_s3_bucket_lifecycle_configuration.new] |resource
|https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging[aws_s3_bucket_logging.new] |resource
|https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object_lock_configuration[aws_s3_bucket_object_lock_configuration.new] |resource
|https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls[aws_s3_bucket_ownership_controls.new] |resource
|https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy[aws_s3_bucket_policy.new] |resource
|https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block[aws_s3_bucket_public_access_block.new] |resource
|https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration[aws_s3_bucket_server_side_encryption_configuration.new] |resource
|https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning[aws_s3_bucket_versioning.new] |resource
|https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object[aws_s3_object.new] |resource
|https://registry.terraform.io/providers/hashicorp/random/3.6.2/docs/resources/pet[random_pet.env] |resource
|https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity[aws_caller_identity.current] |data source
|https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/canonical_user_id[aws_canonical_user_id.current] |data source
|===

== Inputs

[cols="a,a,a,a,a",options="header,autowidth"]
|===
|Name |Description |Type |Default |Required
|[[input_parent_bucket_id]] <<input_parent_bucket_id,parent_bucket_id>>
|Pass existing bucket when calling this as a child module in another module.
|`string`
|`null`
|no

|[[input_parent_expected_bucket_owner]] <<input_parent_expected_bucket_owner,parent_expected_bucket_owner>>
|Pass existing expected bucket owner when calling this as a child module in another module.
|`string`
|`null`
|no

|[[input_parent_kms_key_id]] <<input_parent_kms_key_id,parent_kms_key_id>>
|Pass existing kms key when calling this as a child module in another module.
|`string`
|`null`
|no

|[[input_provider_aws]] <<input_provider_aws,provider_aws>>
|Configuration passed to the Hashicorp/aws provider
|

[source]
----
object({
    region = optional(string, "eu-west-1")
  })
----

|`{}`
|no

|[[input_resource_tags]] <<input_resource_tags,resource_tags>>
|List of tags to be added to created resources
|`map(string)`
|

[source]
----
{
  "Managed_by": "terraform",
  "Name": "Not-set-yet"
}
----

|no

|[[input_s3_acl_block]] <<input_s3_acl_block,s3_acl_block>>
|########## S3 CONFIG - ACL - BLOCK ########################################################################
|

[source]
----
object({
    #bucket                  = optional(string)
    block_public_acls       = optional(bool, true)
    block_public_policy     = optional(bool, true)
    ignore_public_acls      = optional(bool, true)
    restrict_public_buckets = optional(bool, true)
  })
----

|`{}`
|no

|[[input_s3_acl_config]] <<input_s3_acl_config,s3_acl_config>>
|########## S3 CONFIG - ACL - CONFIG ########################################################################
|

[source]
----
object({
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
----

|`{}`
|no

|[[input_s3_bucket]] <<input_s3_bucket,s3_bucket>>
|Parameters used to create an S3 bucket on AWS
|

[source]
----
object({
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
----

|`{}`
|no

|[[input_s3_cors_rules]] <<input_s3_cors_rules,s3_cors_rules>>
|########## S3 CONFIG - CORS - RULES ######################################################################## ### TO BE UPDATED
|

[source]
----
list(object({
    allowed_headers = optional(list(string))
    allowed_methods = optional(list(string))
    allowed_origins = optional(list(string))
    expose_headers  = optional(list(string))
    max_age_seconds = optional(number)
  }))
----

|`null`
|no

|[[input_s3_global_policy_config]] <<input_s3_global_policy_config,s3_global_policy_config>>
|########## GLOBAL - POLICY SCOPED ##################################################################### ### TO BE UPDATED
|

[source]
----
object({
    # Enable [x] policy
    enable_bucket_policy  = optional(bool, false)
    enable_kms_key_policy = optional(bool, false)
    # Use existing resources when available
    bucket_policy  = optional(any)
    kms_key_policy = optional(any)

  })
----

|`{}`
|no

|[[input_s3_global_resource_creation_config]] <<input_s3_global_resource_creation_config,s3_global_resource_creation_config>>
|########## GLOBAL - RESOURCE SCOPED ##################################################################### ### TO BE UPDATED
|

[source]
----
object({
    append_random_id      = optional(bool, true)
    create_bucket         = optional(bool, true)
    create_kms_key        = optional(bool, true)
    create_bucket_policy  = optional(bool, false)
    create_kms_key_policy = optional(bool, false)
  })
----

|`{}`
|no

|[[input_s3_lifecycle]] <<input_s3_lifecycle,s3_lifecycle>>
|########## S3 CONFIG - LIFECYCLE ##############################################################################
|

[source]
----
object({
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
----

|`{}`
|no

|[[input_s3_logging]] <<input_s3_logging,s3_logging>>
|########## S3 CONFIG - LOGGING ##############################################################################
|

[source]
----
object({
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
----

|`null`
|no

|[[input_s3_object]] <<input_s3_object,s3_object>>
|Parameters used to create an object inside an S3 bucket on AWS
|

[source]
----
object({
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
----

|`null`
|no

|[[input_s3_object_lock_configuration]] <<input_s3_object_lock_configuration,s3_object_lock_configuration>>
|########## S3 CONFIG - OBJECT LOCK CONFIG ##############################################################
|

[source]
----
object({
    object_lock_enabled = optional(string, "Enabled")
    rule = optional(object({
      default_retention = optional(object({
        days  = optional(number, 5)
        mode  = optional(string, "COMPLIANCE")
        years = optional(number)
      }), {})
    }), {})
  })
----

|`{}`
|no

|[[input_s3_server_side_encryption]] <<input_s3_server_side_encryption,s3_server_side_encryption>>
|########## S3 CONFIG - SERVER SIDE ENCRYPTION ###########################################################
|

[source]
----
object({
    rule = optional(object({
      apply_server_side_encryption_by_default = optional(object({
        ######## PARAMS: ##########################################
        sse_algorithm = optional(string)
      }))
      bucket_key_enabled = optional(bool)
    }))
  })
----

|`{}`
|no

|[[input_s3_versioning]] <<input_s3_versioning,s3_versioning>>
|########## S3 CONFIG - VERSIONING #####################################################################
|

[source]
----
object({
    mfa = optional(string)
    versioning_configuration = optional(object({
      status     = optional(string, "Enabled")
      mfa_delete = optional(string, "Disabled")
    }), {})
  })
----

|`{}`
|no

|===

== Outputs

[cols="a,a",options="header,autowidth"]
|===
|Name |Description
|[[output_info]] <<output_info,info>> |n/a
|[[output_out]] <<output_out,out>> |Map with s3 bucket-specific information
|===
<!-- END_TF_DOCS -->
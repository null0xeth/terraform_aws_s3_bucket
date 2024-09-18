########### RANDOM ID #######################################################################################
resource "random_pet" "env" {
  length    = 2
  separator = "-"
}

########### AWS DATA #######################################################################################
data "aws_canonical_user_id" "current" {}
data "aws_caller_identity" "current" {}

########### LOCAL VAR ######################################################################################
locals {
  # NEW BUCKET CREATION:
  bucket_name                     = local.create_bucket ? (var.s3_global_resource_creation_config.append_random_id ? "${var.s3_bucket.bucket}-${random_pet.env.id}" : var.s3_bucket.bucket) : var.parent_bucket_id
  create_bucket                   = try(tobool(var.parent_bucket_id == null && var.s3_global_resource_creation_config.create_bucket), false)
  create_bucket_acl               = tobool(local.create_bucket && var.s3_bucket.enable_acl)
  create_bucket_cors_rules        = var.s3_bucket.enable_cors_configuration
  create_bucket_lifecycle_rules   = var.s3_bucket.enable_lifecycle_configuration
  create_bucket_object_lock_rules = var.s3_bucket.enable_object_lock_configuration
  create_bucket_policy            = var.s3_global_resource_creation_config.create_bucket_policy
  create_bucket_versioning_rules  = var.s3_bucket.enable_versioning
  # NEW BUCKET SETTINGS:
  enable_bucket_encryption = var.s3_bucket.enable_server_side_encryption
  enable_bucket_logging    = var.s3_bucket.enable_logging
  enable_bucket_policy     = var.s3_global_policy_config.enable_bucket_policy
  # NEW KMS KEY CREATION:
  create_kms_key        = var.s3_global_resource_creation_config.create_kms_key
  create_kms_key_policy = var.s3_global_resource_creation_config.create_kms_key_policy
  # S3 GENERAL:
  expected_bucket_owner = tostring(try(var.parent_expected_bucket_owner, data.aws_canonical_user_id.current.id))
}

########### KMS KEY ########################################################################################
resource "aws_kms_key" "new" {
  count                   = local.create_kms_key ? 1 : 0
  description             = "Terraform generated- and managed KMS key"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy = (!local.create_kms_key_policy ? var.s3_global_policy_config.kms_key_policy : jsonencode({
    Version = "2012-10-17"
    Id      = "key-default-1"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  }))
}

########### S3 - BUCKET CREATION ###########################################################################
resource "aws_s3_bucket" "new" {
  count               = local.create_bucket ? 1 : 0
  bucket              = tostring(local.bucket_name)
  force_destroy       = var.s3_bucket.force_destroy
  object_lock_enabled = var.s3_bucket.enable_object_lock_configuration
  tags                = var.resource_tags
}

########### S3 CONFIG - LOGGING ##############################################################################
resource "aws_s3_bucket_logging" "new" {
  count                 = local.enable_bucket_logging ? 1 : 0
  bucket                = var.s3_logging.bucket
  expected_bucket_owner = tostring(local.expected_bucket_owner)
  target_bucket         = var.s3_logging.target_bucket
  target_prefix         = var.s3_logging.target_prefix

  dynamic "target_grant" {
    for_each = try(var.s3_logging.target_grant, [])
    content {
      permission = try(target_grant.value["permission"], null)
      dynamic "grantee" {
        for_each = try(target_grant.value["grantee"], [])
        content {
          id   = try(grantee.value["id"], null)
          type = try(grantee.value["type"], null)
        }
      }
    }
  }
}

########### S3 - BUCKET POLICY #############################################################################
resource "aws_s3_bucket_policy" "new" {
  count  = local.enable_bucket_policy ? 1 : 0
  bucket = aws_s3_bucket.new[0].id
  policy = (!local.create_bucket_policy ? var.s3_global_policy_config.bucket_policy : jsonencode({
    Version = "2012-10-17"
    Id      = "s3-default-1"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "s3:*"
        Resource = "*"
      }
    ]
  }))
}

########### S3 CONFIG - ACL - BLOCK ########################################################################
resource "aws_s3_bucket_public_access_block" "new" {
  count                   = local.create_bucket_acl ? 1 : 0 #local.create_bucket && var.s3_bucket.enable_acl ? 1 : 0
  bucket                  = aws_s3_bucket.new[0].id
  block_public_acls       = var.s3_acl_block.block_public_acls
  block_public_policy     = var.s3_acl_block.block_public_policy
  ignore_public_acls      = var.s3_acl_block.ignore_public_acls
  restrict_public_buckets = var.s3_acl_block.restrict_public_buckets
}

########### S3 CONFIG - ACL - OWNERSHIP CONTROLS ###########################################################
resource "aws_s3_bucket_ownership_controls" "new" {
  bucket = aws_s3_bucket.new[0].id
  depends_on = [
    aws_s3_bucket.new,
    aws_s3_bucket_public_access_block.new
  ]

  rule {
    object_ownership = try(var.s3_bucket.object_ownership, data.aws_canonical_user_id.current.id)
  }
}

########### S3 CONFIG - ACL - CONFIG ########################################################################
resource "aws_s3_bucket_acl" "new" {
  count                 = local.create_bucket_acl ? 1 : 0
  bucket                = aws_s3_bucket.new[0].id
  depends_on            = [aws_s3_bucket_ownership_controls.new]
  expected_bucket_owner = local.expected_bucket_owner

  dynamic "access_control_policy" {
    for_each = try(var.s3_acl_config.access_control_policy, [])
    content {
      dynamic "grant" {
        for_each = try(access_control_policy.value["grant"], [])
        content {
          permission = try(grant.value["permission"], "FULL_CONTROL")
          grantee {
            id   = (grant.value["grantee"].id != null ? grant.value["grantee"].id : data.aws_canonical_user_id.current.id)
            type = grant.value["grantee"].type
          }
        }
      }
      owner {
        id           = tostring(try(access_control_policy.value.owner.id, data.aws_canonical_user_id.current.id))
        display_name = tostring(try(access_control_policy.value.owner.display_name, data.aws_canonical_user_id.current.display_name))
      }
    }
  }
}

########### S3 CONFIG - CORS - RULES ########################################################################
resource "aws_s3_bucket_cors_configuration" "new" {
  count  = local.create_bucket_cors_rules ? 1 : 0
  bucket = aws_s3_bucket.new[0].id

  dynamic "cors_rule" {
    for_each = try(var.s3_cors_rules, [])
    content {
      allowed_headers = try(cors_rule.value["allowed_headers"], null)
      allowed_methods = try(cors_rule.value["allowed_methods"], null)
      allowed_origins = try(cors_rule.value["allowed_origins"], null)
      expose_headers  = try(cors_rule.value["expose_headers"], null)
      max_age_seconds = try(cors_rule.value["max_age_seconds"], null)
    }
  }
}

########### S3 CONFIG - VERSIONING #####################################################################
resource "aws_s3_bucket_versioning" "new" {
  count                 = local.create_bucket_versioning_rules ? 1 : 0
  bucket                = aws_s3_bucket.new[0].id
  expected_bucket_owner = tostring(local.expected_bucket_owner)
  mfa                   = var.s3_versioning.mfa

  dynamic "versioning_configuration" {
    for_each = try([var.s3_versioning.versioning_configuration], [])
    content {
      status     = try(versioning_configuration.value.status, "Enabled")
      mfa_delete = try(versioning_configuration.value.mfa_delete, null)
    }
  }
}

########### S3 CONFIG - LIFECYCLE ##############################################################################
resource "aws_s3_bucket_lifecycle_configuration" "new" {
  count                 = local.create_bucket_lifecycle_rules ? 1 : 0
  bucket                = aws_s3_bucket.new[0].id
  depends_on            = [aws_s3_bucket_versioning.new]
  expected_bucket_owner = tostring(local.expected_bucket_owner)

  dynamic "rule" {
    for_each = try(var.s3_lifecycle.rule, [])
    content {
      id     = rule.value.id
      status = rule.value.status

      dynamic "abort_incomplete_multipart_upload" {
        # One block only
        for_each = try([rule.value["abort_incomplete_multipart_upload"]], [])
        content {
          days_after_initiation = abort_incomplete_multipart_upload.value["days_after_initiation"]
        }
      }

      dynamic "expiration" {
        # One block only
        for_each = try([rule.value["expiration"]], [])
        content {
          date                         = try(expiration.value["date"], null)
          days                         = try(expiration.value["days"], null)
          expired_object_delete_marker = try(expiration.value["expired_object_delete_marker"], null)
        }
      }

      dynamic "filter" {
        for_each = try([rule.value.filter], [])
        content {
          object_size_greater_than = try(filter.value.object_size_greater_than, null)
          object_size_less_than    = try(filter.value.object_size_less_than, null)
          prefix                   = try(filter.value.prefix, null)

          dynamic "and" {
            for_each = try(filter.value.and, [])
            content {
              object_size_greater_than = try(and.value.object_size_greater_than, null)
              object_size_less_than    = try(and.value.object_size_less_than, null)
              prefix                   = try(and.value.prefix, null)
              tags                     = try(and.value.tags, null)
            }
          }

          dynamic "tag" {
            for_each = try(filter.value.tag, [])
            content {
              key   = try(tag.value["key"], null)
              value = try(tag.value["value"], null)
            }
          }
        }
      }

      dynamic "noncurrent_version_expiration" {
        # One block only
        for_each = try(rule.value.noncurrent_version_expiration, [])
        content {
          newer_noncurrent_versions = try(noncurrent_version_expiration.value["newer_noncurrent_versions"], null)
          noncurrent_days           = try(noncurrent_version_expiration.value["noncurrent_days"], null)
        }
      }

      dynamic "noncurrent_version_transition" {
        # One or more Blocks
        for_each = try(rule.value.noncurrent_version_transition, [])
        content {
          newer_noncurrent_versions = try(noncurrent_version_transition.value["newer_noncurrent_versions"], null)
          noncurrent_days           = try(noncurrent_version_transition.value["noncurrent_days"], null)
          storage_class             = try(noncurrent_version_transition.value["storage_class"], null)
        }
      }

      dynamic "transition" {
        # One or more blocks
        for_each = try(rule.value.transition, [])
        content {
          days          = try(transition.value["days"], null)
          storage_class = try(transition.value["storage_class"], null)
        }
      }
    }
  }
}

########### S3 CONFIG - OBJECT LOCK CONFIG ##############################################################
resource "aws_s3_bucket_object_lock_configuration" "new" {
  count                 = local.create_bucket_object_lock_rules ? 1 : 0
  bucket                = aws_s3_bucket.new[0].id
  expected_bucket_owner = tostring(local.expected_bucket_owner)
  object_lock_enabled   = try(var.s3_object_lock_configuration.object_lock_enabled, null)

  dynamic "rule" {
    for_each = try([var.s3_object_lock_configuration.rule], [])
    content {
      default_retention {
        mode = try(rule.value["default_retention"].mode, null)
        days = try(rule.value["default_retention"].days, null)
      }
    }
  }
}

########### S3 CONFIG - SERVER SIDE ENCRYPTION ###########################################################
resource "aws_s3_bucket_server_side_encryption_configuration" "new" {
  count                 = local.enable_bucket_encryption ? 1 : 0
  bucket                = aws_s3_bucket.new[0].id
  depends_on            = [aws_kms_key.new]
  expected_bucket_owner = tostring(local.expected_bucket_owner)

  dynamic "rule" {
    for_each = try([var.s3_server_side_encryption.rule], [])
    content {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.parent_kms_key_id != null ? var.parent_kms_key_id : aws_kms_key.new[0].id
        sse_algorithm     = rule.value["apply_server_side_encryption_by_default"].sse_algorithm
      }
      bucket_key_enabled = try(rule.value["bucket_key_enabled"], false)
    }
  }
}

########### S3 OBJECT - NEW ############################################################################
resource "aws_s3_object" "new" {
  count                         = var.s3_bucket.store_s3_object ? 1 : 0
  bucket                        = tostring(local.bucket_name)
  depends_on                    = [aws_s3_bucket.new]
  bucket_key_enabled            = var.s3_object.bucket_key_enabled
  cache_control                 = var.s3_object.cache_control
  checksum_algorithm            = var.s3_object.checksum_algorithm
  content_base64                = var.s3_object.content_base64
  content_disposition           = var.s3_object.content_disposition
  content_encoding              = var.s3_object.content_encoding
  content_language              = var.s3_object.content_language
  content_type                  = var.s3_object.content_type
  content                       = var.s3_object.content
  etag                          = var.s3_object.etag
  force_destroy                 = var.s3_object.force_destroy
  key                           = var.s3_object.key
  kms_key_id                    = try(var.s3_object.kms_key_id, aws_kms_key.new[0].id)
  metadata                      = var.s3_object.metadata
  object_lock_legal_hold_status = var.s3_object.object_lock_legal_hold_status
  object_lock_retain_until_date = var.s3_object.object_lock_retain_until_date
  server_side_encryption        = var.s3_object.server_side_encryption
  source                        = var.s3_object.source
  source_hash                   = var.s3_object.source_hash
  storage_class                 = var.s3_object.storage_class
  tags                          = var.resource_tags
}


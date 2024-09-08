########### RANDOM ID #####################################################################
resource "random_pet" "env" {
  length    = 2
  separator = "_"
}

########### DYNAMO DB #####################################################################
resource "aws_dynamodb_table" "terraform-state" {
  name           = "${var.dynamodb-name}-${random_pet.env.id}"
  read_capacity  = local.dynamodb.read_capacity
  write_capacity = local.dynamodb.write_capacity
  hash_key       = local.dynamodb.hash_key

  tags = {
    for tag_id, tag_val in var.resource_tags : tag_id => tag_val
  }

  attribute {
    name = local.dynamodb.hash_key
    type = "S"
  }
}

########### KMS KEY #####################################################################
resource "aws_kms_key" "terraform-bucket-key" {
  description             = local.kms_key.desc
  enable_key_rotation     = local.kms_key.rotation
  deletion_window_in_days = local.kms_key.deletion
}

########### S3 BUCKET #####################################################################
resource "aws_s3_bucket" "terraform-state" {
  bucket        = var.bucket.name
  force_destroy = true

  tags = {
    /* for tag_id, tag_val in var.resource_tags : tag_id => tag_val */
    managed_by = var.resource_tags[0]
    name       = var.resource_tags[1]
  }

}

resource "aws_s3_bucket_versioning" "state-bucket" {
  bucket = aws_s3_bucket.terraform-state.id

  versioning_configuration {
    status = var.bucket.versioning
  }
}

resource "aws_s3_bucket_object_lock_configuration" "terraform-state" {
  count  = var.bucket.lock ? 1 : 0
  bucket = aws_s3_bucket.terraform-state.id

  rule {
    default_retention {
      mode = "COMPLIANCE"
      days = 5
    }
  }

}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform-state-bucket" {
  bucket = aws_s3_bucket.terraform-state.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.terraform-bucket-key.arn
      sse_algorithm     = "aws:kms"
    }
  }

}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket                  = aws_s3_bucket.terraform-state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


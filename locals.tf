locals {
  kms_key = {
    desc     = "KMS key"
    rotation = true
    deletion = 10
  }

  dynamodb = {
    name           = "vault-terraform-lock"
    read_capacity  = 5
    write_capacity = 5
    hash_key       = "LockID"
  }
}

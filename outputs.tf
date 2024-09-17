output "out" {
  description = "Map with s3 bucket-specific information"
  value = zipmap(
    ["bucket_id", "bucket_arn", "kms_key_id", "kms_key_arn"],
    [
      element(aws_s3_bucket.new, 0).id,
      element(aws_s3_bucket.new, 0).arn,
      element(aws_kms_key.new, 0).key_id,
      element(aws_kms_key.new, 0).arn,
    ]
  )
}

output "info" {
  value = <<-EOF
  Resource creation summary:
    bucket id: ${(element(aws_s3_bucket.new, 0).id)}
    bucket arn: ${(element(aws_s3_bucket.new, 0).arn)}
    kms key id: ${(element(aws_kms_key.new, 0).key_id)}
    kms key arn: ${(element(aws_kms_key.new, 0).arn)}
  EOF
}
# output "dynamodb" {
#   description = "Map with dynamodb table-specific information"
#   value = zipmap(
#     ["name", "arn"],
#     [aws_dynamodb_table.terraform-state.id, aws_dynamodb_table.terraform-state.arn],
#   )
# }

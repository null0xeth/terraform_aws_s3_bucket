output "bucket" {
  description = "Map with s3 bucket-specific information"
  value = zipmap(
    ["name", "arn"],
    [
      aws_s3_bucket.terraform-state.id,
      aws_s3_bucket.terraform-state.arn,
    ]
  )
}

output "dynamodb" {
  description = "Map with dynamodb table-specific information"
  value = zipmap(
    ["name", "arn"],
    [aws_dynamodb_table.terraform-state.id, aws_dynamodb_table.terraform-state.arn],
  )
}

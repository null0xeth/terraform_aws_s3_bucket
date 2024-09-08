output "bucket" {
  value = zipmap(
    ["name", "arn"],
    [
      aws_s3_bucket.terraform-state.id,
      aws_s3_bucket.terraform-state.arn,
    ]
  )
}

output "dynamodb" {
  value = zipmap(
    ["name", "arn"],
    [aws_dynamodb_table.terraform-state.id, aws_dynamodb_table.terraform-state.arn],
  )
}

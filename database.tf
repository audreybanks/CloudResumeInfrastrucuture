resource "aws_dynamodb_table" "visitor-count" {
  name           = "VisitorCount"
  hash_key       = "Count_Id"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "Count_Id"
    type = "S"
  }

}
locals {
  s3_bucket_name = "audrey-banks-cloud-resume-frontend"
}

resource "aws_s3_bucket" "frontend" {
  bucket = local.s3_bucket_name
}
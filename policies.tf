data "aws_iam_policy_document" "cloudfront_oac_access" {
  statement {
    sid = "frontendPolicy"

    principals {
      identifiers = ["cloudfront.amazonaws.com"]
      type        = "Service"
    }

    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.frontend.arn}/*"]

    condition {
      test     = "StringEquals"
      values   = [aws_cloudfront_distribution.main_distribution.arn]
      variable = "AWS:SourceArn"
    }
  }
}

resource "aws_s3_bucket_policy" "cloudfront_s3_policy" {
  bucket = aws_s3_bucket.frontend.id
  policy = data.aws_iam_policy_document.cloudfront_oac_access.json
}
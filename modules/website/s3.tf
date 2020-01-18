
resource "aws_s3_bucket" "bucket" {
  bucket = "www.${var.root_domain_name}"
  acl    = "public-read"
  policy = data.aws_iam_policy_document.policy_document.json

  website {
    index_document = var.index_page
    error_document = var.error_page
  }
}
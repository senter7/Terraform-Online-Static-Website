resource "aws_s3_bucket" "bucket" {
  bucket = "www.${var.root_domain_name}"
  acl    = "public-read"
  policy = data.aws_iam_policy_document.policy_document.json

  website {
    index_document = var.index_page
    error_document = var.error_page
  }
}

# bucket used to redirect the root domain
resource "aws_s3_bucket" "root_domain_redirect_bucket" {
  bucket = var.root_domain_name
  acl = "public-read"
  policy = data.aws_iam_policy_document.policy_document_for_redirect_root_domain.json

  website {
    # redirect only
    redirect_all_requests_to = "https://www.${var.root_domain_name}"
  }
}
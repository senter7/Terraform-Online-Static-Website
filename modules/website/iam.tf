data "aws_iam_policy_document" "policy_document" {
  statement {
    sid = "GetObject"
    effect = "Allow"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::www.${var.root_domain_name}/*"
    ]

    principals {
      identifiers = ["*"]
      type = "AWS"
    }
  }

}

data "aws_iam_policy_document" "policy_document_for_redirect_root_domain" {
  statement {
    sid = "Redirect"
    effect = "Allow"

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "arn:aws:s3:::${var.root_domain_name}/*"
    ]

    principals {
      identifiers = ["*"]
      type = "AWS"
    }
  }
}
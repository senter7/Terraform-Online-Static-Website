data "aws_iam_policy_document" "policy_document" {
  statement {
    sid = "GetObject"
    effect = "Allow"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::www.${var.root_domain_name}/*",
    ]

    principals {
      identifiers = ["*"]
      type = "AWS"
    }
  }

}
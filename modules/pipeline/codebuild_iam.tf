data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "codebuild_policy_document" {
  statement {
    effect = "Allow"
    resources = [
      "*"
    ]
    actions = [
      "logs:*",
      "events:*"
    ]
  }

  statement {
    effect = "Allow"
    resources = [
      aws_s3_bucket.codepipeline_bucket.arn,
      "${aws_s3_bucket.codepipeline_bucket.arn}/*",
      "arn:aws:s3:::${var.bucket_website}",
      "arn:aws:s3:::${var.bucket_website}/*"
    ]
    actions = [
      "s3:*"
    ]
  }
}

data "aws_iam_policy_document" "cloudfront_for_codebuild_policy_document" {
  count = var.cloudfront_integration ? 1 : 0

  statement {
    effect = "Allow"
    resources = [
      "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${var.cloudfront_distribution_id}"
    ]
    actions = [
      "cloudfront:CreateInvalidation",
      "cloudfront:GetInvalidation",
      "cloudfront:ListInvalidations"
    ]
  }
}

data "aws_iam_policy_document" "codebuild_role_document" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      identifiers = ["codebuild.amazonaws.com"]
      type = "Service"
    }
  }
}

resource "aws_iam_role" "codebuild_role" {
  name               = "codebuild-${var.app_name}-${var.github_repository_branch}-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild_role_document.json
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name   = "codebuild-${var.app_name}-${var.github_repository_branch}-policy"
  role   = aws_iam_role.codebuild_role.id
  policy = data.aws_iam_policy_document.codebuild_policy_document.json
}

resource "aws_iam_role_policy" "cloudfront_for_codebuild_policy" {
  count = var.cloudfront_integration ? 1 : 0

  name = "cloudfront-for-codebuild-${var.app_name}-${var.github_repository_branch}-policy"
  role = aws_iam_role.codebuild_role.id
  policy = data.aws_iam_policy_document.cloudfront_for_codebuild_policy_document[0].json

}

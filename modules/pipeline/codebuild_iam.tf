data "aws_iam_policy_document" "codebuild_policy_document" {
  statement {
    effect = "Allow"
    resources = [
      "*"
    ]
    actions = [
      "logs:*",
      "events:*",
      "s3:*",
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

resource "aws_iam_role" "codepipeline_role" {
  name               = "codepipeline-${var.app_name}-${var.github_repository_branch}-role"
  assume_role_policy = file("${path.module}/assets/codepipeline_role.json")
}

data "template_file" "codepipeline_policy" {
  template = file("${path.module}/assets/codepipeline_policy.json")
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "codepipeline-${var.app_name}-${var.github_repository_branch}-policy"
  role   = aws_iam_role.codepipeline_role.id
  policy = data.template_file.codepipeline_policy.rendered
}

resource "aws_iam_role" "codebuild_role" {
  name               = "codebuild-${var.app_name}-${var.github_repository_branch}-role"
  assume_role_policy = file("${path.module}/assets/codebuild_role.json")
}

data "template_file" "codebuild_policy" {
  template = file("${path.module}/assets/codebuild_policy.json")
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name   = "codebuild-${var.app_name}-${var.github_repository_branch}-policy"
  role   = aws_iam_role.codebuild_role.id
  policy = data.template_file.codebuild_policy.rendered
}
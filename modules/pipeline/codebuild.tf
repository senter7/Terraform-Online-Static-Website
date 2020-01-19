data "template_file" "site_buildspec" {
  template = file("${path.module}/assets/buildspec.yml")

  vars = {
    bucket_name       = var.bucket_website
    distribuition_id  = var.cloudfront_distribution_id
    hugo_version = "0.62.2"
  }
}

resource "aws_codebuild_project" "site_build" {
  name          = "${var.app_name}-${var.github_repository_branch}-codebuild"
  build_timeout = "80"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"

    //https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html
    image           = "aws/codebuild/nodejs:8.11.0"
    type            = "LINUX_CONTAINER"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = data.template_file.site_buildspec.rendered
  }

}
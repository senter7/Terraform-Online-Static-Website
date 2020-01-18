resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "${var.app_name}-codepipeline-artifact-bucket"
  acl    = "private"
  force_destroy = true
}
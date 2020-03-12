variable "app_name" {
  type = string
}

variable "github_repository_branch" {
  type = string
}

variable "github_repository_owner" {
  type = string
}

variable "github_repository_name" {
  type = string
}

variable "github_token" {
  type = string
}

variable "bucket_website" {
  type = string
}

variable "cloudfront_distribution_id" {
  type = string
}

variable "buildspec_relative_path" {
  type = string
}

variable "cloudfront_integration" {
  description = "True if codebuild needs cloudfront permission"
  default = false
  type = bool
}
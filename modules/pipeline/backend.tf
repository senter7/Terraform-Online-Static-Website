provider "github" {
  token         = var.github_token
  owner         = var.github_repository_owner
}

# workaround for 'terraform validate' issue (https://github.com/hashicorp/terraform/issues/21790)
provider "aws" {
  region  = "eu-west-1"
}
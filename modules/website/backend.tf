provider "aws" {
  alias = "virginia"
  region = "us-east-1"
}

# workaround for 'terraform validate' issue (https://github.com/hashicorp/terraform/issues/21790)
provider "aws" {
  region  = "eu-west-1"
}

provider "null" {
}


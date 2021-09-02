data "aws_ssm_parameter" "github_token" {
  name = var.ssm_github_token
}

module "pipeline" {
  source                     = "../modules/pipeline"
  app_name                   = var.app_name
  bucket_website             = "www.${var.root_domain_name}"
  buildspec_relative_path    = "assets/fe-buildspec.yml"
  cloudfront_distribution_id = module.website.cloudfront_distribution_id
  github_repository_branch   = var.github_repository_branch
  github_repository_name     = var.github_fe_repository_name
  github_repository_owner    = var.github_repository_owner
  github_token               = data.aws_ssm_parameter.github_token.value
  cloudfront_integration     = true # only if codebuild requires cloudfornt access
}

module "website" {
  source                    = "../modules/website"
  region                    = var.region
  root_domain_name          = var.root_domain_name
  subject_alternative_names = var.subject_alternative_names
  hosted_zone_id            = var.hosted_zone_id
}
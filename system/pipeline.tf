module "pipeline" {
  source = "../modules/pipeline"
  app_name = "online-cv"
  bucket_website = "www.${var.root_domain_name}"
  cloudfront_distribution_id = module.website.cloudfront_distribution_id
  github_repository_branch = "master"
  github_repository_name = "Online-CV"
  github_repository_owner = "senter7"
  github_token = var.github_token
  github_username = var.github_username
  region = var.region
}
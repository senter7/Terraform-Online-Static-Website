module "website" {
  source = "../modules/website"
  region = var.region
  root_domain_name = var.root_domain_name
  subject_alternative_names = var.subject_alternative_names
  hosted_zone_id = var.hosted_zone_id
}
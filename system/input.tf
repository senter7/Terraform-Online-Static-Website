variable "region" {
  type = string
}

variable "root_domain_name" {
  type = string
}

variable "subject_alternative_names" {
  type = list(string)
}

variable "hosted_zone_id" {
  type = string
}

variable "github_token" {
  type = string
}

variable "github_username" {
  type = string
}

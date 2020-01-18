variable "region" {
  type = string
}

variable "root_domain_name" {
  type = string
}

variable "index_page" {
  type = string
  default = "index.html"
}

variable "error_page" {
  type = string
  default = "404.html"
}

variable "cloudfront_min_ttl" {
  type = string
  default = 0
}

variable "cloudfront_default_ttl" {
  type = string
  default = 86400
}

variable "cloudfront_max_ttl" {
  type = string
  default = 31536000
}

variable "subject_alternative_names" {
  type = list(string)
}

variable "hosted_zone_id" {
  type = string
  default = ""
}

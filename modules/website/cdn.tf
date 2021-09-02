resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "Cloudfront OAI"
}

resource "aws_cloudfront_distribution" "cdn" {
  origin {
//    custom_origin_config {
//      http_port              = "80"
//      https_port             = "443"
//      origin_protocol_policy = "http-only"
//      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
//    }
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }

    domain_name = aws_s3_bucket.bucket.bucket_regional_domain_name //www.8bitof.me.s3.eu-west-1.amazonaws.com
    origin_id   = "www.${var.root_domain_name}"
  }

  enabled             = true
  default_root_object = var.index_page

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "www.${var.root_domain_name}"
    min_ttl                = var.cloudfront_min_ttl
    default_ttl            = var.cloudfront_default_ttl
    max_ttl                = var.cloudfront_max_ttl

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  aliases = ["www.${var.root_domain_name}", var.root_domain_name]

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate_validation.cert_validation.certificate_arn
    ssl_support_method  = "sni-only"
  }
}
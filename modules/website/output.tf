output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.cdn.id
}

output "bucket_website" {
  value = aws_s3_bucket.bucket
}
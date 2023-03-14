# AWS CloudFront Distribution 생성
resource "aws_cloudfront_distribution" "web_distribution" {
  origin {
    domain_name = aws_lb.web_lb.dns_name
    origin_id   = aws_lb.web_lb.dns_name

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Web distribution"
  default_root_object = "index.html"

  # CloudFront에 연결할 SSL 인증서 ARN
  viewer_certificate {
    acm_certificate_arn = "arn:aws:acm:${var.aws_region}:881855020500:certificate/8adaf04e-0de8-4078-8bd6-3b4b29da2680"
    ssl_support_method  = "sni-only"
  }
  # ALB의 DNS 이름을 CNAME으로 등록
  aliases = ["www.${var.zone_name}", "aws.${var.zone_name}"]


  # HTTP 요청을 HTTPS로 리디렉션합니다.
  default_cache_behavior {
    cache_policy_id  = var.cache_policy_id
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_lb.web_lb.dns_name
    compress         = true

    viewer_protocol_policy = "allow-all" //http로 들어오면 https로 바꿔 cloudfront의 인증서로 처리함

    # 기존 생성된 policy를 사용하므로 설정 안함
    # min_ttl                = 0
    # default_ttl            = 3600
    # max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = "Production"
  }
}


# AWS CloudFront Distribution 생성
resource "aws_cloudfront_distribution" "s3_distribution" {
  comment = "S3 distribution"
  aliases = ["s3.flower53.site"]

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cache_policy_id        = var.cache_policy_id
    cached_methods         = ["GET", "HEAD"]
    compress               = "true"
    default_ttl            = "0"
    max_ttl                = "0"
    min_ttl                = "0"
    smooth_streaming       = "false"
    target_origin_id       = "flower53-image-bucket.s3.${var.aws_region}.amazonaws.com"
    viewer_protocol_policy = "allow-all"
  }

  enabled         = "true"
  http_version    = "http2"
  is_ipv6_enabled = "true"

  origin {
    connection_attempts      = "3"
    connection_timeout       = "10"
    origin_access_control_id = "EBBPAGIEL19NX"
    domain_name              = "flower53-image-bucket.s3.${var.aws_region}.amazonaws.com"
    origin_id                = "flower53-image-bucket.s3.${var.aws_region}.amazonaws.com"
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  retain_on_delete = "false"

  viewer_certificate {
    acm_certificate_arn            = "arn:aws:acm:${var.aws_region}:881855020500:certificate/8adaf04e-0de8-4078-8bd6-3b4b29da2680"
    cloudfront_default_certificate = "false"
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }
}
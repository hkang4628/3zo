# Route53 설정 부분
# www.flower53.site weighted_routing
resource "aws_route53_record" "www_to_aws" {
  zone_id         = var.zone_id
  name            = "www.${var.zone_name}"
  type            = "A"
  health_check_id = aws_route53_health_check.www_aws_hc.id

  weighted_routing_policy {
    weight = 50
  }
  set_identifier = "aws"

  alias {
    name                   = aws_cloudfront_distribution.web_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.web_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

# aws.flower53.site
resource "aws_route53_record" "aws_to_aws" {
  zone_id = var.zone_id
  name    = "aws.${var.zone_name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.web_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.web_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}


# s3.flower53.site
resource "aws_route53_record" "s3_to_s3" {
  zone_id = var.zone_id
  name    = "s3.${var.zone_name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}


resource "aws_route53_health_check" "www_aws_hc" {
  fqdn              = aws_cloudfront_distribution.web_distribution.domain_name
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = "5"
  request_interval  = "30"

  tags = {
    Name = "aws-health-check"
  }
}


# IDC 부분
# www.flower53.site weighted_routing
resource "aws_route53_record" "www_to_idc" {
  zone_id         = var.zone_id
  name            = "www.${var.zone_name}"
  type            = "A"
  ttl             = 5
  health_check_id = aws_route53_health_check.www_idc_hc.id
  weighted_routing_policy {
    weight = 50
  }
  set_identifier = "idc"
  records        = ["111.67.218.43"]
  # records = [aws_route53_record.idc_to_ip.fqdn]
}

# idc.flower53.site
resource "aws_route53_record" "idc_to_idc" {
  zone_id = var.zone_id
  name    = "idc.${var.zone_name}"
  type    = "A"
  ttl     = 5

  records = ["111.67.218.43"]
  # records = [aws_route53_record.idc_to_ip.fqdn]
}

resource "aws_route53_health_check" "www_idc_hc" {
  ip_address        = "111.67.218.43"
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = "5"
  request_interval  = "30"

  tags = {
    Name = "idc-health-check"
  }
}



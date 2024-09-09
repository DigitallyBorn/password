# These DNS records need to be created for ACM certification verification
output "dns_validation_records" {
  value = {
    for dvo in aws_acm_certificate.api_gateway_cert.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }
}

output "certification_status" {
  value = aws_acm_certificate.api_gateway_cert.status
}

output "dns_records" {
  value = {
    name = "password.ricky-dev.com"
    value = aws_api_gateway_domain_name.custom_domain[0].cloudfront_domain_name
  }
}
# Create an ACM certificate for your custom domain
resource "aws_acm_certificate" "api_gateway_cert" {
  provider          = aws.us_east_1
  domain_name       = "password.ricky-dev.com"
  validation_method = "DNS"

  tags = {
    Name = "API Gateway Certificate for ${aws_api_gateway_rest_api.my_api.id}"
  }
}

# Custom domain for the API Gateway
resource "aws_api_gateway_domain_name" "custom_domain" {
  count           = aws_acm_certificate.api_gateway_cert.status == "ISSUED" ? 1 : 0
  domain_name     = "password.ricky-dev.com"
  certificate_arn = aws_acm_certificate.api_gateway_cert.arn
  security_policy = "TLS_1_2"
}

# Map the base path to the API Gateway deployment
resource "aws_api_gateway_base_path_mapping" "api_mapping" {
  count       = aws_acm_certificate.api_gateway_cert.status == "ISSUED" ? 1 : 0
  domain_name = aws_api_gateway_domain_name.custom_domain[0].domain_name
  api_id      = aws_api_gateway_rest_api.my_api.id
  stage_name  = "prod"
}

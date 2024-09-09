moved {
  from = aws_api_gateway_method.get_generate_password
  to = aws_api_gateway_method.get_root
}

# Create the REST API
resource "aws_api_gateway_rest_api" "my_api" {
  name        = "PasswordGenerator"
  description = "API Gateway to trigger Lambda function"
}

# Define the method (HTTP GET request for the resource)
resource "aws_api_gateway_method" "get_root" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_rest_api.my_api.root_resource_id
  http_method   = "GET"
  authorization = "NONE"
}

# Lambda integration with API Gateway
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.my_api.id
  resource_id             = aws_api_gateway_rest_api.my_api.root_resource_id
  http_method             = aws_api_gateway_method.get_root.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.generate_password.invoke_arn
}

# Give API Gateway permission to invoke the Lambda function
resource "aws_lambda_permission" "api_gateway_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.generate_password.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.my_api.execution_arn}/*/*"
}

# Deploy the API Gateway
resource "aws_api_gateway_deployment" "my_api_deployment" {
  depends_on  = [aws_api_gateway_integration.lambda_integration]
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  stage_name  = "prod"
}

resource "aws_lambda_function" "generate_password" {
  function_name = "generate_password"
  role          = aws_iam_role.generate_password_lambda_execution.arn

  filename         = "generate_password_source.zip"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  handler          = "main.lambda_handler"
  runtime          = "python3.12"
}

data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${path.module}/../lambda/src"
  output_path = "generate_password_source.zip"
}

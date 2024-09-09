data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "generate_password_policy" {
  statement {
    effect    = "Allow"
    actions   = ["logs:CreateLogGroup"]
    resources = ["arn:aws:logs:us-east-2:${data.aws_caller_identity.current.account_id}:*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:us-east-2:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/generate_password:*"]
  }
}

resource "aws_iam_role" "generate_password_lambda_execution" {
  name               = "generate_password-lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "generate_password_lambda_execution" {
  role   = aws_iam_role.generate_password_lambda_execution.name
  policy = data.aws_iam_policy_document.generate_password_policy.json
}

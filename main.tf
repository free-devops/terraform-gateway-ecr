locals {
  tags = merge(
    var.tags,
    map("maintainer", "terraform"),
    map("environment", var.env),
  )
  #lambda_resource = var.lambda_source == "local" ? aws_lambda_function.lambda_local : aws_lambda_function.lambda_s3
}

# GATEWAY
resource "aws_api_gateway_rest_api" "ecr_gw" {
  name        = var.name
  description = "Gateway for ECR"
}

resource "aws_api_gateway_resource" "ecr_gw" {
  rest_api_id = aws_api_gateway_rest_api.ecr_gw.id
  parent_id   = aws_api_gateway_rest_api.ecr_gw.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_authorizer" "lamda_auth" {
  name                   = var.name
  rest_api_id            = aws_api_gateway_rest_api.ecr_gw.id
  authorizer_uri         = aws_lambda_function.lambda.invoke_arn
  authorizer_credentials = aws_iam_role.invocation_role.arn
}

# LAMBDA
resource "aws_lambda_function" "lambda" {
  filename      = var.lambda_source == "local" ? var.lambda_zip : null
  function_name = var.fn_name
  role          = aws_iam_role.lambda.arn
  handler       = var.handler
  runtime       = var.runtime
  s3_bucket     = var.lambda_source == "s3" ? var.lambda_s3 : null
  s3_key        = var.lambda_source == "s3" ? var.lambda_zip : null
  source_code_hash = var.lambda_source == "local" ? filebase64sha256(var.lambda_zip) : null
}

resource "aws_iam_role" "invocation_role" {
  name = "api_gateway_auth_invocation"
  path = var.gw_path

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "invocation_policy" {
  name = var.name
  role = aws_iam_role.invocation_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "lambda:InvokeFunction",
      "Effect": "Allow",
      "Resource": "${aws_lambda_function.lambda.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role" "lambda" {
  name = var.name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# ECR
resource "aws_ecr_repository" "ecr" {
  count                = length(var.respositores)
  name                 = var.respositores[count.index]
  image_tag_mutability = var.env == "prod" ? "MUTABLE" : "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = var.scan
  }

  tags = local.tags

}

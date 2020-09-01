output "ecr_arn" {
  value = {
    for repo in aws_ecr_repository.ecr:
    repo.id => repo.arn
  }
}

output "lambda_arn" {
  value = aws_lambda_function.lambda.arn
}

output "lambda_invoke_arn" {
  value = aws_lambda_function.lambda.invoke_arn
}

output "invoke_role_arn" {
  value = aws_iam_role.lambda.arn
}

output "gateway_arn" {
  value = aws_api_gateway_resource.ecr_gw
}

output "gateway_root_id" {
  value = aws_api_gateway_resource.ecr_gw.root_resource_id
}

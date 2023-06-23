output "store_api_role" {
  value = aws_iam_role.store_api_oidc.arn
}

output "external_secrets_role" {
  value = aws_iam_role.external_secrets_oidc.arn
}


output "username" {
  value     = split(",", data.aws_ssm_parameter.es.value)[0]
  sensitive = true
}

output "password" {
  value     = split(",", data.aws_ssm_parameter.es.value)[1]
  sensitive = true
}

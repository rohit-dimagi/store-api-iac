output "store_api_role" {
  value = aws_iam_role.store_api_oidc.arn
}

output "external_secrets_role" {
  value = aws_iam_role.external_secrets_oidc.arn
}



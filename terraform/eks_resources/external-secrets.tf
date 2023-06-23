resource "helm_release" "external-secrets" {
  name             = "external-secrets"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  version          = "0.9.0"
  create_namespace = true
  namespace        = "external-secrets"

  values = [templatefile("${path.module}/external-secrets-values.yaml", {
    SERVICE_ACCOUNT = aws_iam_role.external_secrets_oidc.name
    ROLE_ARN        = aws_iam_role.external_secrets_oidc.arn
  })]
}
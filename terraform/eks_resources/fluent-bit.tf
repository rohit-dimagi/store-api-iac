# resource "elasticsearch_opensearch_role" "writer" {
#   role_name   = "logs_writer"
#   description = "Logs writer role"

#   cluster_permissions = ["*"]

#   index_permissions {
#     index_patterns  = ["*"]
#     allowed_actions = ["write"]
#   }

#   tenant_permissions {
#     tenant_patterns = ["*"]
#     allowed_actions = ["kibana_all_write"]
#   }
# }

# resource "elasticsearch_opensearch_roles_mapping" "mapper" {
#   role_name     = "logs_writer"
#   description   = "Mapping AWS IAM roles to ES role"
#   backend_roles = [aws_iam_role.fluent_bit_oidc.arn]
# }


resource "helm_release" "fluent-bit" {
  name             = "fluent-bit"
  repository       = "https://fluent.github.io/helm-charts"
  chart            = "fluent-bit"
  version          = "0.30.3"
  create_namespace = true
  namespace        = "fluent-bit"

  values = [templatefile("${path.module}/fluent-bit-values.yaml", {
    SERVICE_ACCOUNT     = aws_iam_role.fluent_bit_oidc.name
    ROLE_ARN            = aws_iam_role.fluent_bit_oidc.arn
    AWS_REGION          = var.region
    ES_CLUSTER_ENDPOINT = var.opensearch_endpoint
  })]
}
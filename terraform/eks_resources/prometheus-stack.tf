
resource "helm_release" "prometheus" {
  name             = "promethues-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "47.0.0"
  create_namespace = true
  namespace        = "prometheus"

}
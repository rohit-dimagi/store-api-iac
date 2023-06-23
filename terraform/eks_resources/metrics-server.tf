
resource "helm_release" "metrics" {
  name             = "metrics-server"
  repository       = "https://kubernetes-sigs.github.io/metrics-server/"
  chart            = "metrics-server"
  version          = "3.10.0"
  create_namespace = true
  namespace        = "metrics-server"

}
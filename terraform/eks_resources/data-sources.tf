data "tls_certificate" "eks" {
  url = var.eks_cluster_oidc_issuer
}

data "aws_eks_cluster_auth" "this" {
  name = var.eks_cluster_name
}

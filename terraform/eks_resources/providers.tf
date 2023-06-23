provider "helm" {
  kubernetes {
    host                   = var.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(var.eks_ca_certificate)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}
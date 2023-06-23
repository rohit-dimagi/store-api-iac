module "eks" {
  source = "./eks"

  region                   = "ap-south-1"
  availability_zones_count = 2

  project = "demo"

  vpc_cidr         = "10.0.0.0/16"
  subnet_cidr_bits = 8
  eks_version      = "1.27"
  eks_cluster_name = "demo"
}

module "eks_resources" {
  source = "./eks_resources"

  region                  = "ap-south-1"
  eks_cluster_name        = "demo-cluster"
  eks_cluster_endpoint    = module.eks.cluster_endpoint
  eks_ca_certificate      = module.eks.cluster_ca_certificate
  eks_cluster_oidc_issuer = module.eks.cluster_oidc_issuer
  opensearch_endpoint     = module.eks.opensearch_endpoint
}
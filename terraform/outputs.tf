output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_ca_certificate" {
  value = module.eks.cluster_ca_certificate
}

output "cluster_oidc_issuer" {
  value = module.eks.cluster_oidc_issuer
}

output "opensearch_endpoint" {
  value = module.eks.opensearch_endpoint
}

output "ecr_url" {
  value = module.eks.ecr_url
}
output "store_api_role" {
  value = module.eks_resources.store_api_role
}
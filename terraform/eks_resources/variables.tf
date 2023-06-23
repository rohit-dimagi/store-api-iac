variable "region" {
  description = "The aws region."
  type        = string
  default     = "ap-south-1"
}

variable "eks_cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
}

variable "eks_cluster_endpoint" {
  type        = string
  description = "EKS Cluster Endpoint"
}

variable "eks_ca_certificate" {
  type        = string
  description = "EKS Cluster CA Certificate"
}

variable "eks_cluster_oidc_issuer" {
  type        = string
  description = "EKS Cluster OIDC URL"
}

variable "opensearch_endpoint" {
  type        = string
  description = "OpenSearch Endpoint for Fluent-Bit"
}

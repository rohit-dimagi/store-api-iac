terraform {
  required_providers {
    elasticsearch = {
      source  = "phillbaker/elasticsearch"
      version = "2.0.7"
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = var.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(var.eks_ca_certificate)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

# provider "elasticsearch" {
#   url = var.opensearch_endpoint
#   username = "${split(",", data.aws_ssm_parameter.es.value)[0]}"
#   password = "${split(",", data.aws_ssm_parameter.es.value)[1]}"
#   healthcheck = false
# }

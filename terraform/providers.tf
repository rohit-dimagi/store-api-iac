terraform {
  required_version = ">= 1.4.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.4.0"
    }
    elasticsearch = {
      source  = "phillbaker/elasticsearch"
      version = "2.0.7"
    }
  }
}

provider "aws" {
  region = var.region
}

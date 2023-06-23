terraform {
  backend "s3" {
    bucket         = "terraform-demo-assist"
    dynamodb_table = "terraform-demo-assist"
    key            = "terraform-aws-eks-demo.tfstate"
    region         = "ap-south-1"
    encrypt        = true
  }
}

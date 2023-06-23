# store-api-iac
This project is being used to spin up AWS resource for Store-api service and deploy store-api service.

# Tools 
* AWS
* TERRAFORM(1.5.0)
* PYTHON

# RESOURCES CREATED
 INFRA
* VPC
* EKS
* SECRET-MANAGER
* OPENSEARCH
* IRSA

EKS RESOURCES
* FLUENT-BIT
* EXTERNAL-SECRETS
* METRICS-SERVER
* PROMETHEUS-STACK
* POSTGRESQL
* STORE-API 
* NLB

# prequiste
* aws access key and secret key with admin access configured and aws cli, kubectl tool installed on the system
* s3 bucket for storing state file 
* dynamodb for locking
* A Jenkins CI setup with access to ecr, and docker, python and git install

# Running locally

Build Infra for AWS
```
$ cd terraform
$ terraform apply
```
Deploy K8S resources
```
# Get the kube-config
$ aws eks update-kubeconfig --region ap-south-1 --name demo-cluster
$ kubectl apply -f k8s/postgresql/
$ kubectl apply -f k8s/store-api/
```
Get the DNS of LoadBalancer and open in Browser.

## Helper script

This repo also contains a helper script `transit/main.py` which should be run as a cronjob in CI tool, it monitor new update in ECR and pushes it to deployment.yaml

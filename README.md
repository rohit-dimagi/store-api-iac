# store-api-iac
This project is being used to spin up AWS resource for [Store-api](https://github.com/rohit-dimagi/store-api-iac) service and deploy store-api service.

### Tools
* AWS
* Terraform(1.5.0)
* Python3

### Resource Created
 Infra :-
* VPC
* EKS
* Secret-Manager
* Opensearch
* IRSA

EKS Resources :-
* Fluent-Bit
* External-secrets
* Metrics-server
* Prometheus-stack
* EBS CSI Driver
* Postgresql
* Store-api
* Network LoadBalancer

### Prerequisite
* aws access key and secret key with admin access configured and aws cli, kubectl tool installed on the system
* s3 bucket for storing state file
* dynamodb for locking
* A Jenkins CI setup with access to ecr, docker, python, kubectl aws-cli and git install

### Running locally
Since the EKS cluster is private, you need to have VPN or a bastion host configured to run this project. In this case my Jenkins-CI server is also a bastion.

Build Infra for AWS

```
$ cd terraform
$ terraform init
$ terraform apply
```

Deploy K8S resources

```
# Get the kube-config
$ aws eks update-kubeconfig --region ap-south-1 --name demo-cluster
$ kubectl apply -f k8s/postgresql/
$ kubectl apply -f k8s/store-api/
```
Get the DNS of Network LoadBalancer and open in Browser.

### Helper script

This repo also contains a helper script `transit/main.py` which should be run as a cronjob in CI tool, it monitor new update in ECR and pushes it to deployment.yaml. Github Access Token is required to run this script.

### Jenkins Pipeline
It Contains Jenkins pipeline file to apply terraform and k8s changes to the environment. Every push triggers a pipeline to jenkins with Github-webhook. The pipeline does need approval for applying after producing plan.


### Architecture Diagram

![Architecture](./docs/Arch.png?raw=true "Architecture")

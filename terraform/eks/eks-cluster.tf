# EKS Cluster
resource "aws_eks_cluster" "this" {
  name     = "${var.project}-cluster"
  role_arn = aws_iam_role.cluster.arn
  version  = var.eks_version

  vpc_config {
    subnet_ids              = flatten([aws_subnet.public[*].id, aws_subnet.private[*].id])
    endpoint_private_access = true
    endpoint_public_access  = false
    security_group_ids      = [aws_security_group.eks_cluster_additional.id]

  }

  tags = merge(
    var.tags
  )

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy
  ]
}


# EKS Cluster IAM Role
resource "aws_iam_role" "cluster" {
  name = "${var.project}-Cluster-Role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}


# EKS Cluster Security Group
resource "aws_security_group" "eks_cluster" {
  name        = "${var.project}-cluster-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "${var.project}-cluster-sg"
  }
}

resource "aws_security_group_rule" "cluster_inbound" {
  description              = "Allow worker nodes to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster_outbound" {
  description              = "Allow cluster API Server to communicate with the worker nodes"
  from_port                = 1024
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 65535
  type                     = "egress"
}

resource "aws_security_group" "eks_cluster_additional" {
  name        = "${var.project}-eks-cluster"
  description = "Cluster SG"
  vpc_id      = aws_vpc.this.id

  ingress = [
    {
      description      = "Allow API Access"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = [var.vpc_cidr]
      prefix_list_ids  = null
      ipv6_cidr_blocks = null
      security_groups  = null
      self             = null
    },
    {
      description      = "Allow Kubelet API Access"
      from_port        = 10250
      to_port          = 10250
      protocol         = "tcp"
      cidr_blocks      = [var.vpc_cidr]
      prefix_list_ids  = null
      ipv6_cidr_blocks = null
      security_groups  = null
      self             = null
    },
    {
      description      = "Allow Cluster Access"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = null
      prefix_list_ids  = null
      ipv6_cidr_blocks = null
      security_groups  = null
      self             = true
    }
  ]


  tags = {
    Name        = "${var.project}-eks-cluster"
    Description = "Cluster SG"
  }
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = var.eks_cluster_oidc_issuer
}


# store-api OIDC
data "aws_iam_policy_document" "store_api_oidc_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:default:store-api-oidc"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "store_api_oidc" {
  assume_role_policy = data.aws_iam_policy_document.store_api_oidc_assume_role_policy.json
  name               = "store-api-oidc"
}

resource "aws_iam_policy" "store_api_policy" {
  name = "store-api-policy"

  policy = jsonencode({
    Statement = [{
      Action = [
        "s3:ListAllMyBuckets",
        "s3:GetBucketLocation"
      ]
      Effect   = "Allow"
      Resource = "arn:aws:s3:::*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "store_api_attach" {
  role       = aws_iam_role.store_api_oidc.name
  policy_arn = aws_iam_policy.store_api_policy.arn
}


# external-secrets OIDC
data "aws_iam_policy_document" "external_secrets_oidc_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:external-secrets:external-secrets-oidc"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "external_secrets_oidc" {
  assume_role_policy = data.aws_iam_policy_document.external_secrets_oidc_assume_role_policy.json
  name               = "external-secrets-oidc"
}

resource "aws_iam_policy" "external_secrets_policy" {
  name = "external-secrets-policy"

  policy = jsonencode({
    Statement = [{
      Action = [
        "secretsmanager:GetResourcePolicy",
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret",
        "secretsmanager:ListSecretVersionIds"
      ]
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "external_secrets_attach" {
  role       = aws_iam_role.external_secrets_oidc.name
  policy_arn = aws_iam_policy.external_secrets_policy.arn
}


# fluent-bit OIDC
data "aws_iam_policy_document" "fluent_bit_oidc_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:fluent-bit:fluent-bit-oidc"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "fluent_bit_oidc" {
  assume_role_policy = data.aws_iam_policy_document.fluent_bit_oidc_assume_role_policy.json
  name               = "fluent-bit-oidc"
}

resource "aws_iam_policy" "fluent_bit_policy" {
  name = "fluent-bit-policy"

  policy = jsonencode({
    Statement = [{
      Action   = ["es:*"]
      Effect   = "Allow"
      Resource = "*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "fluent_bit_attach" {
  role       = aws_iam_role.fluent_bit_oidc.name
  policy_arn = aws_iam_policy.fluent_bit_policy.arn
}



# resource "aws_iam_role" "fluent_bit" {
#   name = "fluent-bit"

#   assume_role_policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "eks.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     },
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Federated": "${aws_iam_openid_connect_provider.eks.arn}"
#       },
#       "Action": "sts:AssumeRoleWithWebIdentity",
#       "Condition": {
#         "StringEquals": {
#           "oidc.eks.${var.region}.amazonaws.com/id/${data.tls_certificate.eks.certificates[0].sha1_fingerprint}:aud": "sts.amazonaws.com"
#         }
#       }
#     }
#   ]
# }
# POLICY
# }
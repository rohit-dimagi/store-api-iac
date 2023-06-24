resource "random_password" "password" {
  length  = 16
  special = false
}

resource "aws_secretsmanager_secret" "db_secrets" {
  name = "store-api-db-secrets"

  tags = merge(
    var.tags
  )
}

resource "aws_secretsmanager_secret_version" "db_secrets" {
  secret_id     = aws_secretsmanager_secret.db_secrets.id
  secret_string = jsonencode(merge(tomap({ POSTGRES_PASSWORD = random_password.password.result }), var.db_secrets, ))
}

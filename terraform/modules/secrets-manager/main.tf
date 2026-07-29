resource "random_password" "db_password" {
  length           = 20
  special          = true
  override_special = "!@#$%^&*()-_=+[]{}<>?"
}

resource "aws_secretsmanager_secret" "this" {
  name        = var.secret_name
  description = var.description

  kms_key_id = var.kms_key_id

  tags = local.common_tags
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id = aws_secretsmanager_secret.this.id

  secret_string = jsonencode({
  username = var.db_username
  password = random_password.db_password.result
  database = var.db_name
  port     = var.db_port
})
}
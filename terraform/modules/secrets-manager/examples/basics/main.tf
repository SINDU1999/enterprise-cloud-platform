provider "aws" {
  region = "ap-south-1"
}


module "secrets_manager" {
  source = "../../"

  environment = "dev"

  secret_name = "enterprise-db"

  description = "Enterprise database credentials"

  kms_key_id = "arn:aws:kms:ap-south-1:908209635299:key/a12ae3fa-7a8a-4dc3-ae67-55259082d641"
}

output "secret_arn" {
  value = module.secrets_manager.secret_arn
}
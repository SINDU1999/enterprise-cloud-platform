module "kms" {
  source = "../../"

  environment = "dev"
  key_alias   = "enterprise-platform"
}
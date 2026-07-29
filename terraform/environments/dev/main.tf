module "vpc" {

  source = "../../modules/vpc"

  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr

  public_subnet_1_cidr = var.public_subnet_1_cidr
  public_subnet_2_cidr = var.public_subnet_2_cidr

  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr

  availability_zone_1 = var.availability_zone_1
  availability_zone_2 = var.availability_zone_2
}

module "security_groups" {

  source = "../../modules/security-groups"

  vpc_id       = module.vpc.vpc_id
  project_name = var.project_name
  environment  = var.environment
}

module "iam" {

  source = "../../modules/iam"

  project_name = var.project_name
  project_code = var.project_code
  environment  = var.environment
}

module "eks" {

  source = "../../modules/eks"

  project_name = var.project_name
  project_code = var.project_code
  environment  = var.environment

  cluster_role_arn = module.iam.eks_cluster_role_arn
  node_role_arn    = module.iam.eks_node_role_arn

  private_subnet_ids        = module.vpc.private_subnet_ids
  cluster_security_group_id = module.security_groups.eks_cluster_security_group_id

  node_instance_type = var.node_instance_type
  desired_size       = var.desired_size
  min_size           = var.min_size
  max_size           = var.max_size
  disk_size          = var.disk_size
}

####################################################
# KMS
####################################################

module "kms" {

  source = "../../modules/kms"

  environment = var.environment

  key_alias = var.key_alias
}

####################################################
# Secrets Manager
####################################################

module "secrets_manager" {

  source = "../../modules/secrets-manager"

  environment = var.environment

  secret_name = var.secret_name

  kms_key_id = module.kms.kms_key_arn

  db_username = var.db_username
  db_name     = var.db_name
  db_port     = var.db_port
}

####################################################
# RDS
####################################################

module "rds" {

  source = "../../modules/rds"

  environment = var.environment

  db_identifier = var.db_identifier
  db_name       = var.db_name

  instance_class    = var.instance_class
  engine_version    = var.engine_version
  allocated_storage = var.allocated_storage

  kms_key_id = module.kms.kms_key_arn

  secret_arn = module.secrets_manager.secret_arn

  subnet_ids = module.vpc.private_subnet_ids

  security_group_ids = [
    module.security_groups.rds_security_group_id
  ]
}

####################################################
# CloudWatch
####################################################

module "cloudwatch" {

  source = "../../modules/cloudwatch"

  project_name = var.project_name
  environment  = var.environment

  log_group_name = var.log_group_name

  alarm_name_prefix = var.alarm_name_prefix

  cpu_utilization_threshold = var.cpu_utilization_threshold

  instance_id = var.instance_id
}

####################################################
# Route53
####################################################

module "route53" {

  source = "../../modules/route53"

  project_name = var.project_name
  environment  = var.environment

  zone_name = var.zone_name

  vpc_id = module.vpc.vpc_id

  create_private_zone = var.create_private_zone

  record_name = var.record_name
  record_type = var.record_type
  record_ttl  = var.record_ttl

  record_value = var.record_value
}
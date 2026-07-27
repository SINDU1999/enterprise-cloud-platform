resource "aws_eks_cluster" "this" {

  name     = "${var.project_code}-${var.environment}-eks-cluster"
  role_arn = var.cluster_role_arn

  version = "1.33"

  vpc_config {

    subnet_ids = var.private_subnet_ids

    security_group_ids = [
      var.cluster_security_group_id
    ]

    endpoint_private_access = true
    endpoint_public_access  = true
  }

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  tags = {
    Name        = "${var.project_name}-${var.environment}-eks-cluster"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

################################################################################
# EKS Managed Node Group
################################################################################

resource "aws_eks_node_group" "this" {

  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.project_code}-${var.environment}-node-group"

  node_role_arn = var.node_role_arn

  subnet_ids = var.private_subnet_ids

  scaling_config {

    desired_size = 2
    min_size     = 2
    max_size     = 4
  }

  instance_types = [
    var.node_instance_type
  ]

  disk_size = var.disk_size

  capacity_type = "ON_DEMAND"

  ami_type = "AL2023_x86_64_STANDARD"

  update_config {
    max_unavailable = 1
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-node-group"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

  depends_on = [
    aws_eks_cluster.this
  ]
}
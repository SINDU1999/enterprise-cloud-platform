resource "aws_security_group" "alb" {

  name        = "${var.project_name}-${var.environment}-alb-sg"
  description = "Security Group for Application Load Balancer"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP from Internet"

    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS from Internet"

    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-alb-sg"
  }
}

resource "aws_security_group" "eks_cluster" {

  name        = "${var.project_name}-${var.environment}-eks-cluster-sg"
  description = "Security Group for Amazon EKS Control Plane"
  vpc_id      = var.vpc_id

  egress {
    description = "Allow all outbound traffic"

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-eks-cluster-sg"
  }
}

resource "aws_security_group" "eks_nodes" {

  name        = "${var.project_name}-${var.environment}-eks-node-sg"
  description = "Security Group for Amazon EKS Worker Nodes"
  vpc_id      = var.vpc_id

  egress {
    description = "Allow all outbound traffic"

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-eks-node-sg"
  }
}

###############################################################################
# Security Group Rules
###############################################################################

# Allow HTTP traffic from ALB to EKS Worker Nodes
resource "aws_security_group_rule" "alb_to_nodes_http" {

  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"

  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.alb.id

  description = "Allow HTTP traffic from ALB to EKS Worker Nodes"
}

# Allow Worker Nodes to communicate with EKS Control Plane
resource "aws_security_group_rule" "nodes_to_cluster_https" {

  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"

  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id

  description = "Allow Worker Nodes to communicate with EKS Control Plane"
}

# Allow communication between Worker Nodes
resource "aws_security_group_rule" "node_to_node" {

  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"

  security_group_id = aws_security_group.eks_nodes.id
  self              = true

  description = "Allow communication between EKS Worker Nodes"
}
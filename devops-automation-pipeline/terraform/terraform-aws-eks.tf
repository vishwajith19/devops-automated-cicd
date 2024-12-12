provider "aws" {
  region = var.aws_region
}

# Create the EKS cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = var.eks_role_arn
  version  = "1.31"

  vpc_config {
    subnet_ids = var.subnet_ids
  }
}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [aws_eks_cluster.eks_cluster]
  create_duration = "30s"
}

# Get the EKS cluster's authentication details
data "aws_eks_cluster_auth" "eks_auth" {
  name = aws_eks_cluster.eks_cluster.name
}

# Set up the Kubernetes provider with the EKS cluster endpoint and auth details
provider "kubernetes" {
  host                   = aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.eks_auth.token
}

# Create the aws-auth ConfigMap to bind users or roles
resource "kubernetes_config_map" "aws_auth" {
  depends_on = [time_sleep.wait_30_seconds]

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = jsonencode(var.map_roles)
    mapUsers = jsonencode(var.map_users)
  }
}

# Create the EKS node group
resource "aws_eks_node_group" "node_group" {
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = var.node_group_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.scaling_config.desired_size
    max_size     = var.scaling_config.max_size
    min_size     = var.scaling_config.min_size
  }

  instance_types = var.instance_types

  update_config {
    max_unavailable = 1
  }

  depends_on = [kubernetes_config_map.aws_auth]
}
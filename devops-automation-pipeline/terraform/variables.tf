variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "ap-south-1"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "eks_role_arn" {
  description = "The IAM role ARN for the EKS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "node_group_role_arn" {
  description = "The IAM role ARN for the EKS node group"
  type        = string
}

variable "map_roles" {
  description = "Roles for aws-auth ConfigMap"
  type        = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
}

variable "map_users" {
  description = "Users for aws-auth ConfigMap"
  type        = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
}

variable "node_group_name" {
  description = "Name of the EKS node group"
  type        = string
}

variable "scaling_config" {
  description = "Scaling configuration for the node group"
  type = object({
    desired_size = number
    max_size     = number
    min_size     = number
  })
}

variable "instance_types" {
  description = "Instance types for the node group"
  type        = list(string)
  default     = ["t2.medium"]
}

aws_region = "ap-south-1"
cluster_name = "example-cluster"
eks_role_arn = "arn:aws:iam::123456789012:role/eks-cluster-role"
subnet_ids = [
  "subnet-abcdefgh12345678",
  "subnet-ijklmnop12345678",
  "subnet-qrstuvwx12345678"
]
node_group_role_arn = "arn:aws:iam::123456789012:role/eks-node-group-role"
map_roles = [
  {
    rolearn  = "arn:aws:iam::123456789012:role/eks-node-group-role"
    username = "system:node:{{EC2PrivateDNSName}}"
    groups   = ["system:bootstrappers", "system:nodes"]
  }
]
map_users = [
  {
    userarn  = "arn:aws:iam::123456789012:user/example-user"
    username = "example-user"
    groups   = ["system:masters"]
  }
]
node_group_name = "example-node-group"
scaling_config = {
  desired_size = 2
  max_size     = 3
  min_size     = 1
}
instance_types = ["t2.medium"]

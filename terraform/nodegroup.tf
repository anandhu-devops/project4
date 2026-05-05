resource "aws_eks_node_group" "nodes" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "nodes-final"
  node_role_arn   = aws_iam_role.node_role.arn

  subnet_ids = [
    "subnet-064f8ab6abfdc980a",
    "subnet-0b0be1654f88b43c7"
  ]

  instance_types = ["t3.medium"]

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }

  ami_type = "AL2023_x86_64_STANDARD"

  depends_on = [
    aws_iam_role_policy_attachment.worker_policy,
    aws_iam_role_policy_attachment.cni_policy,
    aws_iam_role_policy_attachment.ecr_policy
  ]
}
resource "aws_eks_cluster" "eks" {
  name     = "eks-cluster-final"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [
      "subnet-064f8ab6abfdc980a",
      "subnet-0b0be1654f88b43c7"
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy
  ]
}
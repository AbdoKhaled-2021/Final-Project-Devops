resource "aws_iam_role" "eks-cluster" {
  name = "eks-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}
# The above section defines the role and which service is allowed to assume it
# The below section binds the policy with its restrictions to the previously created role
resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster.name
}

resource "aws_eks_cluster" "project" {
  name     = "project"
  role_arn = aws_iam_role.eks-cluster.arn

  vpc_config {
    subnet_ids = [
      var.private-us-east-1a,
      var.private-us-east-1b,
      var.public-us-east-1a,
      var.public-us-east-1b
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.AmazonEKSClusterPolicy]
}


# Before you can create Amazon EKS clusters, you must create an IAM role with the AmazonEKSClusterPolicy, as it makes calls to other AWS services on your behalf to manage the resources that you use with the service
# In the vpc_config I specify the subnets in which the cluster can operate. That is why I added specific tags to the subnets that identify the behavior of the cluster in each subnet

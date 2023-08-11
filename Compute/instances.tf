#Create an IAM Policy
resource "aws_iam_policy" "jenkins-policy" {
  name        = "jenkins-policy"
  description = "A policy to give full access to ECR and read-only access on the EKS cluster"
# This is because an account must be able to list and describe clusters to use the update-kubeconfig AWS CLI command, which is required to connect with our clusters.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Effect = "Allow"
            Action = [
                "ecr:*",
                "cloudtrail:LookupEvents"
            ]
            Resource = "*"
        },
        {
            Effect = "Allow"
            Action = [
                "iam:CreateServiceLinkedRole"
            ]
            Resource = "*"
            Condition = {
                StringEquals = {
                    "iam:AWSServiceName": [
                        "replication.ecr.amazonaws.com"
                    ]
                }
            }
        },
	      {
            Effect = "Allow"
            Action = [
                "eks:DescribeCluster",
                "eks:ListClusters"
            ]
            Resource = "*"
        }
    ]
  })
}

#Create an IAM Role that is to be assumed by jenkins instance/ec2
resource "aws_iam_role" "jenkins-role" {
  name = "jenkins_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "RoleForEC2"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "role-policy-attachment" {
  name       = "role-policy-attachment"
  roles      = [aws_iam_role.jenkins-role.name]
  policy_arn = aws_iam_policy.jenkins-policy.arn
}

resource "aws_iam_instance_profile" "jenkins-profile" {
  name = "jenkins-profile"
  role = aws_iam_role.jenkins-role.name
}

resource "aws_instance" "Jenkins-instance" {
  # ami           = data.aws_ami.ubuntu.id
  ami           = "ami-005f9685cb30f234b"
  iam_instance_profile = aws_iam_instance_profile.jenkins-profile.name
  instance_type = var.instance-type
  subnet_id = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.Jenkins-SG.id]
  key_name = "Jenkins"
}

# As a summary I create a policy, then I create a role and indicate which service can assume it, then I attach the policy to the role, then create an instance profile indicating the role to be assumed by the instance then mention this profile in the instance resource creation 
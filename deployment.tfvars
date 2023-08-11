region="us-east-1"
cidr="10.0.0.0/16"
private-us-east-1a-cidr="10.0.1.0/24"
private-us-east-1b-cidr="10.0.2.0/24"
public-us-east-1a-cidr="10.0.3.0/24"
public-us-east-1b-cidr="10.0.4.0/24"
instance-type="t3.medium"
capacity_type = "ON_DEMAND"
ecr_name = ["python-app","mysql-db"]
tags = { "Environment" = "Project"}

# I can add more ecr_name values by simply use , "" and it would create ECR for each name
# That is how tags are injected into variables file
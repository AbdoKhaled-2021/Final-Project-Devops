module "Network"{
    source = "./Network"
    cidr = var.cidr
    private-us-east-1a-cidr = var.private-us-east-1a-cidr
    private-us-east-1b-cidr = var.private-us-east-1b-cidr
    public-us-east-1a-cidr = var.public-us-east-1a-cidr
    public-us-east-1b-cidr = var.public-us-east-1b-cidr
}

module "Compute"{
    source = "./Compute"
    instance-type = var.instance-type
    vpc_id = module.Network.myvpc-id
    public_subnet_id = module.Network.public-us-east-1a-id
}

module "EKS"{
    source = "./EKS"
    instance_types = var.instance-type
    capacity_type = var.capacity_type
    private-us-east-1a = module.Network.private-us-east-1a-id
    private-us-east-1b = module.Network.private-us-east-1b-id
    public-us-east-1a = module.Network.public-us-east-1a-id
    public-us-east-1b = module.Network.public-us-east-1b-id
}

module "ECR"{
    source = "./ECR"
    ecr_name = var.ecr_name
    tags = var.tags
}


# Refrences:
# https://antonputra.com/terraform/how-to-create-eks-cluster-using-terraform/
# 
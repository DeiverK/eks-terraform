module vpc {
    source = "terraform-aws-modules/vpc/aws"
    version = "3.14.2"
    name = "Demo-VPC"
    cidr = "10.0.0.0/16"
    azs = data.aws_availability_zones.available.names
    private_subnets = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
    public_subnets =  ["10.0.110.0/24", "10.0.120.0/24", "10.0.130.0/24"]
    intra_subnets   = ["10.0.7.0/28", "10.0.7.16/28", "10.0.7.32/28"]

    enable_nat_gateway = true
    single_nat_gateway = true
    enable_dns_hostnames = true
    
    tags = {
        "Name" = "Demo-VPC"
    }
    public_subnet_tags = {
        "Name" = "Demo-Public-Subnet"
    }
    private_subnet_tags = {
        "Name" = "Demo-Private-Subnet"
    }
}

resource "aws_security_group" "all_nodes_mgmt" {
    name_prefix = "all_nodes_management"
    vpc_id = module.vpc.vpc_id
    ingress {
            from_port = 22
            to_port = 22
            protocol = "tcp"
            cidr_blocks = [
                "10.0.0.0/8"
            ]
    }
}
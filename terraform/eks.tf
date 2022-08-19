module "eks"{
    source = "terraform-aws-modules/eks/aws"
    version = "18.28.0"

    cluster_name = local.cluster_name
    cluster_version = "1.20"

    vpc_id = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnets
    control_plane_subnet_ids = module.vpc.intra_subnets
    tags = {
        Name = "Demo-EKS-Cluster"
    }

    cluster_addons = {
        coredns = {
            resolve_conflicts = "OVERWRITE"
        }
        kube-proxy = {}
        vpc-cni = {
            resolve_conflicts = "OVERWRITE"
        }
    }

    eks_managed_node_group_defaults = {
        ami_type       = "AL2_x86_64"
        instance_types = ["t2.micro", "t2.large"]

        attach_cluster_primary_security_group = true
        vpc_security_group_ids                = [aws_security_group.all_nodes_mgmt.id]
    }

    eks_managed_node_groups = {
        blue = {}
        green = {
        min_size     = 1
        max_size     = 5
        desired_size = 1

        instance_types = ["t3.large"]
        capacity_type  = "SPOT"

        tags = {
            ExtraTag = "example"
        }
        }
    }

    manage_aws_auth_configmap = true

    aws_auth_users = [
        {
            userarn  = "arn:aws:iam::453007554281:user/terraform-user"
            username = "terraform-user"
            groups   = ["system:Administrator"]
        },
        {
            userarn  = "arn:aws:iam::453007554281:user/deiverk"
            username = "deiverk"
            groups   = ["system:masters"]
        },
    ]

    aws_auth_accounts = [
        "453007554281"
    ]

}
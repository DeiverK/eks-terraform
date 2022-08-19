module "eks"{
    source = "terraform-aws-modules/eks/aws"
    #version = "17.1.0"
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

    # self_managed_node_group_defaults = {
    #     vpc_security_group_ids       = [aws_security_group.all_nodes_mgmt.id]
    #     iam_role_additional_policies = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
    # }

    # self_managed_node_groups = {
    # spot = {
    #     instance_type = "t2.micro"
    #     instance_market_options = {
    #         market_type = "spot"
    #     }

    #     bootstrap_extra_args = "--kubelet-extra-args '--node-labels=node.kubernetes.io/lifecycle=spot'"

    #     post_bootstrap_user_data = <<-EOT
    #     cd /tmp
    #     sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
    #     sudo systemctl enable amazon-ssm-agent
    #     sudo systemctl start amazon-ssm-agent
    #     EOT
    #     }
    # }

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

    # cluster_identity_providers = {
    #     sts = {
    #         client_id = "sts.amazonaws.com"
    #     }
    # }

    #create_aws_auth_configmap = true
    manage_aws_auth_configmap = true

    aws_auth_users = [
        {
        userarn  = "arn:aws:iam::453007554281:user/terraform-user"
        username = "terraform-user"
        groups   = ["system:Administrator"]
        },
        # {
        # userarn  = "arn:aws:iam::453007554281:user/deiverk"
        # username = "deiverk"
        # groups   = ["system:masters"]
        # },
    ]

    aws_auth_accounts = [
        "453007554281"
    ]

}
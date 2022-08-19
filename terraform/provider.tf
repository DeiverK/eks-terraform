# provider "kubernetes" {
#   host                   = module.eks.cluster_endpoint
#   cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     command     = "aws"
#     # This requires the awscli to be installed locally where Terraform is executed
#     args = ["eks", "get-token", "--cluster-name", module.eks.cluster_id]
#   }
# }

provider "aws" {
    region = "us-east-1"
    profile = "myprofile"
}


# provider "kubernetes" {
#     host = data.aws_eks_cluster.cluster.endpoint
#     token = data.aws_eks_cluster_auth.cluster.token
#     #cluster_ca_certificate = base64encode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
#     cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
# }

provider "kubernetes" {
  host                   = data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.default.token
}
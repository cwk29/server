# Retrieve outputs from networking workspace
data "tfe_outputs" "eks" {
  organization = var.tfc_org_name
  workspace    = var.tfc_networking_workspace_name
}

# Retrieve EKS cluster information
provider "aws" {
  region = data.tfe_outputs.eks.values.region
}

data "aws_availability_zones" "available" {}

data "aws_eks_cluster" "cluster" {
  name = data.tfe_outputs.eks.values.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.aws_eks_cluster.cluster.name
    ]
  }
}

# resource "kubernetes_secret" "tls" {
#   metadata {
#     name = "tls-secret"
#   }
#   data = {
#     tls.crt = base64decode(data.tfe_outputs.eks.values.certificate_authority.0.data)
#     tls.key = base64decode(data.tfe_outputs.eks.values.private_key.0.data)
#   }
#   type = "kubernetes.io/tls"
# }

# resource "kubernetes_ingress" "nginx" {
#   metadata {
#     name = "nginx"
#     labels = {
#       app = "nginx"
#     }
#   }
#   spec {
#     rule {
#       host = "wortech.com"
#       http {
#         path {
#           path = "/graphql"
#           backend {
#             service_name = "mongo"
#             service_port = 27017
#           }
#         }
#         path {
#           path = "/*"
#           backend {
#             service_name = "nginx"
#             service_port = 80
#           }
#         }
#       }
#     }

#     tls {
#       secret_name = "tls-secret"
#     }
#   }
# }
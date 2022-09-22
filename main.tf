terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.20.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }

    tfe = {
      source  = "hashicorp/tfe"
      version = "0.36.1"
    }
  }

  required_version = "1.2.7"

  cloud {
    organization = "wortech"

    workspaces {
      name = "server-dev"
    }
  }
}

# Retrieve outputs from networking-dev workspace
data "tfe_outputs" "eks" {
  organization = "wortech"
  workspace    = "networking-dev"
}

# Retrieve EKS cluster information
provider "aws" {
  region = data.tfe_outputs.eks.values.region
}

data "aws_eks_cluster" "cluster" {
  name = data.tfe_outputs.eks.values.cluster_id
}

data "aws_availability_zones" "available" {}

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

resource "kubernetes_secret" "mongo" {
  metadata {
    name = "mongo-secret"
  }
  data = {
    MONGO_INITDB_ROOT_USERNAME = var.mongo_username
    MONGO_INITDB_ROOT_PASSWORD = var.mongo_password
  }
}


resource "aws_ebs_volume" "mongo" {
  availability_zone = data.aws_availability_zones.available.names[0]
  size              = 1
  tags = {
    Name = "mongo-ebs-volume"
  }
}

resource "kubernetes_deployment" "mongo" {
  metadata {
    name = "mongo-deployment"
    labels = {
      app = "mongo"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "mongo"
      }
    }
    template {
      metadata {
        labels = {
          app = "mongo"
        }
      }
      spec {
        container {
          name  = "mongo"
          image = "mongo:latest"
          port {
            container_port = 27017
          }
          env {
            name = "MONGO_INITDB_ROOT_USERNAME"
            value_from {
              secret_key_ref {
                name = "mongo-secret"
                key  = "MONGO_INITDB_ROOT_USERNAME"
              }
            }
          }
          env {
            name = "MONGO_INITDB_ROOT_PASSWORD"
            value_from {
              secret_key_ref {
                name = "mongo-secret"
                key  = "MONGO_INITDB_ROOT_PASSWORD"
              }
            }
          }
          volume_mount {
            name       = aws_ebs_volume.mongo.tags.Name
            mount_path = "/data/db"
          }
        }
        volume {
          aws_elastic_block_store {
            volume_id = aws_ebs_volume.mongo.id
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "mongo" {
  metadata {
    name = "mongo"
  }
  spec {
    type = "LoadBalancer"
    selector = {
      app = kubernetes_deployment.mongo.spec.0.template.0.metadata[0].labels.app
    }
    port {
      app_protocol = "TCP"
      port         = 27017
      target_port  = 27017
    }
  }
}

resource "kubernetes_deployment" "express" {
  metadata {
    name = "express"
    labels = {
      app = "express"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "express"
      }
    }
    template {
      metadata {
        labels = {
          app = "express"
        }
      }
      spec {
        container {
          name  = "express"
          image = "060696402958.dkr.ecr.us-east-1.amazonaws.com/express:latest"
          port {
            container_port = 4000
          }
          # env {
          #   name  = "HOST"
          #   value = kubernetes_service.mongo.status.0.load_balancer.0.ingress.0.hostname
          # }
          # env {
          #   name  = "PORT"
          #   value = kubernetes_service.mongo.spec.0.port.0.port
          # }
          env {
            name  = "NODEMAILER_USER"
            value = var.nodemailer_username
          }
          env {
            name  = "NODEMAILER_PASS"
            value = var.nodemailer_password
          }
          env {
            name  = "MONGO_DB_URI"
            value = "mongodb://${kubernetes_service.mongo.status.0.load_balancer.0.ingress.0.hostname}:27017"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "express" {
  metadata {
    name = "express"
  }
  spec {
    type = "LoadBalancer"
    selector = {
      app = kubernetes_deployment.express.spec.0.template.0.metadata[0].labels.app
    }
    port {
      app_protocol = "TCP"
      port         = 4000
      target_port  = 4000
    }
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
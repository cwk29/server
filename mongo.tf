resource "aws_ebs_volume" "mongo" {
  availability_zone = data.aws_availability_zones.available.names[0]
  size              = 1
  tags = {
    Name = "mongo-ebs-volume"
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
resource "kubernetes_secret" "ecr-registry" {
  metadata {
    name = "ecr-registry"
  }
  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com" = {
          auth = data.aws_ecr_authorization_token.token.authorization_token
        }
      }
    })
  }
  type = "kubernetes.io/dockerconfigjson"
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
        image_pull_secrets {
          name = "ecr-registry"
        }
        container {
          name  = "express"
          image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/express:latest"
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
          # env {
          #   name  = "MONGO_DB_URI"
          #   value = "mongodb://${kubernetes_service.mongo.status.0.load_balancer.0.ingress.0.hostname}:27017"
          # }
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

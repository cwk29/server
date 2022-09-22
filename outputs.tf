output "lb_ip" {
  value = kubernetes_service.express.status.0.load_balancer.0.ingress.0.hostname
}

# output "mongo_connection_string" {
#   description = "MongoDB connection string"
#   value = "mongodb://${var.mongo_username}:${var.mongo_password}@${var.MONGO_SERVICE_HOST}:${var.MONGO_SERVICE_PORT}/${var.MONGO_INITDB_DATABASE}"
# }
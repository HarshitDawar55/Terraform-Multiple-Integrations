provider "kubernetes" {
  config_context_cluster = var.cluster-name
}

resource "kubernetes_deployment" "Webserver-Deployment" {
  metadata {
    name = "webserver-deployment"
    labels = {
      App = "Webserver"
    }
  }
  spec {
    replicas = var.replicas
    strategy {
      type = var.K8-Strategy
    }
    selector {
      match_labels = {
        env = "Production"
        type = "webserver"
        dc = "India"
      }
    }
    template {
      metadata {
        labels = {
          env = "Production"
          type = "webserver"
          dc = "India"
        }
      }
      spec {
        // Deploying a WordPress container!
        container {
          name = "Webserver"
          image = var.image
          port {
            container_port = 80
          }
        }
      }
    }
  }
}
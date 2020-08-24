provider "kubernetes" {
  config_context_cluster = var.cluster-name
}

resource "kubernetes_deployment" "Webserver-Deployment" {
  metadata {
    name = "Webserver_Deployment"
  }
  spec {
    replicas = var.replicas
    strategy {
      name = var.K8-Strategy
    }
    selector {
      env = "Production",
      type = "webserver",
      dc = "India"
    }
    template {
      metadata {
        labels = {
          env = "Production",
          type = "webserver",
          dc = "India"
        }
      }
      spec {
        // Deploying a WordPress container!
        container {
          name = "Webserver"
          image = var.image
        }
      }
    }
  }
}
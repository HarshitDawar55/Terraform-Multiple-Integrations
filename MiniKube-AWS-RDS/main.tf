provider "kubernetes" {
  config_context_cluster = "minikube"
}

resource "kubernetes_deployment" "Webserver-Deployment" {
  metadata {
    name = "Webserver_Deployment"
  }
  spec {
    replicas = 3
    strategy {
      name = "rolling-update"
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
          image = "wordpress"
        }
      }
    }
  }
}
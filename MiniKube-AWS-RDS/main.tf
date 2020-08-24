// It is required for the Kubernetes services/functionalities!
provider "kubernetes" {
  config_context_cluster = var.cluster-name
}

// It is required for the aws functionalities, to be specific, RDS in the present scenario!
provider "aws" {
  region = "ap-south-1"

  // Assign the profile name here!
  profile = "default"
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
          name = "webserver"
          image = var.image
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

// Creating a Kubernetes Service type NodePort for the local Cluster OR Exposing the created Deployment
resource "kubernetes_service" "WordPress" {
  metadata {
    name = "wordpress-service"
  }
  spec {
    type = "NodePort"
    selector = {
      // Selector by which POD Deployment has to be selected
      type = "webserver"
    }
    port {
      port = 80
      target_port = 80
      protocol = "TCP"
      name = "http"
    }
  }
}
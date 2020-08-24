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

// Creating an RDS AWS Resource
resource "aws_db_instance" "WordPress-RDS" {
  allocated_storage    = 5
  max_allocated_storage = 7
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  // Name of the Database to be created
  identifier           = "wordpressdb"
  name                 = "wordpress"
  username             = "harshitdawar"
  password             = "harshitdawar12345"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot = true
  port = 3306
  publicly_accessible = true

  // Specifying the Minor Version Upgrade of MySQL to True
  auto_minor_version_upgrade = true

  // Deleting Automated Backups
  delete_automated_backups = true
}

output "RDS-Instance" {
  value = aws_db_instance.WordPress-RDS.address
}
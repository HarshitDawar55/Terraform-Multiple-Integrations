variable "K8-Strategy" {
  default = "rolling-update"
}

variable "replicas" {
  type = number
  default = 3
}

variable "cluster-name" {
  default = "minikube"
}

variable "image" {
  default = "wordpress"
}
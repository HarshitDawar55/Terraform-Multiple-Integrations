variable "K8-Strategy" {
  default = "RollingUpdate"
}

variable "replicas" {
  type = number
  default = 1
}

variable "cluster-name" {
  default = "minikube"
}

variable "image" {
  default = "wordpress"
}
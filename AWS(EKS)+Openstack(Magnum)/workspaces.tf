variable "workspaces" {
  type = map
  default = {
    testing = "openstack"
    production = "aws"
  }
}

output "workspaces" {
  value = var.workspaces
}
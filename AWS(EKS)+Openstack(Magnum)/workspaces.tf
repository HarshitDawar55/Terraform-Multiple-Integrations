variable "production" {
  type = string
  default = true
}

variable "testing" {
  type = string
  default = false
}

output "workspaces" {
  value = [var.production, var.testing]
}
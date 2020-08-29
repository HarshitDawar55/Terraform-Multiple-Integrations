provider "aws" {
  profile = "default"
  region = "ap-south-1"
}

provider "openstack" {
  # Username to be used while connecting to Openstack.
  user_name = "<User Name>"

  # Tenant name to be used while connecting to Openstack.
  tenant_name = "<Tenant Name>"

  # Password to be used while connecting to Openstack.
  password = "<Password>"

  # URL where Openstack is running!
  auth_url = "<Auth URL>"

  region = "<Region Name>"
}

resource "aws_eks_cluster" "Production" {
  name = ""
  role_arn = ""
  vpc_config {
    subnet_ids = []
  }
}
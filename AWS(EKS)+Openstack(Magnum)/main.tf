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

resource "aws_eks_fargate_profile" "Production" {
  # This resource will only be created when production workspace is selected. It is possible because of the below statement.
  count = var.production ? 1 : 0

  # Put your cluster Name
  cluster_name = "Cassandra-Deployment"

  # Put the Profile name of Fargate
  fargate_profile_name = "Cassandra"
  pod_execution_role_arn = "<AWS Resource Name of the IAM Role which grants permission for the EKS Fargate Profile>"

  # Subnet IDS which are to attached to the AWS EKS Fargate Profile
  subnet_ids = [""]
  selector {
    namespace = ["kube-system", "default"]
  }
}
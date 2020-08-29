provider "aws" {
  profile = "default"
  region = "ap-southeast-1"
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
  cluster_name = "cassandra-deployment"

  # Put the Profile name of Fargate
  fargate_profile_name = "cassandra"
  pod_execution_role_arn = "<AWS Resource Name of the IAM Role which grants permission for the EKS Fargate Profile>"

  # Subnet IDS which are to attached to the AWS EKS Fargate Profile
  subnet_ids = ["subnet-44e49308", "subnet-ba7372d2", "subnet-e567de9e"]

  # Selectors for Fargate Profile, namespace is compulsory to give, to select Kubernetes Pods from that.
  selector {
    namespace = ["kube-system", "default"]
  }
}

resource "openstack_containerinfra_clustertemplate_v1" "Testing-Template" {
  # This resource will only be created when Testing workspace is selected. It is possible because of the below statement.
  count = var.testing ? 1 : 0

  coe = "kubernetes"
  name = "cassandra_deployment"
  image = "<Name of Image which has to be used to launch kubernetes Pods>"
  flavor = "m1.small"
  master_flavor = "m1.large"
  master_lb_enabled = true
  floating_ip_enabled = true
  network_driver = "flannel"
  volume_driver = "cinder"
  docker_volume_size = 15
  dns_nameserver = "<IP of the DNS nameserver>"
}

resource "openstack_containerinfra_cluster_v1" "Testing" {
  # This resource will only be created when Testing workspace is selected. It is possible because of the below statement.
  count = var.testing ? 1 : 0

  name = "cassandra_cluster"
  cluster_template_id = openstack_containerinfra_clustertemplate_v1.Testing-Template.id
  master_count = 1
  node_count = 5

  # Be sure below keypair is available with you & also present in the Openstack KeyPairs!
  keypair = "<Name of the keypair to be attached>"
}
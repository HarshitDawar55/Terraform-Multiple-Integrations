provider "aws" {
  region = "us-east-1"

  // Assign the profile name here!
  profile = "default"
}

// Creating a New Key
resource "aws_key_pair" "IntegrationKey" {
  key_name   = "ProjectKey"
  public_key = file("~/.ssh/id_rsa.pub")
  }

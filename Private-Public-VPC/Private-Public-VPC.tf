provider "aws" {
  region = "us-east-1"

  // Assign the profile name here!
  profile = "default"
}

// Creating a New Key
resource "aws_key_pair" "Key-Pair" {
  key_name   = "Integration-Key"
  public_key = file("~/.ssh/id_rsa.pub")
  }



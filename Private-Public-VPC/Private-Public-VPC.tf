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

// Creating a VPC!
resource "aws_vpc" "custom" {
  cidr_block = "57.95.0.0/16"
  tags = {
    Name = "custom"
  }
}

// Creating subnet 1
resource "aws_subnet" "subnet1" {
  vpc_id = aws_vpc.custom.id
  cidr_block = ["57.95.0.1/24"]
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Public Subnet"
  }
}

// Creating subnet 2
resource "aws_subnet" "subnet2" {
  vpc_id = aws_vpc.custom.id
  cidr_block = ["57.95.1.1/24"]
  availability_zone = "ap-south-1b"

  tags = {
    Name = "Private Subnet"
  }
}
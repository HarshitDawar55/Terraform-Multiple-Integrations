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

// Creating an Internet Gateway for the VPC
resource "aws_internet_gateway" "Internet_Gateway" {
  vpc_id = aws_vpc.custom.id

  tags = {
    Name = "IG-Public-&-Private-VPC"
  }
}

// Creating security group for webserver!  Note: This security group we will use to create the instances in the private subnet secure,
// as the instances with this security group attached only have access to the private subnet.
resource "aws_security_group" "WS-SG" {

  description = "HTTP, PING, SSH"
  name = "Webserver-SG"
  vpc_id = aws_vpc.custom.id

  // Created an inbound rule for webserver
  ingress {
    description = "HTTP for webserver"
    from_port   = 80
    to_port     = 80

    # Here adding tcp instead of http, because http in part of tcp only!
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Created an inbound rule for ping
  ingress {
    description = "Ping"
    from_port   = 0
    to_port     = 0
    protocol    = "ICMP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Created an inbound rule for ping
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22

    # Here adding tcp instead of ssh, because ssh in part of tcp only!
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "output from webserver"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// Creating security group for MySQL, this will allow access only from the instances having the security group created above.
resource "aws_security_group" "MySQL-SG" {

  description = "MySQL Access only from the Webserver Instances!"
  name = "MySQL-SG"
  vpc_id = aws_vpc.custom.id

  // Created an inbound rule for webserver
  ingress {
    description = "MySQL Access"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.WS-SG.id]
  }

  egress {
    description = "output from MySQL"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// Creating security group for Bastion Host/Jump Box
resource "aws_security_group" "BH-SG" {

  description = "MySQL Access only from the Webserver Instances!"
  name = "MySQL-SG"
  vpc_id = aws_vpc.custom.id

  // Created an inbound rule for webserver
  ingress {
    description = "Bastion Host SG"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "output from MySQL"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// Creating security group for MySQL Bastion Host Access
resource "aws_security_group" "DB-SG-SSH" {

  description = "MySQL Bastion host access for updates!"
  name = "MySQL-SG-BH"
  vpc_id = aws_vpc.custom.id

  // Created an inbound rule for MySQL Bastion Host
  ingress {
    description = "Bastion Host SG"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.BH-SG.name]
  }

  egress {
    description = "output from MySQL"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// Creating an Route Table for the public subnet!
resource "aws_route_table" "Public-Subnet-RT" {
  vpc_id = aws_vpc.custom.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Internet_Gateway.id
  }

  tags = {
    Name = "Route Table for Internet Gateway"
  }
}



// Creating an AWS instance for the Webserver!
resource "aws_instance" "webserver" {
  ami = "ami-0162dd7febeafb455"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet1.id

  // Keyname and security group are obtained from the reference of their instances created above!
  key_name = aws_key_pair.Key-Pair.key_name
  security_groups =  [aws_security_group.WS-SG.name]

  // user_data = file("init_conf.sh")
  tags = {
   Name = "Webserver_From_Terraform"
  }
}

// Creating an AWS instance for the MySQL! It should be launched in the private subnet!
resource "aws_instance" "MySQL" {
  ami = "ami-0162dd7febeafb455"
  instance_type = "t2.micro"

  // Keyname and security group are obtained from the reference of their instances created above!
  key_name = aws_key_pair.Key-Pair.key_name

  // Attaching 2 security groups here, 1 for the MySQL Database access by the Web-servers, & other one for the Bastion Host
  // access for applying updates & patches!
  security_groups =  [aws_security_group.MySQL-SG.name, aws_security_group.DB-SG-SSH.name]

  // user_data = file("init_conf.sh")
  tags = {
   Name = "MySQL_From_Terraform"
  }
}

// Creating an AWS instance for the Bastion Host, It should be launched in the public Subnet!
resource "aws_instance" "Bastion-Host" {
  ami = "ami-0162dd7febeafb455"
  instance_type = "t2.micro"

  // Keyname and security group are obtained from the reference of their instances created above!
  key_name = aws_key_pair.Key-Pair.key_name
  security_groups =  [aws_security_group.BH-SG.name]

  // user_data = file("init_conf.sh")
  tags = {
   Name = "Bastion_Host_From_Terraform"
  }
}


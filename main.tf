terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.access-key
  secret_key = var.secret-key
}


# Jenkins-Instance

resource "aws_instance" "jenkins-ec2" {
  ami             = data.aws_ami.ami.id
  instance_type   = var.instance-type
  key_name        = var.key-name
  security_groups = [aws_security_group.jenkins-sg.name]
  user_data       = file("./jenkins-install.sh")
  tags = {
    Name = "jenkins-ec2"
  }
}

# AMI 

data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}

# Security-Group

resource "aws_security_group" "jenkins-sg" {
  name        = "jenkins-sg"
  description = "Allow ssh and web traffic for jenkins instance"
  vpc_id      = var.vpc-id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.your-public-IP]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.your-public-IP]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins-sg"
  }
}



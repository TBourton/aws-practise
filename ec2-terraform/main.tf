variable "awsprops" {
    type = map(string)
    default = {
    region = "eu-west-2"
    ami = "ami-0aaa5410833273cfe"
    itype = "t2.micro"
    subnet = "subnet-81896c8e"
    publicip = true
    keyname = "tom_bourton"
    secgroupname = "tb-sg"
  }
}

provider "aws" {
  region = "eu-west-2"
  profile = "Faculty-Customer-Engineering.AdministratorAccess"
}

terraform {
  required_version = ">= 0.12.0"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group" "tb-sg" {
  name = lookup(var.awsprops, "secgroupname")
  description = "Security group for EC2 testing with terraform."
  vpc_id = data.aws_vpc.default.id

  // To Allow SSH Transport
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  // To Allow Port 80 Transport
  ingress {
    from_port = 80
    protocol = "-1"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "tb-ec2" {
  ami = lookup(var.awsprops, "ami")
  instance_type = lookup(var.awsprops, "itype")
  associate_public_ip_address = lookup(var.awsprops, "publicip")
  key_name = lookup(var.awsprops, "keyname")

  vpc_security_group_ids = [
    aws_security_group.tb-sg.id
  ]
  root_block_device {
    volume_size = 50
  }
  tags = {
    Name = "tom bourton ec2 terraform"
    Environment = "DEV"
    OS = "UBUNTU"
    Managed = "TOMBOURTON"
  }

  depends_on = [ aws_security_group.tb-sg ]
  user_data = file("run.sh")
}


output "ec2instance" {
  value = aws_instance.tb-ec2.public_ip
}

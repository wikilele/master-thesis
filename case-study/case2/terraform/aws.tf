
provider "aws" {
  version = "~> 2.0"
  region = var.region
  access_key = var.awsAccessKey
  secret_key = var.awsSecretKey
}

variable "awsAccessKey" { }

variable "awsSecretKey" { }

variable "region" {
  default = "eu-west-1"
}

variable "key_name" {
  default = "id_rsa"
}

variable "public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

variable "private_key_path" {
  default = "~/.ssh/id_rsa"
}

variable "ssh_user" {
  default = "ubuntu"
}

resource "aws_key_pair" "auth" {
  key_name = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_vpc" "edmm" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "edmm" {
  vpc_id = aws_vpc.edmm.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "edmm" {
  vpc_id = aws_vpc.edmm.id
}

resource "aws_route_table" "public_routes" {
  vpc_id = aws_vpc.edmm.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.edmm.id
  }
}

resource "aws_route_table_association" "public_route_association" {
  subnet_id = aws_subnet.edmm.id
  route_table_id = aws_route_table.public_routes.id
}

resource "aws_security_group" "compute_security_group" {
  name = "compute_security_group"
  vpc_id = aws_vpc.edmm.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "compute" {
  ami = "ami-0701e7be9b2a77600"
  instance_type = "t2.micro"
  key_name = aws_key_pair.auth.id
  vpc_security_group_ids = [aws_security_group.compute_security_group.id]
  subnet_id = aws_subnet.edmm.id
  connection {
    type  = "ssh"
    user  = var.ssh_user
    agent = true
    private_key = file(var.private_key_path)
    host = self.public_ip
  }
  provisioner "file" {
    source      = "./env.sh"
    destination = "~/env.sh"
  }
  provisioner "file" {
    source      = "artifacttemplates/https%3A%2F%2Fedmm.uni-stuttgart.de%2Fartifacttemplates/PetClinic-App/files/petclinic.war"
    destination = "~/petclinic"
  }
  provisioner "remote-exec" {
    scripts = [
      "artifacttemplates/https%3A%2F%2Fedmm.uni-stuttgart.de%2Fartifacttemplates/Tomcat-Create/files/create.sh",
      "artifacttemplates/https%3A%2F%2Fedmm.uni-stuttgart.de%2Fartifacttemplates/Tomcat-Start/files/start.sh"
    ]
  }
  provisioner "remote-exec" {
    scripts = [
      "artifacttemplates/https%3A%2F%2Fedmm.uni-stuttgart.de%2Fartifacttemplates/PetClinic-Configure/files/configure.sh",
      "artifacttemplates/https%3A%2F%2Fedmm.uni-stuttgart.de%2Fartifacttemplates/PetClinic-Start/files/start.sh"
    ]
  }
  depends_on = [aws_instance.compute_2]
}

resource "aws_security_group" "compute_2_security_group" {
  name = "compute_2_security_group"
  vpc_id = aws_vpc.edmm.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "compute_2" {
  ami = "ami-0701e7be9b2a77600"
  instance_type = "t2.micro"
  key_name = aws_key_pair.auth.id
  vpc_security_group_ids = [aws_security_group.compute_2_security_group.id]
  subnet_id = aws_subnet.edmm.id
  connection {
    type  = "ssh"
    user  = var.ssh_user
    agent = true
    private_key = file(var.private_key_path)
    host = self.public_ip
  }
  provisioner "file" {
    source      = "./env.sh"
    destination = "~/env.sh"
  }
  provisioner "file" {
    source      = "artifacttemplates/https%3A%2F%2Fedmm.uni-stuttgart.de%2Fartifacttemplates/Petclinic-Schema/files/schema.sql"
    destination = "~/mysql_database"
  }
  provisioner "remote-exec" {
    scripts = [
      "artifacttemplates/https%3A%2F%2Fedmm.uni-stuttgart.de%2Fartifacttemplates/MySQL_DBMS-Create/files/create.sh",
      "artifacttemplates/https%3A%2F%2Fedmm.uni-stuttgart.de%2Fartifacttemplates/MySQL_DBMS-Start/files/start.sh"
    ]
  }
  provisioner "remote-exec" {
    scripts = [
      "artifacttemplates/https%3A%2F%2Fedmm.uni-stuttgart.de%2Fartifacttemplates/MySQL_Database-Configure/files/configure.sh"
    ]
  }
}





# main.tf — S03 : Première instance EC2

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Ireland
provider "aws" {
  region = "eu-west-1"
}

# --- Recherche de l'AMI Ubuntu 24.04 la plus récente ---
# Les AMI (Amazon Machine Images) changent régulièrement.
# Plutôt que de noter un ID qui sera périmé, on demande à AWS la plus récente.
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (éditeur d'Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# --- Security Group : autoriser SSH ---
resource "aws_security_group" "novasphere_ssh" {
  name        = "novasphere-ssh"
  description = "Autoriser_SSH_depuis_partout"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 = tous les protocoles
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "novasphere-ssh"
    Project = "NovaSphere"
  }
}

# --- Instance EC2 ---
resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro" # Type économique (amd64)
  vpc_security_group_ids = [aws_security_group.novasphere_ssh.id]

  tags = {
    Name    = "novasphere-web"
    Project = "NovaSphere"
    Session = "S03"
    Environment = "dev"
  }
}

# --- Outputs : afficher les infos utiles après apply ---
output "instance_id" {
  description = "ID de l'instance EC2"
  value       = aws_instance.web.id
}

output "public_ip" {
  description = "Adresse IP publique"
  value       = aws_instance.web.public_ip
}

output "ami_used" {
  description = "AMI utilisée"
  value       = data.aws_ami.ubuntu.id
}

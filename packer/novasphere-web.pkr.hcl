packer {
  required_plugins {
    amazon = {
      version = ">= 1.3.0"
      source  = "github.com/hashicorp/amazon"
    }
    ansible = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

# --- Variables ---
variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "app_version" {
  type    = string
  default = "2.0"
}

# --- Source : AMI Ubuntu de base ---
source "amazon-ebs" "novasphere" {
  ami_name      = "novasphere-web-${var.app_version}-{{timestamp}}"
  instance_type = var.instance_type
  region        = var.aws_region

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }

  ssh_username = "ubuntu"

  tags = {
    Name     = "novasphere-web"
    Project  = "NovaSphere"
    Version  = var.app_version
    Builder  = "Packer"
    Base_AMI = "{{ .SourceAMI }}"
  }
}

# --- Build : provisioning avec Ansible ---
build {
  sources = ["source.amazon-ebs.novasphere"]

  provisioner "ansible" {
    playbook_file = "../ansible/packer-playbook.yml"
    extra_arguments = [
      "--extra-vars", "env=prod app_version=${var.app_version}",
      "--skip-tags", "debug"
    ]
  }
}

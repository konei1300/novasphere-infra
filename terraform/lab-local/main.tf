# main.tf — S03 : Premier déploiement Terraform

terraform {
  required_providers {
    local = {
      source  = "hashicorp/local" # TODO 1 : Chemin du provider local
      version = "~> 2.5"
    }
  }
}

provider "local" {}

resource "local_file" "novasphere_welcome" {
  # TODO 2 : Écrire un message de bienvenue NovaSphere
  content  = "NovaSphere — Infrastructure as Code v2.0"
  filename = "${path.module}/welcome.txt"
}

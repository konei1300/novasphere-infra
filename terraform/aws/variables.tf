variable "aws_region" {
  description = "Région AWS"
  type        = string
  default     = "eu-west-1"
}

variable "project_name" {
  description = "Nom du projet (utilisé dans les tags et les noms)"
  type        = string
  default     = "novasphere"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]+$", var.project_name))
    error_message = "Le nom du projet doit être en minuscules, lettres, chiffres et tirets uniquement."
  }
}

variable "environment" {
  description = "Environnement de déploiement"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "L'environnement doit être dev, staging ou prod."
  }
}

variable "instance_type" {
  description = "Type d'instance EC2"
  type        = string
  default     = "t3.micro"

  validation {
    condition     = contains(["t3.micro", "t3.small", "t3.medium"], var.instance_type)
    error_message = "Le type d'instance doit être t3.micro, t3.small ou t3.medium."
  }
}

variable "ssh_public_key_path" {
  description = "Chemin vers la clé publique SSH"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "allowed_ssh_cidr" {
  description = "Bloc CIDR autorisé pour SSH"
  type        = string
  default     = "0.0.0.0/0"
  # Tout le monde (TP uniquement !)
}

variable "ssh_private_key_path" {
  description = "Chemin vers la clé privée SSH pour Ansible"
  type        = string
  default     = "~/.ssh/novasphere"
}

variable "custom_ami_id" {
  description = "ID de l'AMI custom Packer"
  type        = string
  default     = ""
}

# NovaSphere — Infrastructure as Code (IaC)

## À propos
Ce dépôt contient l’Infrastructure as Code (IaC) de **NovaSphere**.  
Le provisionnement des ressources est géré via **Terraform** et la configuration via **Ansible**.  
La construction des images est réalisée avec **Packer** (AMI AWS).

## Stack technique

### Provisioning
- **Terraform** >= 1.14
  - Provider : **AWS**

### Configuration
- **Ansible** >= 2.17 (installation recommandée via **pipx**)

### Cloud (AWS)
- VPC
- EC2
- Security Groups
- IAM

### Image Building
- **Packer** >= 1.11 (build d’AMI)

### CI/CD
- **GitLab CI/CD**

## Structure du dépôt
- `docs/` — Documentation d’architecture et décisions techniques
- `terraform/` — Code Terraform (réseaux, compute, sécurité, IAM, etc.)

## Auteur
- **Nom** : Ibrahim KONE
- **Date de création** : 2026-02-25

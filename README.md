<p align="center">
  <img src="novasphere-logo.png" alt="Logo NovaSphere" width="180">
</p>

<h1 align="center">NovaSphere</h1>

<p align="center">
  <strong>Infrastructure as Code sur AWS avec Terraform, Ansible, Vault, Packer et architecture multi-tier</strong>
</p>

<p align="center">
  <img alt="Terraform" src="https://img.shields.io/badge/Terraform-IaC-623CE4?style=for-the-badge&logo=terraform&logoColor=white">
  <img alt="Ansible" src="https://img.shields.io/badge/Ansible-Automation-EE0000?style=for-the-badge&logo=ansible&logoColor=white">
  <img alt="Packer" src="https://img.shields.io/badge/Packer-AMI%20Build-02A8EF?style=for-the-badge&logo=packer&logoColor=white">
  <img alt="AWS" src="https://img.shields.io/badge/AWS-Cloud-232F3E?style=for-the-badge&logo=amazonaws&logoColor=white">
  <img alt="Vault" src="https://img.shields.io/badge/Ansible%20Vault-Secrets-FFB000?style=for-the-badge">
</p>

---

## Sommaire

- [Présentation](#présentation)
- [Objectifs](#objectifs)
- [Stack technique](#stack-technique)
- [Travaux réalisés](#travaux-réalisés)
- [Arborescence du projet](#arborescence-du-projet)
- [Prérequis](#prérequis)
- [Déploiement classique](#déploiement-classique)
- [Destruction](#destruction)
- [Gestion des secrets avec Vault](#gestion-des-secrets-avec-vault)
- [Inventaire dynamique AWS](#inventaire-dynamique-aws)
- [Build d’une AMI avec Packer](#build-dune-ami-avec-packer)
- [Déploiement avec une AMI custom](#déploiement-avec-une-ami-custom)
- [Architecture multi-tier](#architecture-multi-tier)
- [Sécurité](#sécurité)
- [Auteur](#auteur)
- [Versionnement](#versionnement)

---

## Présentation

**NovaSphere** est un projet d’Infrastructure as Code qui automatise le déploiement d’une infrastructure AWS et la configuration d’un serveur web.

Le dépôt met en œuvre une chaîne complète d’automatisation autour de :

- **Terraform** pour le provisioning
- **Ansible** pour la configuration
- **Ansible Vault** pour la gestion des secrets
- **Packer** pour construire une AMI réutilisable
- **AWS** pour l’hébergement de l’infrastructure

---

## Objectifs

Ce projet permet de :

- provisionner automatiquement une infrastructure cloud
- déployer un serveur web Nginx sans intervention manuelle
- sécuriser les variables sensibles
- automatiser le lien entre Terraform et Ansible
- industrialiser les déploiements avec une AMI custom
- renforcer la sécurité avec une architecture multi-tier

---

## Stack technique

### Infrastructure
- Terraform
- AWS Provider

### Configuration
- Ansible
- Ansible Vault
- Collection `amazon.aws`

### Image building
- Packer
- Plugin `amazon`
- Plugin `ansible`

### Cloud AWS
- EC2
- VPC
- Subnets publics / privés
- Security Groups
- Internet Gateway
- NAT Gateway
- AMI
- Bastion SSH

---

## Travaux réalisés

### S07 — Structuration Ansible + Vault
- création d’un rôle Ansible `webserver`
- séparation des tâches, handlers, templates et variables
- gestion des secrets avec Ansible Vault
- injection de secrets dans le template HTML

### S09 — Automatisation Terraform → Ansible
- génération automatique de l’inventaire Ansible
- création de `deploy.sh`
- création de `destroy.sh`
- suppression du copier-coller manuel de l’IP publique
- mise en place d’un inventaire dynamique AWS

### S10 — Construction d’une AMI NovaSphere avec Packer
- build d’une image AMI personnalisée
- provisioning de l’image avec Ansible
- déploiement Terraform depuis une AMI custom
- serveur opérationnel immédiatement après `terraform apply`

### S11 — Infrastructure multi-tier
- création d’un VPC dédié
- création d’un subnet public
- création d’un subnet privé
- déploiement d’un bastion SSH
- déploiement d’un serveur privé
- mise en place d’une NAT Gateway
- accès SSH via `ProxyJump`

---

## Arborescence du projet

```text
novasphere-infra/
├── README.md
├── deploy.sh
├── destroy.sh
├── a_digital_vector_logo_design_for_the_novasphere_pr.png
├── ansible/
│   ├── ansible.cfg
│   ├── inventory/
│   │   ├── hosts.yml
│   │   ├── hosts_generated.yml
│   │   └── aws_ec2.yml
│   ├── vault/
│   │   └── secrets.yml
│   ├── group_vars/
│   ├── playbook.yml
│   ├── packer-playbook.yml
│   └── roles/
│       └── webserver/
│           ├── defaults/
│           ├── files/
│           ├── handlers/
│           ├── meta/
│           ├── tasks/
│           ├── templates/
│           ├── tests/
│           └── vars/
├── terraform/
│   ├── aws/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   ├── variables.tf
│   │   └── templates/
│   └── multi-tier/
│       ├── main.tf
│       ├── outputs.tf
│       ├── providers.tf
│       └── variables.tf
└── packer/
    └── novasphere-web.pkr.hcl
````

---

## Prérequis

Outils à installer :

* Terraform
* Ansible
* Packer
* AWS CLI
* Python 3
* `boto3`
* `botocore`

Vérification :

```bash
terraform version
ansible --version
packer version
aws --version
```

---

## Déploiement classique

Depuis la racine du projet :

```bash
./deploy.sh
```

Ce script exécute automatiquement :

1. `terraform apply`
2. attente du démarrage de l’instance
3. `ansible-playbook`
4. vérification HTTP finale

---

## Destruction

```bash
./destroy.sh
```

---

## Gestion des secrets avec Vault

Le fichier chiffré est situé ici :

```text
ansible/vault/secrets.yml
```

Exemple :

```bash
ansible-vault encrypt ansible/vault/secrets.yml --vault-password-file ~/.vault_pass
```

Exécution du playbook avec Vault :

```bash
ansible-playbook -i ansible/inventory/hosts_generated.yml ansible/playbook.yml --vault-password-file ~/.vault_pass
```

---

## Inventaire dynamique AWS

Afficher les hôtes détectés :

```bash
ansible-inventory -i ansible/inventory/aws_ec2.yml --graph
```

Exécuter le playbook avec l’inventaire dynamique :

```bash
ansible-playbook -i ansible/inventory/aws_ec2.yml ansible/playbook.yml --vault-password-file ~/.vault_pass
```

---

## Build d’une AMI avec Packer

Depuis le dossier `packer/` :

```bash
packer init .
packer fmt .
packer validate novasphere-web.pkr.hcl
packer build novasphere-web.pkr.hcl
```

Une AMI NovaSphere est alors créée sur AWS.

---

## Déploiement avec une AMI custom

Terraform peut déployer directement une instance à partir d’une image Packer :

```bash
terraform apply -var="custom_ami_id=ami-xxxxxxxxxxxxxxxxx" -auto-approve
```

Dans ce mode, le serveur est disponible immédiatement après le déploiement, car l’image contient déjà la configuration web.

---

## Architecture multi-tier

L’architecture S11 repose sur :

* un **VPC**
* un **subnet public**
* un **subnet privé**
* un **bastion SSH**
* un **serveur privé**
* une **NAT Gateway**
* une **Internet Gateway**

Connexion SSH au serveur privé via rebond :

```bash
ssh -J ubuntu@BASTION_PUBLIC_IP -i /home/kone/.ssh/id_rsa ubuntu@PRIVATE_IP
```

Cette approche est plus sûre qu’un accès SSH direct, car seul le bastion est exposé publiquement.

---

## Sécurité

Règles appliquées dans le projet :

* secrets chiffrés avec Ansible Vault
* `.vault_pass` non versionné
* fichiers `.tfvars` exclus du dépôt
* accès SSH par clé privée
* serveur privé accessible uniquement via bastion
* nettoyage des AMI et snapshots Packer après usage

---

## Auteur

* **KONE Ibrahim**

---

## Versionnement

Jalons réalisés :

* `v0.7.0` — rôles Ansible + Vault
* `v0.9.0` — automatisation Terraform → Ansible
* `v0.10.0` — Packer + AMI NovaSphere
* `v0.11.0` — infrastructure multi-tier

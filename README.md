# NovaSphere — Infrastructure as Code

NovaSphere est un projet d’Infrastructure as Code qui automatise le déploiement d’un serveur web sur AWS avec **Terraform**, **Ansible** et **Packer**.

Le projet couvre plusieurs étapes d’automatisation :

- provisionner une instance EC2 avec Terraform
- configurer le serveur avec Ansible
- sécuriser les secrets avec Ansible Vault
- générer automatiquement l’inventaire Ansible depuis Terraform
- utiliser un inventaire dynamique AWS
- construire une AMI personnalisée avec Packer
- déployer directement une instance préconfigurée à partir de cette AMI

---

## Objectifs du projet

Ce dépôt a pour but de mettre en pratique une chaîne d’automatisation complète autour d’AWS :

- **Terraform** pour le provisioning de l’infrastructure
- **Ansible** pour la configuration système et applicative
- **Ansible Vault** pour la gestion sécurisée des secrets
- **Packer** pour créer une AMI réutilisable et immutable

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

### Cloud
- AWS EC2
- Security Groups
- AMI
- Key Pair SSH

---

## Fonctionnalités réalisées

### 1. Provisioning AWS avec Terraform
- création d’une instance EC2 Ubuntu
- création d’un Security Group
- création d’une key pair
- récupération de l’IP publique en output

### 2. Configuration serveur avec Ansible
- installation de Nginx et des paquets utiles
- déploiement d’un virtual host
- déploiement d’une page web NovaSphere
- création d’utilisateurs système
- gestion des handlers
- organisation en rôle Ansible `webserver`

### 3. Gestion des secrets avec Ansible Vault
- chiffrement d’un fichier `vault/secrets.yml`
- chargement des secrets dans le playbook
- injection des secrets dans le template HTML
- affichage masqué de l’API key

### 4. Automatisation Terraform → Ansible
- génération automatique de `hosts_generated.yml`
- suppression du copier-coller manuel de l’IP publique
- script `deploy.sh` pour enchaîner :
  - `terraform apply`
  - attente du démarrage
  - `ansible-playbook`
  - vérification HTTP

### 5. Inventaire dynamique AWS
- utilisation du plugin `amazon.aws.aws_ec2`
- découverte automatique des instances EC2
- création du groupe `webservers`
- exécution du playbook avec l’inventaire dynamique

### 6. Construction d’une AMI personnalisée avec Packer
- build d’une AMI NovaSphere avec Ansible
- intégration du site web dans l’image
- déploiement Terraform à partir de l’AMI custom
- serveur opérationnel immédiatement sans rejouer Ansible

---

## Arborescence du projet

```text
novasphere-infra/
├── ansible/
│   ├── ansible.cfg
│   ├── group_vars/
│   ├── inventory/
│   │   ├── hosts.yml
│   │   ├── hosts_generated.yml
│   │   └── aws_ec2.yml
│   ├── roles/
│   │   └── webserver/
│   │       ├── defaults/
│   │       ├── handlers/
│   │       ├── tasks/
│   │       ├── templates/
│   │       └── vars/
│   ├── vault/
│   │   └── secrets.yml
│   ├── playbook.yml
│   └── packer-playbook.yml
├── packer/
│   └── novasphere-web.pkr.hcl
├── terraform/
│   └── aws/
│       ├── main.tf
│       ├── outputs.tf
│       ├── providers.tf
│       ├── variables.tf
│       └── templates/
├── deploy.sh
├── destroy.sh
└── README.md

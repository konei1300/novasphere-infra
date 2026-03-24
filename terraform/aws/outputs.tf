output "instance_id" {
  description = "ID de l'instance EC2"
  value       = aws_instance.web.id
}

output "public_ip" {
  description = "Adresse IP publique de l'instance"
  value       = aws_instance.web.public_ip
}

output "ssh_command" {
  description = "Commande SSH pour se connecter"
  value       = "ssh -i ${var.ssh_public_key_path} ubuntu@${aws_instance.web.public_ip}"
}

output "ami_id" {
  description = "AMI utilisée"
  value       = data.aws_ami.ubuntu.id
}

output "security_group_id" {
  description = "ID du Security Group"
  value       = aws_security_group.web.id
}

output "ansible_inventory_path" {
  description = "Chemin de l'inventaire Ansible généré"
  value       = local_file.ansible_inventory.filename
}

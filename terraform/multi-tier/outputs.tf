output "vpc_id" {
  description = "ID du VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID du subnet public"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "ID du subnet privé"
  value       = aws_subnet.private.id
}

output "bastion_public_ip" {
  description = "IP publique du bastion"
  value       = aws_instance.bastion.public_ip
}

output "web_private_ip" {
  description = "IP privée du serveur web"
  value       = aws_instance.web_private.private_ip
}

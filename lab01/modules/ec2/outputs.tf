output "public_instance_id" {
  description = "ID of the public EC2 instance"
  value       = aws_instance.public[0].id
}

output "private_instance_id" {
  description = "ID of the private EC2 instance"
  value       = aws_instance.private[0].id
}

output "public_security_group_id" {
  description = "ID of the public security group"
  value       = aws_security_group.public.id
}

output "private_security_group_id" {
  description = "ID of the private security group"
  value       = aws_security_group.private.id
}
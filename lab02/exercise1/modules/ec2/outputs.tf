output "public_instance_id" {
  description = "ID of the public EC2 instance"
  value       = length(aws_instance.public) > 0 ? aws_instance.private[0].id : null
}

output "private_instance_id" {
  description = "ID of the private EC2 instance"
  value       = length(aws_instance.private) > 0 ? aws_instance.private[0].id : null
}

output "public_security_group_id" {
  description = "ID of the public security group"
  value       = aws_security_group.public.id
}

output "private_security_group_id" {
  description = "ID of the private security group"
  value       = length(aws_instance.private) > 0 ? aws_instance.private[0].id : null
}
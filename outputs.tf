output "enabled" {
  description = "Whether the module is enabled"
  value       = local.enabled
}

output "id" {
  description = "ID of the security group"
  value       = try(aws_security_group.this[0].id, null)
}

output "arn" {
  description = "ARN of the security group"
  value       = try(aws_security_group.this[0].arn, null)
}

output "name" {
  description = "Name of the security group"
  value       = try(aws_security_group.this[0].name, null)
}

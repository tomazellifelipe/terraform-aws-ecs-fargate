output "service_id" {
  description = "ECS service ARN."
  value       = aws_ecs_service.this.id
}

output "service_name" {
  description = "ECS service name."
  value       = aws_ecs_service.this.name
}

output "appautoscaling_resource_id" {
  description = "Scalable resource id."
  value       = aws_appautoscaling_target.this.resource_id
}

output "appautoscaling_scalable_dimension" {
  description = "Scalable dimension of the scalable target."
  value       = aws_appautoscaling_target.this.scalable_dimension
}

output "appautoscaling_service_namespace" {
  description = "AWS service namespace of the scalable target."
  value       = aws_appautoscaling_target.this.service_namespace
}

output "cpu_policy_arn" {
  description = "CPU target tracking policy ARN."
  value       = aws_appautoscaling_policy.cpu_policy.arn
}

output "cpu_policy_name" {
  description = "CPU target tracking policy name."
  value       = aws_appautoscaling_policy.cpu_policy.name
}

output "memory_policy_arn" {
  description = "Memory target tracking policy ARN."
  value       = aws_appautoscaling_policy.memory_policy.arn
}

output "memory_policy_name" {
  description = "Memory target tracking policy name."
  value       = aws_appautoscaling_policy.memory_policy.name
}

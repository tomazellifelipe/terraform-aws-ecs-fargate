resource "aws_ecs_service" "this" {
  name = var.name
  dynamic "alarms" {
    for_each = var.alarms.enable ? [] : [1]
    content {
      alarm_names = alarms.alarm_names
      enable      = alarms.enable
      rollback    = alarms.rollback
    }
  }
  dynamic "capacity_provider_strategy" {
    for_each = var.capacity_provider_strategy
    content {
      base              = capacity_provider_strategy.value.base
      capacity_provider = capacity_provider_strategy.value.capacity_provider
      weight            = capacity_provider_strategy.value.weight
    }
  }
  cluster = var.cluster
  deployment_circuit_breaker {
    enable   = var.deployment_circuit_breaker.enable
    rollback = var.deployment_circuit_breaker.rollback
  }
  deployment_controller {
    type = var.deployment_controller.type
  }
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  desired_count                      = 0
  enable_ecs_managed_tags            = true
  enable_execute_command             = var.enable_execute_command
  force_new_deployment               = var.force_new_deployment
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds
  launch_type                        = "FARGATE"
  dynamic "load_balancer" {
    for_each = var.load_balancer
    content {
      target_group_arn = load_balancer.value.target_group_arn
      container_name   = load_balancer.value.container_name
      container_port   = load_balancer.value.container_port
    }
  }
  network_configuration {
    subnets          = var.network_configuration.subnets
    security_groups  = var.network_configuration.security_groups
    assign_public_ip = var.network_configuration.assign_public_ip
  }
  platform_version = "LATEST"
  propagate_tags   = "TASK_DEFINITION"
  tags             = var.tags
  task_definition  = var.task_definition
  triggers         = var.triggers

  lifecycle {
    ignore_changes = [
      desired_count
    ]
  }
}

resource "aws_appautoscaling_target" "this" {
  max_capacity       = var.appautoscaling_target.max_capacity
  min_capacity       = var.appautoscaling_target.min_capacity
  resource_id        = "service${replace(aws_ecs_service.this.id, "/.+:service/", "")}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "cpu_policy" {
  name               = "CPUTargetTrackingPolicy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
  service_namespace  = aws_appautoscaling_target.this.service_namespace
  target_tracking_scaling_policy_configuration {
    target_value       = var.cpu_policy.target_value
    disable_scale_in   = var.cpu_policy.disable_scale_in
    scale_in_cooldown  = var.cpu_policy.scale_in_cooldown
    scale_out_cooldown = var.cpu_policy.scale_out_cooldown
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}

resource "aws_appautoscaling_policy" "memory_policy" {
  name               = "MemoryTargetTrackingPolicy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
  service_namespace  = aws_appautoscaling_target.this.service_namespace
  target_tracking_scaling_policy_configuration {
    target_value       = var.memory_policy.target_value
    disable_scale_in   = var.memory_policy.disable_scale_in
    scale_in_cooldown  = var.memory_policy.scale_in_cooldown
    scale_out_cooldown = var.memory_policy.scale_out_cooldown
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
  }
}

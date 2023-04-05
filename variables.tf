######################
# ECS SERVICE VALUES #
######################
variable "name" {
  description = "Name of the service (up to 255 letters, numbers, hyphens, and underscores)."
  type        = string
  nullable    = false
}

variable "alarms" {
  description = "CloudWatch alarms for service deployment process."
  type = object({
    alarm_names = list(string)
    enable      = bool
    rollback    = bool
  })
  nullable = false
  default = {
    alarm_names = ["PLACEHOLDER_USE_IF_NEEDED"]
    enable      = false
    rollback    = false
  }
}

variable "capacity_provider_strategy" {
  description = "The capacity provider strategy weight for the service."
  type = list(object({
    base              = optional(number, 0)
    capacity_provider = string
    weight            = number
  }))
  nullable = false
  default = [
    {
      capacity_provider = "FARGATE_SPOT"
      weight            = 100
    }
  ]
}

variable "cluster" {
  description = "ARN of an ECS cluster."
  type        = string
  nullable    = false
}

variable "deployment_circuit_breaker" {
  description = "Enable circuit breacker for ECS service and rollback."
  type = object({
    enable   = bool
    rollback = bool
  })
  nullable = false
  default = {
    enable   = true
    rollback = true
  }
}

variable "deployment_controller" {
  description = "Type of deployment controller. Valid values: CODE_DEPLOY, ECS, EXTERNAL. Default: ECS."
  type = object({
    type = string
  })
  nullable = false
  default = {
    type = "ECS"
  }
}

variable "deployment_maximum_percent" {
  description = "Upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment."
  type        = number
  nullable    = false
  default     = 200
}

variable "deployment_minimum_healthy_percent" {
  description = "Lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment."
  type        = number
  nullable    = false
  default     = 100
}

variable "enable_execute_command" {
  description = "Specifies whether to enable Amazon ECS Exec for the tasks within the service."
  type        = bool
  nullable    = false
  default     = false
}

variable "force_new_deployment" {
  description = "Enable to force a new task deployment of the service."
  type        = bool
  nullable    = false
  default     = true
}

variable "health_check_grace_period_seconds" {
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 2147483647."
  type        = number
  nullable    = false
  default     = 0
}

variable "load_balancer" {
  description = "ARN of the Application Load Balancer target group, container and port to associate with the service."
  type = list(object({
    target_group_arn = string
    container_name   = string
    container_port   = string
  }))
  nullable = false
}

variable "network_configuration" {
  description = "Subnets, security groups and public ip options to assign to the service."
  type = object({
    subnets          = list(string)
    security_groups  = optional(list(string))
    assign_public_ip = optional(bool, false)
  })
  nullable = false
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  nullable    = false
  default     = {}
}

variable "task_definition" {
  description = "Family and revision (family:revision) or full ARN of the task definition that you want to run in your service. If a revision is not specified, the latest ACTIVE revision is used."
  type        = string
  nullable    = false
}

variable "triggers" {
  description = "Map of arbitrary keys and values that, when changed, will trigger an in-place update (redeployment). Useful with timestamp()."
  type        = map(any)
  nullable    = true
  default     = null
}

#########################
# APPAUTOSCALING VALUES #
#########################
variable "appautoscaling_target" {
  description = "Max/Min capacity of the scalable target."
  type = object({
    max_capacity = number
    min_capacity = number
  })
  nullable = false
}

variable "cpu_policy" {
  description = "Target value for CPU to scale in/out and cooldown times in seconds."
  type = object({
    target_value       = number
    disable_scale_in   = optional(bool, false)
    scale_in_cooldown  = optional(number, 300)
    scale_out_cooldown = optional(number, 300)
  })
  nullable = false
  default = {
    target_value = 60
  }
}

variable "memory_policy" {
  description = "Target value for Memory to scale in/out and cooldown times in seconds."
  type = object({
    target_value       = number
    disable_scale_in   = optional(bool, false)
    scale_in_cooldown  = optional(number, 300)
    scale_out_cooldown = optional(number, 300)
  })
  nullable = false
  default = {
    target_value = 60
  }
}

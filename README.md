# terraform-aws-ecs-fargate

# Description
Simple module for an AWS ECS Service running on FARGATE and using an ALB

# FAQ
Q: Why don't you create a target group and ALB ?

A: You can't add a target group to a ecs service without a ALB and ALB is to complex with many options,
another reason is that like this you can add an already created ALB or use a shared one for many services.

Q: Why don't you create a taskDefinition and ECR ?

A: Because a taskDefinition can have many options and would be dificult to know how many containers are needed,
and ECR because it is a simple resouce easy to create and can be used in many places on AWS.

Q: Why do you set desired count to 0 ?

A: That is because you may need to push an ECR image first, or set a pipeline or something like that,
so I don't like that the deploy keeps failing until it is fixed. You can set by hand when it is ready.

<!--- TERRAFORM DOCS BEGIN -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_appautoscaling_policy.cpu_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_policy.memory_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_ecs_service.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarms"></a> [alarms](#input\_alarms) | CloudWatch alarms for service deployment process. | <pre>object({<br>    alarm_names = list(string)<br>    enable      = bool<br>    rollback    = bool<br>  })</pre> | <pre>{<br>  "alarm_names": [<br>    "PLACEHOLDER_USE_IF_NEEDED"<br>  ],<br>  "enable": false,<br>  "rollback": false<br>}</pre> | no |
| <a name="input_appautoscaling_target"></a> [appautoscaling\_target](#input\_appautoscaling\_target) | Max/Min capacity of the scalable target. | <pre>object({<br>    max_capacity = number<br>    min_capacity = number<br>  })</pre> | n/a | yes |
| <a name="input_capacity_provider_strategy"></a> [capacity\_provider\_strategy](#input\_capacity\_provider\_strategy) | The capacity provider strategy weight for the service. | <pre>list(object({<br>    base              = optional(number, 0)<br>    capacity_provider = string<br>    weight            = number<br>  }))</pre> | <pre>[<br>  {<br>    "capacity_provider": "FARGATE_SPOT",<br>    "weight": 100<br>  }<br>]</pre> | no |
| <a name="input_cluster"></a> [cluster](#input\_cluster) | ARN of an ECS cluster. | `string` | n/a | yes |
| <a name="input_cpu_policy"></a> [cpu\_policy](#input\_cpu\_policy) | Target value for CPU to scale in/out and cooldown times in seconds. | <pre>object({<br>    target_value       = number<br>    disable_scale_in   = optional(bool, false)<br>    scale_in_cooldown  = optional(number, 300)<br>    scale_out_cooldown = optional(number, 300)<br>  })</pre> | <pre>{<br>  "target_value": 60<br>}</pre> | no |
| <a name="input_deployment_circuit_breaker"></a> [deployment\_circuit\_breaker](#input\_deployment\_circuit\_breaker) | Enable circuit breacker for ECS service and rollback. | <pre>object({<br>    enable   = bool<br>    rollback = bool<br>  })</pre> | <pre>{<br>  "enable": true,<br>  "rollback": true<br>}</pre> | no |
| <a name="input_deployment_controller"></a> [deployment\_controller](#input\_deployment\_controller) | Type of deployment controller. Valid values: CODE\_DEPLOY, ECS, EXTERNAL. Default: ECS. | <pre>object({<br>    type = string<br>  })</pre> | <pre>{<br>  "type": "ECS"<br>}</pre> | no |
| <a name="input_deployment_maximum_percent"></a> [deployment\_maximum\_percent](#input\_deployment\_maximum\_percent) | Upper limit (as a percentage of the service\'s desiredCount) of the number of running tasks that can be running in a service during a deployment. | `number` | `200` | no |
| <a name="input_deployment_minimum_healthy_percent"></a> [deployment\_minimum\_healthy\_percent](#input\_deployment\_minimum\_healthy\_percent) | Lower limit (as a percentage of the service\'s desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment. | `number` | `100` | no |
| <a name="input_enable_execute_command"></a> [enable\_execute\_command](#input\_enable\_execute\_command) | Specifies whether to enable Amazon ECS Exec for the tasks within the service. | `bool` | `false` | no |
| <a name="input_force_new_deployment"></a> [force\_new\_deployment](#input\_force\_new\_deployment) | Enable to force a new task deployment of the service. | `bool` | `true` | no |
| <a name="input_health_check_grace_period_seconds"></a> [health\_check\_grace\_period\_seconds](#input\_health\_check\_grace\_period\_seconds) | Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 2147483647. | `number` | `0` | no |
| <a name="input_load_balancer"></a> [load\_balancer](#input\_load\_balancer) | ARN of the Application Load Balancer target group, container and port to associate with the service. | <pre>list(object({<br>    target_group_arn = string<br>    container_name   = string<br>    container_port   = string<br>  }))</pre> | n/a | yes |
| <a name="input_memory_policy"></a> [memory\_policy](#input\_memory\_policy) | Target value for Memory to scale in/out and cooldown times in seconds. | <pre>object({<br>    target_value       = number<br>    disable_scale_in   = optional(bool, false)<br>    scale_in_cooldown  = optional(number, 300)<br>    scale_out_cooldown = optional(number, 300)<br>  })</pre> | <pre>{<br>  "target_value": 60<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the service (up to 255 letters, numbers, hyphens, and underscores). | `string` | n/a | yes |
| <a name="input_network_configuration"></a> [network\_configuration](#input\_network\_configuration) | Subnets, security groups and public ip options to assign to the service. | <pre>object({<br>    subnets          = list(string)<br>    security_groups  = optional(list(string))<br>    assign_public_ip = optional(bool, false)<br>  })</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Key-value map of resource tags. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | `map(string)` | `{}` | no |
| <a name="input_task_definition"></a> [task\_definition](#input\_task\_definition) | Family and revision (family:revision) or full ARN of the task definition that you want to run in your service. If a revision is not specified, the latest ACTIVE revision is used. | `string` | n/a | yes |
| <a name="input_triggers"></a> [triggers](#input\_triggers) | Map of arbitrary keys and values that, when changed, will trigger an in-place update (redeployment). Useful with timestamp(). | `map(any)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_appautoscaling_resource_id"></a> [appautoscaling\_resource\_id](#output\_appautoscaling\_resource\_id) | Scalable resource id. |
| <a name="output_appautoscaling_scalable_dimension"></a> [appautoscaling\_scalable\_dimension](#output\_appautoscaling\_scalable\_dimension) | Scalable dimension of the scalable target. |
| <a name="output_appautoscaling_service_namespace"></a> [appautoscaling\_service\_namespace](#output\_appautoscaling\_service\_namespace) | AWS service namespace of the scalable target. |
| <a name="output_cpu_policy_arn"></a> [cpu\_policy\_arn](#output\_cpu\_policy\_arn) | CPU target tracking policy ARN. |
| <a name="output_cpu_policy_name"></a> [cpu\_policy\_name](#output\_cpu\_policy\_name) | CPU target tracking policy name. |
| <a name="output_memory_policy_arn"></a> [memory\_policy\_arn](#output\_memory\_policy\_arn) | Memory target tracking policy ARN. |
| <a name="output_memory_policy_name"></a> [memory\_policy\_name](#output\_memory\_policy\_name) | Memory target tracking policy name. |
| <a name="output_service_id"></a> [service\_id](#output\_service\_id) | ECS service ARN. |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | ECS service name. |
<!--- TERRAFORM DOCS END -->

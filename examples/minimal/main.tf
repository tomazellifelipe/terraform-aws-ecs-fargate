locals {
  container_name = "nginx"
  container_port = 80
}

data "aws_ecs_cluster" "this" {
  cluster_name = "fargate_cluster"
}

data "aws_lb_target_group" "this" {
  # to use this tg with ecs_service it must be attached to an ALB
  name = "simple-service-tg"
}

data "aws_subnets" "this" {
  # use whatever kind of filter you need
  filter {
    name   = "tag:Type"
    values = ["private"]
  }
}

data "aws_security_groups" "this" {
  # use whatever kind of filter you need
  filter {
    name   = "tag:Type"
    values = ["private"]
  }
}

data "aws_iam_policy_document" "ecs_tasks" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "task_execution" {
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks.json
}

resource "aws_iam_role_policy_attachment" "task_execution_aws_managed" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.task_execution.name
}

resource "aws_iam_role" "task" {
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks.json
}

resource "aws_iam_role_policy_attachment" "task_execution_aws_managed" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.task.name
}

resource "aws_ecs_task_definition" "this" {
  family = "simple-task"
  container_definitions = jsonencode([
    {
      name      = local.container_name
      image     = "${local.container_name}:latest"
      cpu       = 0
      essential = true
      portMappings = [
        {
          containerPort = local.container_port
        }
      ]
    }
  ])
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.task_execution.arn
  task_role_arn            = aws_iam_role.task.arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
}

data "aws_ecs_task_definition" "this" {
  family = aws_ecs_task_definition.this.family
}

module "ecs" {
  source = "../../"

  name = "simple-service-alb-fargate"
  appautoscaling_target = {
    max_capacity = 5
    min_capacity = 1
  }
  cluster = data.aws_ecs_cluster.this.arn
  load_balancer = {
    target_group_arn = data.aws_lb_target_group.this.arn
    container_name   = local.container_name
    container_port   = local.container_port # you may pass this value from aws_lb_target_group
  }
  network_configuration = {
    subnets         = data.aws_subnets.this.ids
    security_groups = data.aws_security_groups.this.ids
  }
  task_definition = data.aws_ecs_task_definition.this.arn
}

provider "aws" {
  region     = "${var.region}"
}


/*==== ECR repository to store our Docker images ======
resource "aws_ecr_repository" "alkermes_ecr" {
  name = "${var.repository_name}"
}
*/

resource "aws_ecs_cluster" "Alkermes_ECSCluster" {
  name = "${var.env}-${var.dept}-${var.application}-ECSCluster"

tags {
      Application = "${var.application}"
      Dept        = "${var.dept}"
      Environment = "${var.env}"
      Name        = "${var.env}-${var.dept}-${var.application}-ECSCluster"
      Tier        = "App"
  }
}


// ECS cluster Service role
resource "aws_iam_role" "Alkermes_ECSServiceRole" {
  name               = "${var.env}-${var.dept}-${var.application}-ECSServiceRole"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_service_policy.json}"
}

resource "aws_iam_role_policy_attachment" "ecs_service_role_attachment" {
  role       = "${aws_iam_role.Alkermes_ECSServiceRole.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

data "aws_iam_policy_document" "ecs_service_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

// ECS cluster Task definition Task role
resource "aws_iam_role" "Alkermes_ECSTaskRole" {
  name               = "${var.env}-${var.dept}-${var.application}-ECSTaskRole"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_task_role_policy.json}"
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_attachment1" {
  role       = "${aws_iam_role.Alkermes_ECSTaskRole.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_attachment2" {
  role       = "${aws_iam_role.Alkermes_ECSTaskRole.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonElastiCacheFullAccess"
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_attachment3" {
  role       = "${aws_iam_role.Alkermes_ECSTaskRole.name}"
  policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_attachment4" {
  role       = "${aws_iam_role.Alkermes_ECSTaskRole.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_attachment5" {
  role       = "${aws_iam_role.Alkermes_ECSTaskRole.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}



data "aws_iam_policy_document" "ecs_task_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

// Task definition execution role
resource "aws_iam_role" "Alkermes_ECSTaskExecutionRole" {
  name               = "${var.env}-${var.dept}-${var.application}-ECSTaskExecutionRole"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_task_execution_policy.json}"
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_attachment" {
  role       = "${aws_iam_role.Alkermes_ECSTaskExecutionRole.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "ecs_task_execution_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}


resource "aws_iam_role" "Alkermes_ECSInstanceRole" {
  name               = "${var.env}-${var.dept}-${var.application}-ECSInstanceRole"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_instance_policy.json}"
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_attachment" {
  role       = "${aws_iam_role.Alkermes_ECSInstanceRole.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

data "aws_iam_policy_document" "ecs_instance_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_instance_profile" "Alkermes_ECSInstanceProfile" {
  name = "${var.env}-${var.dept}-${var.application}-ECSInstanceProfile"
  path = "/"
  role = "${aws_iam_role.Alkermes_ECSInstanceRole.id}"
}

resource "aws_iam_role" "Alkermes_ECSAutoscaleRole" {
  name               = "${var.env}-${var.dept}-${var.application}-ECSAutoscaleRole"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_autoscale_policy.json}"
}

resource "aws_iam_policy_attachment" "ecs_autoscale_role_attach" {
  name       = "ecs-autoscale-role-attach"
  roles      = ["${aws_iam_role.Alkermes_ECSAutoscaleRole.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
}

data "aws_iam_policy_document" "ecs_autoscale_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["autoscaling.amazonaws.com"]
    }
  }
}

/* Security Group for Alkermes ECS */
resource "aws_security_group" "Alkermes_ECS_SERVICE_SG" {
  name        = "${var.env}-${var.dept}-${var.application}-ECS-SERVICE-SG"
  vpc_id      = "${var.vpc_id}"
  description = "Allow egress from container"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.ingress_cidr_blocks_self}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Application = "${var.application}"
    Dept        = "${var.dept}"
    Environment = "${var.env}"
    Name        = "${var.env}-${var.dept}-${var.application}-ECS-SERVICE-SG"
    Tier        = "Network"
  }
}

// Security group for Alkermes ECS ALB
resource "aws_security_group" "Alkermes_LB_SG" {
  name        = "${var.env}-${var.dept}-${var.application}-LB-SG"
  description = "Allow HTTP from Anywhere into ALB"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.ingress_cidr_blocks_self}"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.ingress_cidr_blocks_self}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
      Application = "${var.application}"
      Dept        = "${var.dept}"
      Environment = "${var.env}"
      Name        = "${var.env}-${var.dept}-${var.application}-LB-SG"
      Tier        = "Network"
    }
}

// Alkermes ECS Cluster Auto Scale lauch Configuration and Auto scale

data "template_file" "Alkermes_ECS_USER_DATA" {
  template = "${file("userdata.tpl")}"

  vars {
      cluster_name = "${aws_ecs_cluster.Alkermes_ECSCluster.name}"
    }
}

resource "aws_launch_configuration" "Alkermes_ECS_AUTOSCALE_CONF" {
  name                        = "${var.env}-${var.dept}-${var.application}-ECS-AUTOSCALE-CONF"
  image_id                    = "${var.ecs_container_instance_image}"
  instance_type               = "${var.ecs_container_instance_type}"
  iam_instance_profile        = "${aws_iam_instance_profile.Alkermes_ECSInstanceProfile.id}"
  security_groups             = ["${aws_security_group.Alkermes_ECS_SERVICE_SG.id}"]
  key_name                    = "${var.alkermes_ecs_key_pair_name}"
  associate_public_ip_address = false
  user_data                   = "${data.template_file.Alkermes_ECS_USER_DATA.rendered}"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "${var.instance_root_volume_size}"
    delete_on_termination = true
  }

  ebs_block_device {
    device_name           = "/dev/sdg"
    volume_type           = "gp2"
    volume_size           = "${var.instance_ebs_volume_size}"
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "Alkermes_AUTOSCALE_GR" {
  name                 = "${var.env}-${var.dept}-${var.application}-ECS-AUTOSCALE-GR"
  max_size             = "${var.ecs_container_instance_max_instance_size}"
  min_size             = "${var.ecs_container_instance_min_instance_size}"
  desired_capacity     = "${var.ecs_container_instance_desired_capacity}"
  vpc_zone_identifier  = ["${var.app_subnets}"]
  launch_configuration = "${aws_launch_configuration.Alkermes_ECS_AUTOSCALE_CONF.name}"
  health_check_type    = "${var.ecs_container_instance_health_check_type}"
  tags {
  key         = "Name"
  value       = "${var.env}-${var.dept}-${var.application}-ECS-Instance"
  propagate_at_launch = true
}

}

// Target group for Alkermes ECS ALB
resource "aws_alb_target_group" "Alkermes_LB_TG" {
  name        = "${var.env}-${var.dept}-${var.application}-LB-TG"
  port        = "${var.alb_target_group_port}"
  protocol    = "${var.alb_target_group_protocol}"
  vpc_id      = "${var.vpc_id}"
  target_type = "${var.alb_target_group_target_type}"

  lifecycle {
    create_before_destroy = true
  }

  tags {
      Application = "${var.application}"
      Dept        = "${var.dept}"
      Environment = "${var.env}"
      Name        = "${var.env}-${var.dept}-${var.application}-LB-TG"
      Tier        = "Network"
    }
}

resource "aws_alb" "Alkermes_LB" {
  name            = "${var.env}-${var.dept}-${var.application}-LB"
  subnets         = ["${var.app_subnets}"]
  security_groups = ["${aws_security_group.Alkermes_LB_SG.id}"]
# security_groups = ["${aws_security_group.task_api_alb_sg.id}"]

  tags {
    Application = "${var.application}"
    Dept        = "${var.dept}"
    Environment = "${var.env}"
    Name        = "${var.env}-${var.dept}-${var.application}-LB"
    Tier        = "Network"
  }
}

resource "aws_alb_listener" "Alkermes_LB_LISTENER" {
  load_balancer_arn = "${aws_alb.Alkermes_LB.arn}"
  port              = "${var.alb_listener_port}"
  protocol          = "${var.alb_listener_protocol}"
  depends_on        = ["aws_alb_target_group.Alkermes_LB_TG"]

  default_action {
    target_group_arn = "${aws_alb_target_group.Alkermes_LB_TG.arn}"
    type             = "forward"
  }
}

data "template_file" "Alkermes_IMAGEFILE" {
  template = "${file("Alkermes.json")}"

  vars{
  image_1= "${var.ecs_image_url}" // this will be user input in the Jenkins pipeline
  }
}

resource "aws_ecs_task_definition" "Alkermes_TASK_DF"{
  family                   = "${var.env}-${var.dept}-${var.application}-TASK-DF"
  requires_compatibilities = ["${var.ecs_task_df_comp}"]
  cpu                      = "${var.ecs_task_df_cpu}"
  memory                   = "${var.ecs_task_df_mem}"
  container_definitions    = "${data.template_file.Alkermes_IMAGEFILE.rendered}"
  execution_role_arn       = "${aws_iam_role.Alkermes_ECSTaskExecutionRole.arn}"
  task_role_arn            = "${aws_iam_role.Alkermes_ECSTaskRole.arn}"
  network_mode             = "${var.ecs_task_df_network_mode}"

  tags {
      Application = "${var.application}"
      Dept        = "${var.dept}"
      Environment = "${var.env}"
      Name        = "${var.env}-${var.dept}-${var.application}-TASK-DF"
      Tier        = "App"
      }

 }


/*Alkermes ECS service */

/* Simply specify the family to find the latest ACTIVE revision in that Task definition family */
data "aws_ecs_task_definition" "Alkermes_TASK_DF" {
 depends_on = ["aws_ecs_task_definition.Alkermes_TASK_DF"]
 task_definition = "${aws_ecs_task_definition.Alkermes_TASK_DF.family}"
}

resource "aws_ecs_service" "Alkermes_ECS_SERVICE" {
  name            = "${var.env}-${var.dept}-${var.application}-ECS-SERVICE"
  task_definition = "${aws_ecs_task_definition.Alkermes_TASK_DF.family}:${max("${aws_ecs_task_definition.Alkermes_TASK_DF.revision}", "${data.aws_ecs_task_definition.Alkermes_TASK_DF.revision}")}"
  desired_count   = "${var.ecs_service_desired_count}"
  deployment_minimum_healthy_percent = "${var.ecs_deployment_min_healthy_percent}"
  deployment_maximum_percent         = "${var.ecs_deployment_max_percent}"
  launch_type                        = "${var.ecs_service_launch_type}"
  scheduling_strategy                = "${var.ecs_service_scheduling_strategy}"
  cluster                            = "${aws_ecs_cluster.Alkermes_ECSCluster.id}"


  network_configuration {
    security_groups = ["${aws_security_group.Alkermes_ECS_SERVICE_SG.id}"]
    subnets         = ["${var.app_subnets}"]
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.Alkermes_LB_TG.arn}"
    container_name   = "${var.ecs_service_container_name}"
    container_port   = "${var.ecs_service_container_port}"
  }


depends_on = ["aws_alb_target_group.Alkermes_LB_TG","aws_alb_listener.Alkermes_LB_LISTENER"]

}

resource "aws_appautoscaling_target" "Alkermes_ECS_TASK_AUTOSCALE" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.Alkermes_ECSCluster.name}/${aws_ecs_service.Alkermes_ECS_SERVICE.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  role_arn           = "${aws_iam_role.Alkermes_ECSAutoscaleRole.arn}"
  min_capacity       = "${var.ecs_task_autoscale_min_capacity}"
  max_capacity       = "${var.ecs_task_autoscale_min_capacity}"
}

resource "aws_appautoscaling_policy" "Alkermes_ECS_TASK_AUTOSCALE_POLICY_UP" {
  name                    = "${var.env}-${var.dept}-${var.application}_ECS_TASK_AUTOSCALE_POLICY_UP"
  service_namespace       = "ecs"
  resource_id             = "service/${aws_ecs_cluster.Alkermes_ECSCluster.name}/${aws_ecs_service.Alkermes_ECS_SERVICE.name}"
  scalable_dimension      = "ecs:service:DesiredCount"


  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = "${var.ecs_task_auto_scale_up_cooldown_seconds}"
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = "${var.ecs_task_auto_scale_metric_interval_lower_bound}"
      scaling_adjustment = "${var.ecs_task_auto_scale_up_scaling_adjustment}"
    }
  }

  depends_on = ["aws_appautoscaling_target.Alkermes_ECS_TASK_AUTOSCALE"]
}

resource "aws_appautoscaling_policy" "Alkermes_ECS_TASK_AUTOSCALE_POLICY_DOWN" {
  name                    = "${var.env}-${var.dept}-${var.application}_ECS_TASK_AUTOSCALE_POLICY_DOWN"
  service_namespace       = "ecs"
  resource_id             = "service/${aws_ecs_cluster.Alkermes_ECSCluster.name}/${aws_ecs_service.Alkermes_ECS_SERVICE.name}"
  scalable_dimension      = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = "${var.ecs_task_auto_scale_down_cooldown_seconds}"
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = "${var.ecs_task_auto_scale_metric_interval_lower_bound}"
      scaling_adjustment = "${var.ecs_task_auto_scale_down_scaling_adjustment}"
    }
  }

  depends_on = ["aws_appautoscaling_target.Alkermes_ECS_TASK_AUTOSCALE"]
}

/* Cloud Watch metrics high used for auto scale */
resource "aws_cloudwatch_metric_alarm" "Alkermes_ECS_TASK_ClOUDWATCH_ALARM_HIGH" {
  alarm_name          = "${var.env}-${var.dept}-${var.application}-ECS-TASK-ClOUDWATCH-ALARM-HIGH"
  comparison_operator = "${var.ecs_cloudwatch_comparison_operator_high}"
  evaluation_periods  = "${var.ecs_cloudwatch_evaluation_periods}"
  metric_name         = "${var.ecs_cloudwatch_metric_name}"
  namespace           = "AWS/ECS"
  period              = "${var.ecs_cloudwatch_metric_period}"
  statistic           = "${var.ecs_cloudwatch_metric_statistic}"
  threshold           = "${var.ecs_cloudwatch_metric_threshold}"

  dimensions {
    ClusterName = "${aws_ecs_cluster.Alkermes_ECSCluster.name}"
    ServiceName = "${aws_ecs_service.Alkermes_ECS_SERVICE.name}"
  }

  alarm_actions = ["${aws_appautoscaling_policy.Alkermes_ECS_TASK_AUTOSCALE_POLICY_UP.arn}"]

  tags {
    Application = "${var.application}"
    Dept        = "${var.dept}"
    Environment = "${var.env}"
    Name        = "${var.env}-${var.dept}-${var.application}-ECS-TASK-ClOUDWATCH-ALARM-HIGH"
    Tier        = "App"
    }
}

/* Cloud Watch metrics low used for auto scale */
resource "aws_cloudwatch_metric_alarm" "Alkermes_ECS_TASK_ClOUDWATCH_ALARM_LOW" {
  alarm_name          = "${var.env}-${var.dept}-${var.application}-ECS-TASK-ClOUDWATCH-ALARM-LOW"
  comparison_operator = "${var.ecs_cloudwatch_comparison_operator_low}"
  evaluation_periods  = "${var.ecs_cloudwatch_evaluation_periods}"
  metric_name         = "${var.ecs_cloudwatch_metric_name}"
  namespace           = "AWS/ECS"
  period              = "${var.ecs_cloudwatch_metric_period}"
  statistic           = "${var.ecs_cloudwatch_metric_statistic}"
  threshold           = "${var.ecs_cloudwatch_metric_threshold}"

  dimensions {
    ClusterName = "${aws_ecs_cluster.Alkermes_ECSCluster.name}"
    ServiceName = "${aws_ecs_service.Alkermes_ECS_SERVICE.name}"
  }

  alarm_actions = ["${aws_appautoscaling_policy.Alkermes_ECS_TASK_AUTOSCALE_POLICY_DOWN.arn}"]

  tags {
    Application = "${var.application}"
    Dept        = "${var.dept}"
    Environment = "${var.env}"
    Name        = "${var.env}-${var.dept}-${var.application}-ECS-TASK-ClOUDWATCH-ALARM-LOW"
    Tier        = "App"
    }
}

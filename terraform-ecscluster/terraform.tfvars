//VPC connection details
region = "us-east-1"
application = "Alkermes"
dept = "IT"
env = "Dev"
tier = "[web,app,db,network]"
owner = "owner"
alkermes_ecs_key_pair_name="Biswa-DIP"
aws_access_key_id = ""
aws_secret_access_key = ""
vpc_id = "vpc-029db53727720f03b"
vpc_cidr="16.0.0.0/16" # Need to change the value
az= ["us-east-1a"]
#web_subnets_cidr = ["10.194.0.0/24","10.194.1.0/24"]
#app_subnets_cidr = ["10.194.2.0/23","10.194.6.0/24"]
app_subnets      = ["subnet-003761998c7ae7640","subnet-0bbf4cbc783e4d27d"]
web_subnets      = ["subnet-01a180a3516193c59","subnet-0f6b146089a8e2053"]
ingress_cidr_blocks_self = "71.244.135.202/32"

//ECS Load Balancer details
alb_target_group_port = "80"
alb_target_group_protocol= "HTTP"
alb_target_group_target_type= "ip"
alb_listener_port = "80"
alb_listener_protocol = "HTTP"

// Task definition details
ecs_image_url = "163639306272.dkr.ecr.us-east-1.amazonaws.com/biswatestecr:latest"
ecs_task_df_comp = ["EC2"]
ecs_task_df_cpu= "1vcpu"
ecs_task_df_mem= "1024"
ecs_task_df_network_mode ="awsvpc"
app_env_value = "aws.dev"
s3bucket_name = "alkermes-conf"

//Auto scaling group details
instance_root_volume_size = "100"
instance_ebs_volume_size = "100"
ecs_container_instance_image = "ami-0be9e1908fe51a590"
ecs_container_instance_type = "t3.small"
ecs_container_instance_max_instance_size = "1"
ecs_container_instance_min_instance_size = "1"
ecs_container_instance_desired_capacity = "1"
ecs_container_instance_health_check_type = "EC2"


// ECS service
ecs_service_desired_count = "1"
ecs_deployment_min_healthy_percent= "100"
ecs_deployment_max_percent= "200"
ecs_service_launch_type = "EC2"
ecs_service_scheduling_strategy = "REPLICA"
ecs_service_container_name = "alkermes-dev"
ecs_service_container_port = "80"


//ECS service task auto scale
ecs_task_autoscale_min_capacity = "1"
cs_task_autoscale_max_capacity = "1"
ecs_task_auto_scale_up_cooldown_seconds = "60"
ecs_task_auto_scale_metric_interval_lower_bound = "0"
ecs_task_auto_scale_up_scaling_adjustment = "1"
ecs_task_auto_scale_down_cooldown_seconds = "60"
ecs_task_auto_scale_down_scaling_adjustment = "-1"
ecs_cloudwatch_comparison_operator_high = "GreaterThanOrEqualToThreshold"
ecs_cloudwatch_evaluation_periods = "2"
ecs_cloudwatch_metric_name = "CPUUtilization"
ecs_cloudwatch_metric_period = "60"
ecs_cloudwatch_metric_statistic = "Maximum"
ecs_cloudwatch_metric_threshold = "60"
ecs_cloudwatch_comparison_operator_low = "LessThanThreshold"

//ECR details
repository_name = "alkermesecr"

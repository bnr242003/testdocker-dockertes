variable "region" {
  type        = "string"
  default     = ""
  description = "AWS region"
}

variable "application" {
  type    = "string"
  default = ""
}

variable "dept" {
  type    = "string"
  default = ""
}

variable "env" {
  type    = "string"
  default = ""
}

variable "tier" {
  type    = "string"
  default = ""
}

variable "owner" {
  type    = "string"
  default = ""
}
variable "aws_access_key_id" {
  type = "string"
  default = ""
  description = "AWS access key"
  }
variable "aws_secret_access_key" {
  type = "string"
  default = ""
  description = "AWS secret access key"
  }
variable "alkermes_ecs_key_pair_name" {
  type = "string"
  default = ""
 description = "EC2 instance key pair name"
  }
variable "vpc_id" {
  type = "string"
  default = ""
  description = "VPC name for PHP-API environment"
 }
variable "vpc_cidr" {
  type = "string"
  default = ""
 }
variable "az"{
  type = "list"
  default = [""]
  description = "Availability zones of the php-api"
 }
variable "web_subnets_cidr" {
 type    = "list"
 default = [""]
 }
variable "app_subnets_cidr" {
  type = "list"
  description = "The IP address range range for the app subnets"
  default = [""]
  }
variable "web_subnets" {
   type    = "list"
   default = [""]
  }
  variable "app_subnet" {
    type    = "list"
    default = [""]
   }
variable "app_subnets" {
       type    = "list"
       default = [""]
      }
########################### Security_group ###############################
variable "ingress_cidr_blocks_self" {
    type    = "string"
    default = ""
    }

########################### Task definition Config ################################

variable "ecs_task_df_comp" {
  type = "list"
  default = [""]
   }
variable "ecs_task_df_cpu"{
  type = "string"
  default = ""
  }
variable "ecs_task_df_mem"{
  type = "string"
  default = ""
  }
variable "ecs_task_df_network_mode" {
  type = "string"
  default = ""
 }

 variable "ecs_image_url" {
  type = "string"
  default = ""
 }
   variable "app_env_value" {
  type = "string"
  default = ""
 }

variable "s3bucket_name" {
  type = "string"
  default = ""
 }
########################### ECS alb set up ################################
variable "alb_target_group_port" {
  type = "string"
  default = ""
}
variable "alb_target_group_protocol" {
  type = "string"
  default = ""
}
variable "alb_target_group_target_type" {
  type = "string"
  default = ""
}
variable "alb_listener_port" {
  type = "string"
  default = ""
}
variable "alb_listener_protocol" {
  type = "string"
  default = ""
}
########################### Autoscale Config ################################
variable "instance_root_volume_size" {
  type    = "string"
  default = ""
}

variable "instance_ebs_volume_size" {
  type    = "string"
  default = ""
}
variable "ecs_container_instance_image" {
  type = "string"
  default = ""
 }
variable "ecs_container_instance_type" {
  type = "string"
  default = ""
 }
variable "ecs_container_instance_max_instance_size" {
  type = "string"
  default = ""
  description = "Maximum number of instances in the cluster"
 }
variable "ecs_container_instance_min_instance_size" {
  type = "string"
  default = ""
  description = "Minimum number of instances in the cluster"
 }
variable "ecs_container_instance_desired_capacity" {
  type = "string"
  default = ""
  description = "Desired number of instances in the cluster"
 }
variable "ecs_container_instance_health_check_type" {
   type = "string"
   default = ""
   description = "The ECS Container instance health check type"
  }
########################### ECS container service  ###################ecs_container_instance_health_check_type#############
variable "ecs_service_desired_count" {
   type = "string"
   default = ""
   }
variable "ecs_deployment_min_healthy_percent" {
  type = "string"
  default = ""
  }
variable "ecs_deployment_max_percent" {
  type = "string"
  default = ""
 }
variable "ecs_service_launch_type" {
    type = "string"
    default = ""
    }
variable "ecs_service_scheduling_strategy" {
        type = "string"
        default = ""
        }
variable "ecs_service_container_name" {
        type = "string"
        default = ""
        }
variable "ecs_service_container_port" {
    type = "string"
    default = ""
      }

########################### ECS container service task auto scale ################################
variable "ecs_task_autoscale_min_capacity" {
  type = "string"
  default = ""
 }
variable "ecs_task_autoscale_max_capacity" {
   type = "string"
   default = ""
  }
variable "ecs_task_auto_scale_up_cooldown_seconds" {
  type = "string"
  default = ""
 }
variable "ecs_task_auto_scale_metric_interval_lower_bound" {
   type = "string"
   default = ""
  }
variable "ecs_task_auto_scale_up_scaling_adjustment" {
     type = "string"
     default = ""
    }
variable "ecs_task_auto_scale_down_cooldown_seconds" {
   type = "string"
   default = ""
  }
variable "ecs_task_auto_scale_down_scaling_adjustment" {
     type = "string"
     default = ""
    }
variable "ecs_cloudwatch_comparison_operator_high" {
         type = "string"
         default = ""
        }
variable "ecs_cloudwatch_evaluation_periods" {
  type = "string"
  default = ""
  }
variable "ecs_cloudwatch_metric_name" {
  type = "string"
  default = ""
 }
 variable "ecs_cloudwatch_metric_period" {
   type = "string"
   default = ""
  }
variable "ecs_cloudwatch_metric_statistic" {
    type = "string"
    default = ""
   }
variable "ecs_cloudwatch_metric_threshold" {
   type = "string"
   default = ""
  }
variable "ecs_cloudwatch_comparison_operator_low" {
  type = "string"
           default = ""
    }
########################### ECR details ################################

variable "repository_name" {
  type = "string"
  default = ""
 }

resource "aws_launch_configuration" "ecs-launch-configuration" {
  name                        = "${var.name}-ecs-launch-configuration"
  image_id                    = "ami-062022418ff822030"
  instance_type               = "t2.micro"
  iam_instance_profile        = aws_iam_instance_profile.ecs-instance-profile.id

//  ebs_block_device {
//    device_name = "/dev/xvdcz"
//    volume_size = 30
//    volume_type = "gp2"
//  }
  root_block_device {
    volume_type = "standard"
    volume_size = 22
    delete_on_termination = true
  }

  security_groups             = [aws_security_group.ecs_dynamic-mapping-sg.id]
  associate_public_ip_address = "true"
  key_name                    = aws_key_pair.this.key_name
  user_data                   = <<EOF
                                  #!/bin/bash
                                  echo ECS_CLUSTER=${aws_ecs_cluster.this.name} >> /etc/ecs/ecs.config
                                  echo ECS_BACKEND_HOST= >> /etc/ecs/ecs.config
                                  EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ecs_asg" {
  name = "${var.name}-ecs-asg"
  max_size = 1
  min_size = 0
  desired_capacity = 1
  launch_configuration = aws_launch_configuration.ecs-launch-configuration.name
  health_check_grace_period = 0
  health_check_type = "EC2"
  availability_zones = var.az_list
  vpc_zone_identifier = var.public_subnets

  tag {
    key = "Name"
    propagate_at_launch = false
    value = "${var.name}-ECS-service-instance"
  }

  lifecycle {
    create_before_destroy = true
  }
}

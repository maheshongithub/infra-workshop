resource "aws_autoscaling_group" "asg" {
  name_prefix = "${var.service_name}_asg_"

  vpc_zone_identifier = data.aws_subnet_ids.private_subnet_ids.ids

  target_group_arns = [aws_lb_target_group.target_group.arn]

  max_size         = var.asg_max
  min_size         = var.asg_min
  desired_capacity = var.asg_desired

  health_check_grace_period = 300
  health_check_type         = "EC2"

  wait_for_capacity_timeout = "5m"
  min_elb_capacity          = "1"
  wait_for_elb_capacity     = "1"

  tags = [
    {
      key                 = "Name"
      value               = var.service_name
      propagate_at_launch = true
    }
  ]

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = aws_launch_template.launch_template.latest_version
  }

  force_delete = true
}

resource "aws_launch_template" "launch_template" {
  name_prefix   = "${var.service_name}_lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.key_pair.key_name

  iam_instance_profile {
    name = "${var.service_name}_instance_profile"
  }

  user_data              = var.user_data
  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.ebs_volume_size
      encrypted   = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "instance_sg" {
  name   = "${var.service_name}_instance_sg"
  vpc_id = data.aws_vpc.vpc.id
  ingress {
    from_port   = var.target_port
    protocol    = "TCP"
    to_port     = var.target_port
    cidr_blocks = [data.aws_vpc.vpc.cidr_block]
  }
  ingress {
    from_port   = 22
    protocol    = "TCP"
    to_port     = 22
    cidr_blocks = [data.aws_vpc.vpc.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.service_name}_instance_sg"
  }
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.service_name
  public_key = var.public_key_content
}

provider "aws" {
  region = var.aws_region
  #   shared_credentials_files = ["./credentials/credentials"]
  shared_credentials_files = ["C://Users//Administrator//.aws//credentials"]
}

# AWS Region 변수를 정의합니다.
variable "aws_region" {
  default = "us-east-1"
}

# Auto Scaling Group에서 사용될 EC2 인스턴스 유형을 정의합니다.
variable "instance_type" {
  default = "t2.micro"
}

# EC2 인스턴스에 연결할 Key Pair의 이름을 정의합니다.
variable "key_name" {
  default = "my-key"
}

resource "aws_key_pair" "my_keypair" {
  key_name   = var.key_name
  public_key = file("C://Users//Administrator//.ssh//id_rsa.pub")
}

# 사용할 AMI ID를 정의합니다.
variable "ami_id" {
  default = "ami-0c94855ba95c71c99"
}

# VPC와 Public Subnet을 생성하는 코드를 작성합니다.
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "10.0.0.0/24"
  availability_zone = "${var.aws_region}a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public"
  }
}

# Security Group을 생성하는 코드를 작성합니다.
resource "aws_security_group" "web_security_group" {
  name_prefix = "web-security-group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch Template을 생성하는 코드를 작성합니다.
resource "aws_launch_template" "web_launch_template" {
  name_prefix   = "web-launch-template"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  # 위에서 생성한 Security Group ID를 지정합니다.
  vpc_security_group_ids = ["${aws_security_group.web_security_group.id}"]

  # EC2 인스턴스를 구성하기 위한 User Data를 작성합니다.
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World!" > index.html
              nohup python -m SimpleHTTPServer 80 &
              EOF

  tag_specifications {
    resource_type = "instance"

    # EC2 인스턴스에 Name 태그를 추가합니다.
    tags = {
      Name = "web-instance"
    }
  }
}

# Private Subnet을 생성하는 코드를 작성합니다.
resource "aws_subnet" "private" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"
  tags = {
    Name = "private"
  }
}

# Auto Scaling Group을 생성하는 코드를 작성합니다.
resource "aws_autoscaling_group" "web_autoscaling_group" {
  name                 = "web-autoscaling-group"
  vpc_zone_identifier  = ["${aws_subnet.private.id}"]
  launch_template {
    id      = aws_launch_template.web_launch_template.id
    version = "$Latest"
  }
  desired_capacity     = 1
  min_size             = 1
  max_size             = 3
  health_check_grace_period = 300
  health_check_type = "EC2"
  # Auto Scaling Group에 Name 태그를 추가합니다.
  tag {
    key                 = "Name"
    value               = "web-instance"
    propagate_at_launch = true
  }
}

# Application Load Balancer를 생성하는 코드를 작성합니다.
resource "aws_lb" "main" {
  name               = "web-lb"
  internal           = false
  load_balancer_type = "application"

  # Public Subnet과 Private Subnet을 연결합니다.
  subnets            = ["${aws_subnet.public.id}", "${aws_subnet.private.id}"]
  security_groups    = ["${aws_security_group.lb_security_group.id}"]

  tags = {
    Name = "web-lb"
  }
}

# Target Group을 생성하는 코드를 작성합니다.
resource "aws_lb_target_group" "web_target_group" {
  name_prefix = "web-tg"

  port        = 80
  protocol    = "HTTP"

  # 위에서 생성한 VPC ID를 지정합니다.
  vpc_id      = "${aws_vpc.main.id}"

  health_check {
    path     = "/"
    interval = 30
    timeout  = 10
  }

  # Auto Scaling Group에서 생성된 EC2 인스턴스를 Target으로 지정합니다.
  depends_on = [
    aws_autoscaling_group.web_autoscaling_group,
  ]

  lifecycle {
    create_before_destroy = true
  }
}

# Listener를 생성하는 코드를 작성합니다.
resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = "${aws_lb.main.arn}"
  port              = "80"
  protocol          = "HTTP"

  # 위에서 생성한 Target Group을 지정합니다.
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.web_target_group.arn}"
  }
}

# Security Group을 생성하는 코드를 작성합니다.
resource "aws_security_group" "lb_security_group" {
  name_prefix = "lb-security-group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"

    # Public Subnet에서 Application Load Balancer에 접속할 수 있도록 CIDR 블록을 지정합니다.
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"

    # Private Subnet에서 외부와 통신할 수 있도록 CIDR 블록을 지정합니다.
    cidr_blocks = ["0.0.0.0/0"]
  }
}

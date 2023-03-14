# Application Load Balancer를 생성하는 코드를 작성합니다.
resource "aws_lb" "web_lb" {
  name               = "web-lb"
  internal           = false
  load_balancer_type = "application"

  # Load Balancer와 Public Subnet을 연결합니다.
  subnets         = ["${aws_subnet.public_subnet1.id}", "${aws_subnet.public_subnet2.id}"]
  security_groups = ["${aws_security_group.web_lb_security_group.id}"]

  tags = {
    Name = "web-lb"
  }
}

# Application Load Balancer를 생성하는 코드를 작성합니다.
resource "aws_lb" "was_lb" {
  name               = "was-lb"
  internal           = true
  load_balancer_type = "application"

  # Load Balancer와 web Subnet을 연결합니다.
  subnet_mapping {
    subnet_id = aws_subnet.was_subnet1.id
  }
  subnet_mapping {
    subnet_id = aws_subnet.was_subnet2.id
  }

  security_groups = ["${aws_security_group.was_lb_security_group.id}"]

  tags = {
    Name = "was-lb"
  }
}

# Target Group을 생성하는 코드를 작성합니다.
resource "aws_lb_target_group" "web_target_group" {
  name_prefix = "web-tg"

  port     = 80
  protocol = "HTTP"

  # 위에서 생성한 VPC ID를 지정합니다.
  vpc_id = aws_vpc.main.id

  target_type = "instance"

  health_check {
    path     = "/"
    interval = 12
    timeout  = 4
  }

  #Target Group이 생성되기 전에 아래 리소스 생성을 기다림
  depends_on = [
    aws_autoscaling_group.web_autoscaling_group,
  ]

  lifecycle {
    create_before_destroy = true
  }
}

# Target Group을 생성하는 코드를 작성합니다.
resource "aws_lb_target_group" "was_target_group" {
  name_prefix = "was-tg"

  port     = 8000
  protocol = "HTTP"

  # 위에서 생성한 VPC ID를 지정합니다.
  vpc_id = aws_vpc.main.id

  target_type = "instance"

  health_check {
    path     = "/proxy/"
    interval = 12
    timeout  = 4
  }

  #Target Group이 생성되기 전에 아래 리소스 생성을 기다림
  depends_on = [
    aws_autoscaling_group.was_autoscaling_group,
  ]

  lifecycle {
    create_before_destroy = true
  }
}

# Listener를 생성하는 코드를 작성합니다.
resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = "80"
  protocol          = "HTTP"

  # 위에서 생성한 Target Group을 지정합니다.
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_target_group.arn
  }
}

# Listener를 생성하는 코드를 작성합니다.
resource "aws_lb_listener" "was_listener" {
  load_balancer_arn = aws_lb.was_lb.arn
  port              = "8000"
  protocol          = "HTTP"

  # 위에서 생성한 Target Group을 지정합니다.
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.was_target_group.arn
  }
}
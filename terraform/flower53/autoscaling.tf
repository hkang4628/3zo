# Auto Scaling Group을 생성하는 코드를 작성합니다.
resource "aws_autoscaling_group" "web_autoscaling_group" {
  name                = "web-autoscaling-group"
  vpc_zone_identifier = ["${aws_subnet.web_subnet1.id}", "${aws_subnet.web_subnet2.id}"]

  launch_template {
    id      = aws_launch_template.web_launch_template.id
    version = "$Latest"
  }
  desired_capacity          = var.web_autoscaling_group["desired_capacity"]
  min_size                  = var.web_autoscaling_group["min_size"]
  max_size                  = var.web_autoscaling_group["max_size"]
  health_check_grace_period = 300
  health_check_type         = "ELB"

  # Auto Scaling Group에 Name 태그를 추가합니다.
  tag {
    key                 = "Name"
    value               = "web-instance"
    propagate_at_launch = true
  }
  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }
}

# Auto Scaling Group을 생성하는 코드를 작성합니다.
resource "aws_autoscaling_group" "was_autoscaling_group" {
  name                = "was-autoscaling-group"
  vpc_zone_identifier = ["${aws_subnet.was_subnet1.id}", "${aws_subnet.was_subnet2.id}"]

  launch_template {
    id      = aws_launch_template.was_launch_template.id
    version = "$Latest"
  }
  desired_capacity          = var.was_autoscaling_group["desired_capacity"]
  min_size                  = var.was_autoscaling_group["min_size"]
  max_size                  = var.was_autoscaling_group["max_size"]
  health_check_grace_period = 300
  health_check_type         = "ELB"

  # Auto Scaling Group에 Name 태그를 추가합니다.
  tag {
    key                 = "Name"
    value               = "was-instance"
    propagate_at_launch = true
  }
  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }
}

#Auto Scaling Group에 LB를 연결한다.
resource "aws_autoscaling_attachment" "web_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.web_autoscaling_group.id
  lb_target_group_arn    = aws_lb_target_group.web_target_group.arn
}

#Auto Scaling Group에 LB를 연결한다.
resource "aws_autoscaling_attachment" "was_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.was_autoscaling_group.id
  lb_target_group_arn    = aws_lb_target_group.was_target_group.arn
}
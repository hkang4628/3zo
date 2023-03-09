provider "aws" {
  region = var.aws_region
  #   shared_credentials_files = ["./credentials/credentials"]
  shared_credentials_files = ["C://Users//Administrator//.aws//credentials"]
}

resource "aws_key_pair" "my_keypair" {
  key_name   = var.key_name
  public_key = file("C://Users//Administrator//.ssh//id_rsa.pub")
}

# VPC와 Public Subnet을 생성하는 코드를 작성합니다.
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet1"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet2"
  }
}

# Private Subnet을 생성하는 코드를 작성합니다.
resource "aws_subnet" "web_subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "${var.aws_region}a"
  tags = {
    Name = "web_subnet1"
  }
}

resource "aws_subnet" "web_subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "${var.aws_region}b"
  tags = {
    Name = "web_subnet2"
  }
}

resource "aws_subnet" "was_subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = "${var.aws_region}a"
  tags = {
    Name = "was_subnet1"
  }
}

resource "aws_subnet" "was_subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.21.0/24"
  availability_zone = "${var.aws_region}b"
  tags = {
    Name = "was_subnet2"
  }
}

resource "aws_subnet" "db_subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.30.0/24"
  availability_zone = "${var.aws_region}a"
  tags = {
    Name = "db_subnet1"
  }
}

resource "aws_subnet" "db_subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.31.0/24"
  availability_zone = "${var.aws_region}b"
  tags = {
    Name = "db_subnet2"
  }
}

# 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Main IGW"
  }
}

# 퍼블릭 라우트 테이블 생성
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Public RT"
  }
}

# 퍼블릭 서브넷과 라우트 테이블 연결1
resource "aws_route_table_association" "public_rta1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_rt.id
}
# 퍼블릭 서브넷과 라우트 테이블 연결2
resource "aws_route_table_association" "public_rta2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_rt.id
}

# NAT Gateway 생성
resource "aws_nat_gateway" "ngw1" {
  allocation_id = aws_eip.eip1.id
  subnet_id     = aws_subnet.public_subnet1.id
}
# NAT Gateway 생성
resource "aws_nat_gateway" "ngw2" {
  allocation_id = aws_eip.eip2.id
  subnet_id     = aws_subnet.public_subnet2.id
}

# NAT Gateway가 사용할 EIP(Elastic IP) 생성
resource "aws_eip" "eip1" {
  vpc = true
}
# NAT Gateway가 사용할 EIP(Elastic IP) 생성
resource "aws_eip" "eip2" {
  vpc = true
}

# 프라이빗 라우트 테이블 생성1
resource "aws_route_table" "private_rt1" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw1.id
  }
  tags = {
    Name = "Private RT1"
  }
}

# 프라이빗 라우트 테이블 생성2
resource "aws_route_table" "private_rt2" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw2.id
  }
  tags = {
    Name = "Private RT2"
  }
}

# 프라이빗 서브넷과 라우트 테이블 연결1
resource "aws_route_table_association" "private_rta1" {
  subnet_id      = aws_subnet.web_subnet1.id
  route_table_id = aws_route_table.private_rt1.id
}

# 프라이빗 서브넷과 라우트 테이블 연결2
resource "aws_route_table_association" "private_rta2" {
  subnet_id      = aws_subnet.web_subnet2.id
  route_table_id = aws_route_table.private_rt2.id
}

# 프라이빗 서브넷과 라우트 테이블 연결3
resource "aws_route_table_association" "private_rta3" {
  subnet_id      = aws_subnet.was_subnet1.id
  route_table_id = aws_route_table.private_rt1.id
}

# 프라이빗 서브넷과 라우트 테이블 연결4
resource "aws_route_table_association" "private_rta4" {
  subnet_id      = aws_subnet.was_subnet2.id
  route_table_id = aws_route_table.private_rt2.id
}

# 프라이빗 서브넷과 라우트 테이블 연결3
resource "aws_route_table_association" "private_rta5" {
  subnet_id      = aws_subnet.db_subnet1.id
  route_table_id = aws_route_table.private_rt1.id
}

# 프라이빗 서브넷과 라우트 테이블 연결4
resource "aws_route_table_association" "private_rta6" {
  subnet_id      = aws_subnet.db_subnet2.id
  route_table_id = aws_route_table.private_rt2.id
}


# Security Group을 생성하는 코드를 작성합니다.
resource "aws_security_group" "web_security_group" {
  vpc_id      = aws_vpc.main.id
  name_prefix = "web-security-group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "icmp"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    # Private Subnet에서 외부와 통신할 수 있도록 CIDR 블록을 지정합니다.
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group을 생성하는 코드를 작성합니다.
resource "aws_security_group" "was_security_group" {
  vpc_id      = aws_vpc.main.id
  name_prefix = "was-security-group"

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "icmp"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    # Private Subnet에서 외부와 통신할 수 있도록 CIDR 블록을 지정합니다.
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group을 생성하는 코드를 작성합니다.
resource "aws_security_group" "db_security_group" {
  vpc_id      = aws_vpc.main.id
  name_prefix = "db-security-group"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    # Private Subnet에서 외부와 통신할 수 있도록 CIDR 블록을 지정합니다.
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# HTTPS 포트가 열린 보안 그룹 생성
resource "aws_security_group" "https_sg" {
  name_prefix = "My HTTPS SG"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "icmp"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# .ssm, .ssmmessages, .ec2messages 엔드포인트 생성
resource "aws_vpc_endpoint" "ssm_endpoint" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.us-east-1.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.web_subnet1.id]
  security_group_ids  = [aws_security_group.https_sg.id]
  private_dns_enabled = true # private DNS 이름 활성화
  tags = {
    Name = "main endpoint ssm"
  }

}

resource "aws_vpc_endpoint" "ssmmessages_endpoint" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.us-east-1.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.web_subnet1.id]
  security_group_ids  = [aws_security_group.https_sg.id]
  private_dns_enabled = true # private DNS 이름 활성화
  tags = {
    Name = "main endpoint ssmmessages"
  }

}

resource "aws_vpc_endpoint" "ec2messages_endpoint" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.us-east-1.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.web_subnet1.id]
  security_group_ids  = [aws_security_group.https_sg.id]
  private_dns_enabled = true # private DNS 이름 활성화
  tags = {
    Name = "main endpoint ec2messages"
  }

}

### Launch Template을 사용해 Auto Scaling을 하기 때문에 인스턴스를 직접 생성하지는 않는다. ###
# # 퍼블릭 서브넷에 퍼블릭 IP가 할당된 퍼블릭 EC2 인스턴스 생성
# resource "aws_instance" "public_ec2" {
#   ami = data.aws_ami.my_amazonlinux2.id
#   instance_type = "t2.micro"
#   subnet_id = aws_subnet.public_subnet.id
#   associate_public_ip_address = true
#   vpc_security_group_ids = [aws_security_group.my_sg.id]

# # IAM 인스턴스 프로필 연결
#   iam_instance_profile = "AmazonSSMRoleForInstancesQuickSetup"

#   key_name = "my_key"
#   tags = {
#     Name = "Public EC2"
#   }
# }

# # 프라이빗 서브넷에 프라이빗 IP만 할당된 프라이빗 EC2 인스턴스 생성
# resource "aws_instance" "private_ec2" {
#   ami = data.aws_ami.my_amazonlinux2.id
#   instance_type = "t2.micro"
#   associate_public_ip_address = false  # 퍼블릭 IP 할당 안함
#   subnet_id = aws_subnet.private_subnet.id
#   vpc_security_group_ids = [aws_security_group.my_sg.id]
#   private_dns_name_options {
#     enable_resource_name_dns_a_record = true
#   }
#   # IAM 인스턴스 프로필 연결
#   iam_instance_profile = "AmazonSSMRoleForInstancesQuickSetup"
#   key_name = "my_key"
#   tags = {
#     Name = "Private EC2"
#   }
# }

# Launch Template을 생성하는 코드를 작성합니다.
resource "aws_launch_template" "web_launch_template" {
  name_prefix   = "web-lt"
  image_id      = data.aws_ami.amazonlinux2.id
  instance_type = var.instance_type
  key_name      = var.key_name

  # 위에서 생성한 Security Group ID를 지정합니다.
  vpc_security_group_ids = ["${aws_security_group.web_security_group.id}"]

  # IAM 인스턴스 프로필 연결
  iam_instance_profile {
    name = "AmazonSSMRoleForInstancesQuickSetup"
  }
  # EC2 인스턴스를 구성하기 위한 User Data를 작성합니다.
  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo "Hello, World!" > index.html
              nohup python -m SimpleHTTPServer 80 &
              EOF
  )

  tag_specifications {
    resource_type = "instance"

    # EC2 인스턴스에 Name 태그를 추가합니다.
    tags = {
      Name = "web-instance"
    }
  }
}

# Launch Template을 생성하는 코드를 작성합니다.
resource "aws_launch_template" "was_launch_template" {
  name_prefix   = "was-lt"
  image_id      = data.aws_ami.amazonlinux2.id
  instance_type = var.instance_type
  key_name      = var.key_name

  # 위에서 생성한 Security Group ID를 지정합니다.
  vpc_security_group_ids = ["${aws_security_group.was_security_group.id}"]

  # IAM 인스턴스 프로필 연결
  iam_instance_profile {
    name = "AmazonSSMRoleForInstancesQuickSetup"
  }
  # EC2 인스턴스를 구성하기 위한 User Data를 작성합니다.
  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo "Hello, World!" > index.html
              nohup python -m SimpleHTTPServer 8000 &
              EOF
  )

  tag_specifications {
    resource_type = "instance"

    # EC2 인스턴스에 Name 태그를 추가합니다.
    tags = {
      Name = "was-instance"
    }
  }
}


# # Aurora DB 클러스터와 연결된 DB 서브넷 그룹을 생성합니다.
# resource "aws_db_subnet_group" "aurora_db_subnet_group" {
#   name       = "aurora-db-subnet-group"
#   subnet_ids = [ aws_subnet.private_subnet3.id ,aws_subnet.private_subnet4.id ]
# }

# # Aurora DB 클러스터를 생성합니다.
# resource "aws_rds_cluster" "aurora_cluster" {
#   cluster_identifier      = "aurora-cluster"
#   engine                  = "aurora"
#   engine_version          = "5.7.mysql_aurora.2.03.2"
#   database_name           = "flower"
#   master_username         = var.master_username
#   master_password         = var.master_password
#   backup_retention_period = 7

#   # Aurora DB 클러스터와 연결된 보안 그룹을 지정합니다.
#   vpc_security_group_ids  = [aws_security_group.db_security_group.id]

#   # Aurora DB 클러스터와 연결된 DB 서브넷 그룹을 지정합니다.
#   db_subnet_group_name    = aws_db_subnet_group.aurora_db_subnet_group.name

# }

# # Aurora DB 인스턴스를 생성합니다.
# resource "aws_rds_cluster_instance" "aurora_instance" {
#   cluster_identifier = aws_rds_cluster.aurora_cluster.id
#   instance_class     = var.db_instance_type
#   engine             = "aurora"
#   engine_version     = "5.7.mysql_aurora.2.03.2"
#   identifier         = "aurora-instance"

#   # Aurora DB 인스턴스에 태그를 지정합니다.
#   tags = {
#     Name = "Aurora DB Instance"
#   }
# }


# Auto Scaling Group을 생성하는 코드를 작성합니다.
resource "aws_autoscaling_group" "web_autoscaling_group" {
  name                = "web-autoscaling-group"
  vpc_zone_identifier = ["${aws_subnet.web_subnet1.id}", "${aws_subnet.web_subnet2.id}"]

  launch_template {
    id      = aws_launch_template.web_launch_template.id
    version = "$Latest"
  }
  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 3
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
  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 3
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
    path     = "/"
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

# WEB_LB용 Security Group을 생성하는 코드를 작성합니다.
resource "aws_security_group" "web_lb_security_group" {
  vpc_id      = aws_vpc.main.id
  name_prefix = "web-lb-security-group"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    # Public Subnet에서 Application Load Balancer에 접속할 수 있도록 CIDR 블록을 지정합니다.
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    # Private Subnet에서 외부와 통신할 수 있도록 CIDR 블록을 지정합니다.
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# WAS_LB용 Security Group을 생성하는 코드를 작성합니다.
resource "aws_security_group" "was_lb_security_group" {
  vpc_id      = aws_vpc.main.id
  name_prefix = "was-lb-security-group"

  ingress {
    from_port = 8000
    to_port   = 8000
    protocol  = "tcp"

    # web_lb에서 오는 트래픽만 허용
    security_groups = [aws_security_group.web_lb_security_group.id]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    # Private Subnet에서 외부와 통신할 수 있도록 CIDR 블록을 지정합니다.
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# # AWS CloudFront Distribution 생성
# resource "aws_cloudfront_distribution" "web_distribution" {
#   origin {
#     domain_name = aws_lb.main.dns_name
#     origin_id   = aws_lb.main.dns_name

#     custom_origin_config {
#       http_port              = 80
#       https_port             = 443
#       origin_protocol_policy = "http-only"
#       origin_ssl_protocols   = ["TLSv1.2"]
#     }
#   }

#   enabled             = true
#   is_ipv6_enabled     = true
#   comment             = "Web distribution"
#   default_root_object = "index.html"

#   # CloudFront에 연결할 SSL 인증서 ARN
#   viewer_certificate {
#     acm_certificate_arn = "arn:aws:acm:us-east-1:881855020500:certificate/d082e57f-eded-41b2-b77a-54aa3d74a39c"
#     ssl_support_method  = "sni-only"
#   }
#   # ALB의 DNS 이름을 CNAME으로 등록
#   aliases = ["www.hkang.shop"]


#   # HTTP 요청을 HTTPS로 리디렉션합니다.
#   default_cache_behavior {
#     cache_policy_id  = var.cache_policy_id
#     allowed_methods  = ["GET", "HEAD", "OPTIONS"]
#     cached_methods   = ["GET", "HEAD"]
#     target_origin_id = aws_lb.main.dns_name
#     compress         = true

#     viewer_protocol_policy = "redirect-to-https" //http로 들어오면 https로 바꿔 cloudfront의 인증서로 처리함
#     min_ttl                = 0
#     default_ttl            = 3600
#     max_ttl                = 86400
#   }

#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }

#   tags = {
#     Environment = "Production"
#   }
# }


# resource "aws_route53_record" "www_aws" {
#   zone_id         = var.zone_id
#   name            = "www.${var.zone_name}"
#   type            = "A"
#   health_check_id = "0b289f47-057d-4649-815a-dcdd66735cdb"
#   weighted_routing_policy {
#     weight = 50
#   }
#     set_identifier = "aws"
#   # CloudFront 배포의 도메인 이름과 호스팅 영역 ID
#   alias {
#     name    = aws_cloudfront_distribution.web_distribution.domain_name
#     zone_id = aws_cloudfront_distribution.web_distribution.hosted_zone_id
#     evaluate_target_health = false
#   }
# }

# resource "aws_route53_health_check" "www_aws_hc" {
#   fqdn              = aws_cloudfront_distribution.web_distribution.domain_name
#   port              = 80
#   type              = "HTTP"
#   resource_path     = "/"
#   failure_threshold = "5"
#   request_interval  = "30"

#   tags = {
#     Name = "aws-health-check"
#   }
# }


## IDC 부분 잘 안됨
# resource "aws_route53_record" "www_idc" {
#   zone_id         = var.zone_id
#   name            = "www.${var.zone_name}"
#   type            = "A"
#   records         = ["111.67.218.43"]
#   health_check_id = "0b289f47-057d-4649-815a-dcdd66735cdb"

#   weighted_routing_policy {
#     weight = 50
#   }
#       set_identifier = "idc"
# }

# resource "aws_route53_health_check" "www_idc_hc" {
#   fqdn              = "111.67.218.43"
#   port              = 80
#   type              = "HTTP"
#   resource_path     = "/"
#   failure_threshold = "5"
#   request_interval  = "30"

#   tags = {
#     Name = "idc-health-check"
#   }
# }
# Security Group을 생성하는 코드를 작성합니다.
resource "aws_security_group" "web_security_group" {
  vpc_id      = aws_vpc.main.id
  name_prefix = "web-ec2-security-group"

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
  name_prefix = "was-ec2-security-group"

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
  name_prefix = "ssm-security-group"
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

# WEB
# EFS용 Security Group을 생성하는 코드를 작성합니다.
resource "aws_security_group" "web_efs_security_group" {
  vpc_id      = aws_vpc.main.id
  name_prefix = "web-efs-security-group"

  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"

    # web_lb에서 오는 트래픽만 허용
    security_groups = [aws_security_group.web_security_group.id]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    # Private Subnet에서 외부와 통신할 수 있도록 CIDR 블록을 지정합니다.
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# WAS
# EFS용 Security Group을 생성하는 코드를 작성합니다.
resource "aws_security_group" "was_efs_security_group" {
  vpc_id      = aws_vpc.main.id
  name_prefix = "was-efs-security-group"

  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"

    # web_lb에서 오는 트래픽만 허용
    security_groups = [aws_security_group.was_security_group.id]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    # Private Subnet에서 외부와 통신할 수 있도록 CIDR 블록을 지정합니다.
    cidr_blocks = ["0.0.0.0/0"]
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

    # web_ec2 에서 오는 트래픽만 허용
    security_groups = [aws_security_group.web_security_group.id]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    # Private Subnet에서 외부와 통신할 수 있도록 CIDR 블록을 지정합니다.
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# .ssm, .ssmmessages, .ec2messages 엔드포인트 생성
resource "aws_vpc_endpoint" "ssm_endpoint" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.ssm"
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
  service_name        = "com.amazonaws.${var.aws_region}.ssmmessages"
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
  service_name        = "com.amazonaws.${var.aws_region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.web_subnet1.id]
  security_group_ids  = [aws_security_group.https_sg.id]
  private_dns_enabled = true # private DNS 이름 활성화
  tags = {
    Name = "main endpoint ec2messages"
  }
}

resource "aws_vpc_endpoint" "gateway_endpoint" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private_rt1.id, aws_route_table.private_rt2.id]
  tags = {
    Name = "main gateway endpoint"
  }
}
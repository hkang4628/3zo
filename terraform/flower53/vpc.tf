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
    Name = "IGW"
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
    tags = {
    Name = "NGW1"
  }
}
# NAT Gateway 생성
resource "aws_nat_gateway" "ngw2" {
  allocation_id = aws_eip.eip2.id
  subnet_id     = aws_subnet.public_subnet2.id
  tags = {
    Name = "NGW2"
  }
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
# Aurora DB 클러스터와 연결된 DB 서브넷 그룹을 생성합니다.
resource "aws_db_subnet_group" "aurora_db_subnet_group" {
  name       = "aurora-db-subnet-group"
  subnet_ids = [aws_subnet.db_subnet1.id, aws_subnet.db_subnet2.id]
}

# Aurora DB 클러스터를 생성합니다.
resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier      = "aurora-cluster"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.11.1"
  engine_mode             = "provisioned"
  master_username         = var.master_username
  master_password         = var.master_password
  backup_retention_period = 7
  skip_final_snapshot     = true
  deletion_protection     = "false"

  # Aurora DB 클러스터와 연결된 보안 그룹을 지정합니다.
  vpc_security_group_ids = [aws_security_group.db_security_group.id]

  # Aurora DB 클러스터와 연결된 DB 서브넷 그룹을 지정합니다.
  db_subnet_group_name = aws_db_subnet_group.aurora_db_subnet_group.name

  # 여기에 원하는 가용 영역을 지정합니다.
  # availability_zones = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]

  # 클러스터 구성
  cluster_members = ["aurora-instance1", "aurora-instance2"] # aws_rds_cluster_instance 의 identifier와 맞춰야 함
}


# Aurora DB 인스턴스를 생성합니다.
resource "aws_rds_cluster_instance" "aurora_instance1" {
  availability_zone  = "${var.aws_region}a"
  cluster_identifier = aws_rds_cluster.aurora_cluster.id
  instance_class     = var.db_instance_type
  engine             = aws_rds_cluster.aurora_cluster.engine
  engine_version     = aws_rds_cluster.aurora_cluster.engine_version
  identifier         = "aurora-instance1"

  # Aurora DB 인스턴스에 태그를 지정합니다.
  tags = {
    Name = "Aurora DB Instance"
  }
}
# Aurora DB 인스턴스를 생성합니다.
resource "aws_rds_cluster_instance" "aurora_instance2" {
  availability_zone  = "${var.aws_region}b"
  cluster_identifier = aws_rds_cluster.aurora_cluster.id
  instance_class     = var.db_instance_type
  engine             = aws_rds_cluster.aurora_cluster.engine
  engine_version     = aws_rds_cluster.aurora_cluster.engine_version
  identifier         = "aurora-instance2"

  # Aurora DB 인스턴스에 태그를 지정합니다.
  tags = {
    Name = "Aurora DB Instance"
  }
}

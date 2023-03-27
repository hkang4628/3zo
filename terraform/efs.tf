# WEB EFS 파일 시스템을 생성합니다.
resource "aws_efs_file_system" "web_efs_file_system" {
  encrypted        = false
  throughput_mode  = "bursting"
  performance_mode = "generalPurpose"

  tags = {
    Name = "web-efs-file-system"
  }

  # EFS 파일 시스템의 저장 클래스를 지정합니다.
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
}

# EFS 파일 시스템의 마운트 타깃을 생성합니다.
resource "aws_efs_mount_target" "web_efs_mount_target" {
  file_system_id  = aws_efs_file_system.web_efs_file_system.id
  subnet_id       = aws_subnet.web_subnet1.id
  security_groups = [aws_security_group.web_efs_security_group.id]
}

resource "aws_efs_mount_target" "web_efs_mount_target2" {
  file_system_id  = aws_efs_file_system.web_efs_file_system.id
  subnet_id       = aws_subnet.web_subnet2.id
  security_groups = [aws_security_group.web_efs_security_group.id]
}


# WAS EFS 파일 시스템을 생성합니다.
resource "aws_efs_file_system" "was_efs_file_system" {
  encrypted        = false
  throughput_mode  = "bursting"
  performance_mode = "generalPurpose"

  tags = {
    Name = "was-efs-file-system"
  }


  # EFS 파일 시스템의 저장 클래스를 지정합니다.
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
}

# EFS 파일 시스템의 마운트 타깃을 생성합니다.
resource "aws_efs_mount_target" "was_efs_mount_target" {
  file_system_id  = aws_efs_file_system.was_efs_file_system.id
  subnet_id       = aws_subnet.was_subnet1.id
  security_groups = [aws_security_group.was_efs_security_group.id]
}

resource "aws_efs_mount_target" "was_efs_mount_target2" {
  file_system_id  = aws_efs_file_system.was_efs_file_system.id
  subnet_id       = aws_subnet.was_subnet2.id
  security_groups = [aws_security_group.was_efs_security_group.id]
}
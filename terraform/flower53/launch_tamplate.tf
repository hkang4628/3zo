
# Launch Template을 생성하는 코드를 작성합니다.
resource "aws_launch_template" "web_launch_template" {
  name_prefix   = "web-lt"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name

  # 위에서 생성한 Security Group ID를 지정합니다.
  vpc_security_group_ids = ["${aws_security_group.web_security_group.id}"]

  # IAM 인스턴스 프로필 연결
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }
  # EC2 인스턴스를 구성하기 위한 User Data를 작성합니다.
  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo "Hello, World!" > index.html
              nohup python -m SimpleHTTPServer 80 &

              mkdir /efs
              apt-get update
              apt-get -y install git binutils
              git clone https://github.com/aws/efs-utils
              cd efs-utils
              ./build-deb.sh
              apt-get -y install ./build/amazon-efs-utils*deb
              mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.web_efs_file_system.dns_name}:/ /efs
              EOF
  )

  depends_on = [
    aws_efs_mount_target.web_efs_mount_target, aws_efs_mount_target.web_efs_mount_target2
  ]

  tag_specifications {
    resource_type = "instance"

    # EC2 인스턴스에 Name 태그를 추가합니다.
    tags = {
      Name = aws_iam_instance_profile.ec2_instance_profile.name
    }
  }
}

# Launch Template을 생성하는 코드를 작성합니다.
resource "aws_launch_template" "was_launch_template" {
  name_prefix   = "was-lt"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name

  # 위에서 생성한 Security Group ID를 지정합니다.
  vpc_security_group_ids = ["${aws_security_group.was_security_group.id}"]

  # IAM 인스턴스 프로필 연결
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }
  # EC2 인스턴스를 구성하기 위한 User Data를 작성합니다.
  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo "Hello, World!" > index.html
              nohup python -m SimpleHTTPServer 8000 &

              mkdir /efs
              apt-get update
              apt-get -y install git binutils
              git clone https://github.com/aws/efs-utils
              cd efs-utils
              ./build-deb.sh
              apt-get -y install ./build/amazon-efs-utils*deb
              mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.was_efs_file_system.dns_name}:/ /efs
              EOF
  )

  # 생성되기 전에 아래 리소스 생성을 기다림
  depends_on = [
    aws_efs_mount_target.was_efs_mount_target, aws_efs_mount_target.was_efs_mount_target2
  ]

  tag_specifications {
    resource_type = "instance"

    # EC2 인스턴스에 Name 태그를 추가합니다.
    tags = {
      Name = "was-instance"
    }
  }
}
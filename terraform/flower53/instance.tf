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
# AWS Region 변수를 정의합니다.
variable "aws_region" {
  default = "us-east-1"
}

# Auto Scaling Group에서 사용될 EC2 인스턴스 유형을 정의합니다.
variable "instance_type" {
  default = "t2.micro"
}


# EC2 인스턴스에 연결할 Key Pair의 이름을 정의합니다.
variable "key_name" {
  default = "my-key"
}

# Hosted zone name, id 정의
variable "zone_name" {
  default = "hkang.shop"
}
variable "zone_id" {
  default = "Z093279026ZMIZQ76MIQ5"
}

variable "cache_policy_id" {
  default = "658327ea-f89d-4fab-a63d-7e88639e58f6"
}
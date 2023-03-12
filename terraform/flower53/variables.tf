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
  # default = "hkang.shop"
  default = "flower53.site"
}
variable "zone_id" {
  # default = "Z093279026ZMIZQ76MIQ5"
  default = "Z04776923OI5IS9HYZB43"
}

variable "cache_policy_id" {
  default = "658327ea-f89d-4fab-a63d-7e88639e58f6"
}


# DB 설정
variable "db_instance_type" {
  description = "db instance type"
  type        = string
  default     = "db.t3.small"
}

variable "master_username" {
  description = "(Required) Username for the master DB user"
  default     = "admin"
  # type        = string
}

variable "master_password" {
  description = "(Required) Password for the master DB user"
  # type        = string
  default = "It12345!"
}

variable "web_autoscaling_group" {
  type = map(string)
  default = {
    desired_capacity = 2
    min_size         = 2
    max_size         = 4
  }
}

variable "was_autoscaling_group" {
  type = map(string)
  default = {
    desired_capacity = 2
    min_size         = 2
    max_size         = 4
  }
}
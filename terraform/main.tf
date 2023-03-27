provider "aws" {
  region = var.aws_region
  #   shared_credentials_files = ["./credentials/credentials"]
  #   shared_credentials_files = ["C://Users//Administrator//.aws//credentials"]
        access_key = var.aws_access_key
        secret_key = var.aws_secret_key
}

#resource "aws_key_pair" "my_keypair" {
#  key_name   = var.key_name
#  public_key = file("C://Users//Administrator//.ssh//id_rsa.pub")
#}

variable "aws_access_key" {
  type        = string
  description = "AWS access key"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS secret key"
}

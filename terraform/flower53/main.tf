provider "aws" {
  region = var.aws_region
  #   shared_credentials_files = ["./credentials/credentials"]
  shared_credentials_files = ["C://Users//Administrator//.aws//credentials"]
}

resource "aws_key_pair" "my_keypair" {
  key_name   = var.key_name
  public_key = file("C://Users//Administrator//.ssh//id_rsa.pub")
}
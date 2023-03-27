provider "aws" {
  region = var.aws_region
  #   shared_credentials_files = ["./credentials/credentials"]
  #   shared_credentials_files = ["C://Users//Administrator//.aws//credentials"]
        access_key = var.aws_access_key
        secret_key = var.aws_secret_key
}

resource "aws_key_pair" "my_keypair" {
  key_name   = var.key_name
  #public_key = file("C://Users//Administrator//.ssh//id_rsa.pub")
  public_key = AAAAB3NzaC1yc2EAAAADAQABAAABgQDuzzaTa0QbHh757f5ClWdGWj1woovMLGartunRElpxheE7GkIbzvSriO/a0grrZJsALpGahf0g34npvp0UwUf8I2Nw+QKHtoQtCFA930IPVL1KJnEmhcTx8mB0TcqcHWVsSDAZKjTIdyHhfY/KLoSMsZanPF5cZFEUfYPVYmptOC2KHQyKze6erg91xv4bOwFyxDAe4tWKCw44vaJMWcqWUlHzGyGIPmykqP4nQ+qdY9pbQ7i5I/jRxPmzOthEjWpptv5BJVNs4xjpsiNsvdSt3aoZUu9R47bH92sklITybzIgcmF9eWQ6wXMj2W+LDS4ciJZCGn6Di1xcY1kq7bglxV5BKk6w6iwNqO9dSn0lSyrkO5g4zFH/u7t13bCw1CNO4Dzoh22sEKdFrEO0Fi2MhtdzMHrqPNzvTjzKCnd5vjo8mIsy3yGwk7qE/kQBIqTQPTs0JPA/yWbDy6BxPy/P0+ih9AaMSMWvEwQiVJW8pFyyLeA/JvkdeftHBs6jTKc= 
}

variable "aws_access_key" {
  type        = string
  description = "AWS access key"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS secret key"
}

resource "aws_rds_cluster" "tfer--aurora-cluster" {
  allocated_storage                   = "1"
  availability_zones                  = ["us-west-2a", "us-west-2b", "us-west-2c"]
  backtrack_window                    = "0"
  backup_retention_period             = "1"
  cluster_identifier                  = "aurora-cluster"
  cluster_members                     = ["aurora-cluster-instance-1", "aurora-cluster-instance-1-us-west-2b"]
  copy_tags_to_snapshot               = "true"
  db_cluster_parameter_group_name     = "default.aurora-mysql5.7"
  db_subnet_group_name                = "${aws_db_subnet_group.tfer--default-vpc-0e44f8c3b424d4ddb.name}"
  deletion_protection                 = "true"
  enable_http_endpoint                = "false"
  engine                              = "aurora-mysql"
  engine_mode                         = "provisioned"
  engine_version                      = "5.7.mysql_aurora.2.11.1"
  iam_database_authentication_enabled = "false"
  iops                                = "0"
  kms_key_id                          = "arn:aws:kms:us-west-2:881855020500:key/c9901b61-e142-4a1c-a962-22ff11ef2acf"
  master_username                     = "admin"
  network_type                        = "IPV4"
  port                                = "3306"
  preferred_backup_window             = "12:10-12:40"
  preferred_maintenance_window        = "sat:08:47-sat:09:17"
  storage_encrypted                   = "true"
  vpc_security_group_ids              = ["sg-04d29075db556bb0b"]
}

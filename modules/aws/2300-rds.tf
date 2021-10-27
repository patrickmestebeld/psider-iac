module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  identifier = "${var.prefix}-db-instance"

  engine               = "postgres"
  engine_version       = "12.8"
  family               = "postgres12"
  major_engine_version = "12"
  instance_class       = "db.t2.micro"
  allocated_storage    = 20

  name     = local.db_name
  port     = local.db_port
  username = var.db_username
  password = var.db_password

  iam_database_authentication_enabled = true

  vpc_security_group_ids = [module.postgres_sg.security_group_id]
  subnet_ids             = module.vpc.database_subnets

  maintenance_window  = "Sun:00:00-Sun:03:00"
  //  backup_window      = "03:00-06:00"
  skip_final_snapshot = true
  deletion_protection = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
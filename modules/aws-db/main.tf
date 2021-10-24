resource "aws_security_group" "db_security_group" {
  name        = "${var.prefix}_db_security_group"
  description = "${var.prefix} database instance security group"
  vpc_id      = var.vpc_id

  ingress = [
    {
      description      = "Allow SQL inbound traffic security groups"
      from_port        = var.db_port
      to_port          = var.db_port
      protocol         = "tcp"
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = var.security_groups
      self             = false
    }
  ]

  egress = [
    {
      description      = "Allow All Outbound Traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    Name  = "${var.prefix}_db_security_group"
    Group = var.prefix
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name        = "${var.prefix}_db_subnet_group"
  description = "Database instance subnet group"
  subnet_ids  = var.subnet_ids

  tags = {
    Name  = "${var.prefix}_security_group"
    Group = var.prefix
  }
}

resource "aws_db_instance" "db_instance" {
  identifier          = "${var.prefix}-db-instance-01"
  allocated_storage   = 20
  engine              = "postgres"
  engine_version      = "12.8"
  instance_class      = "db.t2.micro"
  skip_final_snapshot = true

  name     = var.db_name
  port     = var.db_port
  username = var.db_username
  password = var.db_password

  vpc_security_group_ids = aws_security_group.db_security_group.*.id
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  publicly_accessible    = false

  tags = {
    Name  = "${var.prefix}_db_instance"
    Group = var.prefix
  }
}

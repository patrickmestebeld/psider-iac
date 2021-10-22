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
  description = "Database isntance subnet group"
  subnet_ids  = var.subnet_ids
  //  subnet_ids = aws_subnet.${var.prefix}_subnet_private[*].id

  tags = {
    Name  = "${var.prefix}_security_group"
    Group = var.prefix
  }
}

resource "aws_db_instance" "db_instance" {
  name                = "${var.prefix}_db_instance"
  identifier          = "${var.prefix}-db-instance-01"
  allocated_storage   = 20
  engine              = "postgres"
  engine_version      = "12.8"
  instance_class      = "db.t2.micro"
  username            = var.db_username
  password            = var.db_password
  skip_final_snapshot = true

  vpc_security_group_ids = aws_security_group.db_security_group.*.id
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  publicly_accessible    = false
  port                   = var.db_port

  tags = {
    Name  = "${var.prefix}_db_instance"
    Group = var.prefix
  }
}

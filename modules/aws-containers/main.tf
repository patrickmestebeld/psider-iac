resource "aws_security_group" "psider_security_group" {
  name        = "${var.prefix}-security-group"
  description = "${var.prefix} security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow SSH Inbound Traffic From Home"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["84.82.33.208/32"]
  }
  
  ingress {
    description = "Allow SSH Inbound Traffic From Work"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["195.35.227.201/32"]
  }

  ingress {
    description = "Allow HTTP Inbound Traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS Inbound Traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP Inbound Traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Api Test Inbound Traffic"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "Allow Api Test Inbound Traffic"
    from_port   = 4200
    to_port     = 4200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    description = "Allow All Outbound Traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "${var.prefix}-security-group"
    Group = var.prefix
  }
}

resource "aws_key_pair" "deployer_key" {
  key_name   = "deployer"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDv2Fki1qByI0p6lcb9LIoFoGVKgeH2QRTnbE00LNs3ChQldbRMTRuyG5wFMhXZEsGCdHWT6G49EsRlljOaoKuClmrG/SduiPxEJvgNSXOjLq2EVX5V6TA139a1CE7Kw+A7+AakJ1hsW7uXl4zNCPCKCJp8p45Emk9UpZYArnpVXek8kAoVyoGZzm6YqfiSXLpjwHspCVw3oW6UtcdEFA6WOwsAQ27TTO8zKh7WQf0G6Lm7vieOQBU0lc21sRBbMYzUikxuLcj75bac8XzareAa1tobzymLD3FK528RZLvvLWWKcdXX8i9taGi53git1UuSYpac27EpFEjd/V9WKkgltfmc2pFPqVEDvU3MaZP6XAQgH0WlrgktnNmm/XXzu51KTVAZoTCf7xpHvaHiYrjGmOQuvnBhhxtiG41MUUUYL4elNmxeYt5UltzwDbjimD5LhB44NvWH7Vl9GJwkUDErMTRrYC32g42vxqV/2y2aIo97palh7iE+3TEAXLVLZZE= patrickmestebeld@Patricks-Mac-2.local"
}

data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = aws_iam_role.ec2_instance_role.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        Effect: "Allow",
        Action: [
          "s3:Get*",
          "s3:List*",
          "s3-object-lambda:Get*",
          "s3-object-lambda:List*"
        ],
        Resource: "*"
      }
    ]
  })
}

resource "aws_iam_role" "ec2_instance_role" {
  name = "ec2InstanceRole"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Sid       = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_instance_role.name
}

resource "aws_instance" "web" {
  ami                         = "ami-05cd35b907b4ffe77"
  instance_type               = "t2.small"
  associate_public_ip_address = true
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.psider_security_group.id]
  key_name                    = aws_key_pair.deployer_key.key_name
  user_data                   = templatefile("${path.module}/resources/cloud_config.tpl.yaml", {
    b64_docker_compose_config = base64encode(templatefile("${path.module}/resources/docker-compose.yaml", {
      db_host     = var.db_host
      db_port     = var.db_port
      db_name     = var.db_name
      db_username = var.db_username
      db_password = var.db_password
    }))
    db_host                   = var.db_host
    db_port                   = var.db_port
    db_name                   = var.db_name
    db_username               = var.db_username
    db_password               = var.db_password
  })

  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  monitoring = true

  tags = {
    Name  = "${var.prefix}_web"
    Group = var.prefix
  }
}
locals {
  psider_db_port = 5432
  prefix         = "psider"
}

// networking and communication
module "psider_networking" {
  source = "./modules/aws-networking"
  prefix = local.prefix
}


resource "aws_security_group" "psider_security_group" {
  name        = "${local.prefix}_security_group"
  description = "${local.prefix} security group"
  vpc_id      = module.psider_networking.vpc_id

  ingress = [
    {
      description      = "Allow SSH Inbound Traffic From Home"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["84.82.33.208/32"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Allow HTTP Inbound Traffic"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Allow HTTPS Inbound Traffic"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
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
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    Name  = "${local.prefix}_security_group"
    Group = local.prefix
  }
}


module "psider_db" {
  source = "./modules/aws-db"

  prefix      = local.prefix
  db_username = var.psider_db_username
  db_password = var.psider_db_password
  db_port     = 5432

  vpc_id          = module.psider_networking.vpc_id
  security_groups = [aws_security_group.psider_security_group.id]
  subnet_ids      = module.psider_networking.vpc_private_subnet_ids
}

resource "aws_key_pair" "deployer_key" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDv2Fki1qByI0p6lcb9LIoFoGVKgeH2QRTnbE00LNs3ChQldbRMTRuyG5wFMhXZEsGCdHWT6G49EsRlljOaoKuClmrG/SduiPxEJvgNSXOjLq2EVX5V6TA139a1CE7Kw+A7+AakJ1hsW7uXl4zNCPCKCJp8p45Emk9UpZYArnpVXek8kAoVyoGZzm6YqfiSXLpjwHspCVw3oW6UtcdEFA6WOwsAQ27TTO8zKh7WQf0G6Lm7vieOQBU0lc21sRBbMYzUikxuLcj75bac8XzareAa1tobzymLD3FK528RZLvvLWWKcdXX8i9taGi53git1UuSYpac27EpFEjd/V9WKkgltfmc2pFPqVEDvU3MaZP6XAQgH0WlrgktnNmm/XXzu51KTVAZoTCf7xpHvaHiYrjGmOQuvnBhhxtiG41MUUUYL4elNmxeYt5UltzwDbjimD5LhB44NvWH7Vl9GJwkUDErMTRrYC32g42vxqV/2y2aIo97palh7iE+3TEAXLVLZZE= patrickmestebeld@Patricks-Mac-2.local"
}

resource "aws_instance" "web" {
  ami                    = "ami-05cd35b907b4ffe77"
  instance_type          = "t2.micro"
  subnet_id              = module.psider_networking.vpc_public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.psider_security_group.id]
  key_name               = aws_key_pair.deployer_key.key_name

  tags = {
    Name  = "${local.prefix}_web"
    Group = local.prefix
  }
}

// ECS TASKS
//resource "aws_ecs_task_definition" "psider_ecs_task_definition" {
//  family = "psider_cms"
//  requires_compatibilities = ["EC2"]
//  cpu = 1024
//  memory = 2048
//
//  container_definitions = templatefile("resources/service.json.tpl", {})
//}
//
//resource "aws_ecs_cluster" "psider_ecs_cluster" {
//  name = "psider_ecs_cluster"
//}
//
//resource "aws_ecs_service" "psider_ecs_service" {
//  name = "psider_ecs_service"
//  cluster = aws_ecs_cluster.psider_ecs_cluster.id
//  task_definition = aws_ecs_task_definition.psider_ecs_task_definition.arn
//  desired_count = 1
//  launch_type = "EC2"
//
//  iam_role = "${aws_iam_role.ecs-service-role.name}"
//}
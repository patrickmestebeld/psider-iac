locals {
  database_properties = {
    host     = module.rds.db_instance_address
    port     = module.rds.db_instance_port
    name     = module.rds.db_instance_name
    username = module.rds.db_instance_username
    password = module.rds.db_instance_password
  }

  b64_docker_compose_config = base64encode(templatefile("${path.module}/resources/ec2/docker-compose.tpl.yaml", {
    db_props = local.database_properties
  }))
}

resource "aws_key_pair" "instance_ssh_key" {
  key_name   = "deployer"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDv2Fki1qByI0p6lcb9LIoFoGVKgeH2QRTnbE00LNs3ChQldbRMTRuyG5wFMhXZEsGCdHWT6G49EsRlljOaoKuClmrG/SduiPxEJvgNSXOjLq2EVX5V6TA139a1CE7Kw+A7+AakJ1hsW7uXl4zNCPCKCJp8p45Emk9UpZYArnpVXek8kAoVyoGZzm6YqfiSXLpjwHspCVw3oW6UtcdEFA6WOwsAQ27TTO8zKh7WQf0G6Lm7vieOQBU0lc21sRBbMYzUikxuLcj75bac8XzareAa1tobzymLD3FK528RZLvvLWWKcdXX8i9taGi53git1UuSYpac27EpFEjd/V9WKkgltfmc2pFPqVEDvU3MaZP6XAQgH0WlrgktnNmm/XXzu51KTVAZoTCf7xpHvaHiYrjGmOQuvnBhhxtiG41MUUUYL4elNmxeYt5UltzwDbjimD5LhB44NvWH7Vl9GJwkUDErMTRrYC32g42vxqV/2y2aIo97palh7iE+3TEAXLVLZZE= patrickmestebeld@Patricks-Mac-2.local"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "web-instance"

  ami           = "ami-05cd35b907b4ffe77"
  instance_type = "t2.small"
  key_name      = aws_key_pair.instance_ssh_key.key_name
  monitoring    = true

  vpc_security_group_ids = [module.web_sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  iam_instance_profile = module.iam_assumable_role.iam_instance_profile_name

  user_data_base64 = base64encode(templatefile("${path.module}/resources/ec2/cloud_config.tpl.yaml", {
    b64_docker_compose_config = local.b64_docker_compose_config,
    db_props                  = local.database_properties,
    s3_bucket_id              = module.s3_bucket.s3_bucket_id
  }))

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = module.ec2_instance.id
  allocation_id = aws_eip.public_ip.id
}
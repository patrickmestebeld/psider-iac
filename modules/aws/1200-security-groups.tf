module "web_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "web-security-group"
  description = "Security group for web-server open within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  ingress_cidr_blocks = [
    "173.245.48.0/20",
    "103.21.244.0/22",
    "103.22.200.0/22",
    "103.31.4.0/22",
    "141.101.64.0/18",
    "108.162.192.0/18",
    "190.93.240.0/20",
    "188.114.96.0/20",
    "197.234.240.0/22",
    "198.41.128.0/17",
    "162.158.0.0/15",
    "104.16.0.0/13",
    "104.24.0.0/14",
    "172.64.0.0/13",
    "131.0.72.0/22",
  ]

  ingress_with_cidr_blocks = [
    {
      rule        = "ssh-tcp"
      description = "SSH from home"
      cidr_blocks = "84.82.33.208/32"
    }, {
      rule        = "ssh-tcp"
      description = "SSH from work"
      cidr_blocks = "195.35.227.201/32"
    }
  ]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "postgres_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "postgres-security-group"
  description = "Security group with Postgres port open for web-security-group created above (computed)"
  vpc_id      = module.vpc.vpc_id

  computed_ingress_with_source_security_group_id = [
    {
      from_port                = local.db_port
      to_port                  = local.db_port
      protocol                 = "tcp"
      description              = "PostgreSQL"
      source_security_group_id = module.web_sg.security_group_id
    }
  ]

  number_of_computed_ingress_with_source_security_group_id = 1

  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

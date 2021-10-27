data "aws_availability_zones" "available_zones" {
  state = "available"
}

resource "aws_eip" "public_ip" {
  vpc = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.prefix}-vpc"
  cidr = "10.0.0.0/16"

  azs              = data.aws_availability_zones.available_zones.names
  public_subnets   = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  private_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  database_subnets = ["10.0.51.0/24", "10.0.52.0/24", "10.0.53.0/24"]

  enable_nat_gateway  = false
  enable_vpn_gateway  = false
  external_nat_ip_ids = aws_eip.public_ip.*.id

  create_database_subnet_group = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}



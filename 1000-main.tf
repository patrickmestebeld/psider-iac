module "aws" {
  source = "./modules/aws"

  prefix      = local.prefix
  db_username = var.db_username
  db_password = var.db_password
}

module "cloudflare" {
  source = "./modules/cloudflare"

  prefix      = local.prefix
  domain_name = local.domain_name
  public_ip   = module.aws.public_ip
}
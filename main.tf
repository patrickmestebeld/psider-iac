locals {
  prefix      = "psider"
  db_port     = 5432
  db_name     = "psider_db"
  domain_name = "deepbluesystem.com"

  sources = {
    "nginx/nginx.conf"           = "${path.cwd}/resources/nginx/nginx.conf"
    "nginx/psider.crt"           = "${path.cwd}/resources/nginx/psider.crt"
    "nginx/psider.decrypted.key" = "${path.cwd}/resources/nginx/psider.decrypted.key"
    "postgres/seed.sql"          = "${path.cwd}/resources/postgres/seed.sql"
  }
}

module "networking" {
  source      = "./modules/aws-networking"
  prefix      = local.prefix
  domain_name = local.domain_name
}

module "bucket" {
  source = "./modules/aws-files"
  prefix = local.prefix

  sources = local.sources
}

module "database" {
  source = "./modules/aws-db"
  prefix = local.prefix

  db_name     = local.db_name
  db_username = var.db_username
  db_password = var.db_password
  db_port     = 5432

  vpc_id          = module.networking.vpc_id
  subnet_ids      = module.networking.vpc_private_subnet_ids
  security_groups = [module.containers.security_group_id]
}

module "containers" {
  source = "./modules/aws-containers"
  prefix = local.prefix

  vpc_id    = module.networking.vpc_id
  subnet_id = module.networking.vpc_public_subnet_ids[0]
  eip_id    = module.networking.eip_id

  db_host     = module.database.address
  db_port     = module.database.port
  db_name     = local.db_name
  db_username = var.db_username
  db_password = var.db_password
}

module "cloudflare" {
  source = "./modules/cloudflare"
  prefix = local.prefix

  domain_name = local.domain_name
  public_ip   = module.networking.public_ip
}

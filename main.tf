locals {
  prefix         = "psider"
  psider_db_port = 5432
  psider_db_name = "psider_db"
}

module "psider_networking" {
  source = "./modules/aws-networking"
  prefix = local.prefix
}

module "psider_bucket" {
  source = "./modules/aws-files"
  prefix = local.prefix

  sources = {
    "seed.sql" = "${path.cwd}/resources/seed.sql"
  }
}

module "psider_db" {
  source = "./modules/aws-db"
  prefix = local.prefix

  db_name     = local.psider_db_name
  db_username = var.psider_db_username
  db_password = var.psider_db_password
  db_port     = 5432

  vpc_id          = module.psider_networking.vpc_id
  subnet_ids      = module.psider_networking.vpc_private_subnet_ids
  security_groups = [module.psider_containers.security_group_id]
}

module "psider_containers" {
  source = "./modules/aws-containers"
  prefix = local.prefix

  vpc_id    = module.psider_networking.vpc_id
  subnet_id = module.psider_networking.vpc_public_subnet_ids[0]

  db_host     = module.psider_db.address
  db_port     = module.psider_db.port
  db_name     = local.psider_db_name
  db_username = var.psider_db_username
  db_password = var.psider_db_password
}


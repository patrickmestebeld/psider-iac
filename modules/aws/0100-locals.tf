locals {
  db_port = 5432
  db_name = "${var.prefix}db"

  s3_resource_folder = "${path.module}/resources/s3"
  s3_files           = fileset(local.s3_resource_folder, "**")
}
module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "${var.prefix}-2021-10-24"
  acl    = "private"
  
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_s3_bucket_object" "s3_objects" {
  for_each = local.s3_files

  acl    = "private"
  bucket = module.s3_bucket.s3_bucket_id

  key    = each.key
  source = "${local.s3_resource_folder}/${each.key}"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
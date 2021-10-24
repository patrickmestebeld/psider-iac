resource "aws_s3_bucket" "file_bucket" {
  bucket = "${var.prefix}-2021-10-24"
  acl    = "private"

  tags = {
    Name        = var.prefix
  }
}

resource "aws_s3_bucket_object" "files" {
  for_each = var.sources
  
  acl    = "private"
  bucket = aws_s3_bucket.file_bucket.id

  key    = each.key
  source = each.value
}
data "aws_availability_zones" "available_zones" {
  state = "available"
}

resource "aws_vpc" "default" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name  = "psider_vpc"
    Group = "psider"
  }
}

resource "aws_subnet" "subnet_public" {
  count                   = 1
  vpc_id                  = aws_vpc.default.id
  cidr_block              = cidrsubnet(aws_vpc.default.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available_zones.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name  = "psider_subnet_public"
    Group = "psider"
  }
}

resource "aws_subnet" "subnet_private" {
  count             = 2
  vpc_id            = aws_vpc.default.id
  cidr_block        = cidrsubnet(aws_vpc.default.cidr_block, 8, count.index + length(aws_subnet.subnet_public))
  availability_zone = data.aws_availability_zones.available_zones.names[count.index + length(aws_subnet.subnet_public)]

  tags = {
    Name  = "psider_subnet_private"
    Group = "psider"
  }
}

resource "aws_internet_gateway" "psider_gateway" {
  vpc_id = aws_vpc.default.id
  //  vpc_id = aws_vpc.psider_vpc.id

  tags = {
    Name = "${var.prefix}_gateway"
    Group = var.prefix
  }
}

resource "aws_eip" "psider_eip" {
  count = 1
  vpc = true
  depends_on = [aws_internet_gateway.psider_gateway]

  tags = {
    Name = "${var.prefix}_eip"
    Group = var.prefix
  }
}
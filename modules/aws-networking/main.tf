data "aws_availability_zones" "available_zones" {
  state = "available"
}

resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name  = "psider_vpc"
    Group = "psider"
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name  = "${var.prefix}_gateway"
    Group = var.prefix
  }
}

resource "aws_subnet" "subnet_public" {
  count                   = 1
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available_zones.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name  = "psider_subnet_public"
    Group = "psider"
  }
}

resource "aws_subnet" "subnet_private" {
  count             = 2
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + length(aws_subnet.subnet_public))
  availability_zone = data.aws_availability_zones.available_zones.names[count.index + length(aws_subnet.subnet_public)]

  tags = {
    Name  = "psider_subnet_private"
    Group = "psider"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
}

resource "aws_route_table_association" "route_table_association" {
  subnet_id      = aws_subnet.subnet_public[0].id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_eip" "eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.gateway]

  tags = {
    Name  = "${var.prefix}_eip"
    Group = var.prefix
  }
}
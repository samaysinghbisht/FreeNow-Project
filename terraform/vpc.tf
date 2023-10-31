resource "aws_vpc" "freenow_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "freenow_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.freenow_vpc.id
  cidr_block              = element(["10.0.0.0/24", "10.0.1.0/24"], count.index)
  availability_zone       = element(["eu-central-1a", "eu-central-1b"], count.index)
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "freenow_igw" {
  vpc_id = aws_vpc.freenow_vpc.id
}

resource "aws_route_table" "freenow_route_table" {
  vpc_id = aws_vpc.freenow_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.freenow_igw.id
  }
}

resource "aws_route_table_association" "freenow_association" {
  subnet_id      = aws_subnet.freenow_subnet[0].id
  route_table_id = aws_route_table.freenow_route_table.id
}

resource "aws_db_subnet_group" "freenow_db_subnet_group" {
  name        = "rdsl_db_subnet_group"
  description = "DB subnet group for rds"
  subnet_ids  = [for subnet in aws_subnet.freenow_subnet : subnet.id]
}
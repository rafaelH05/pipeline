resource "aws_vpc" "red_reservas" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.red_reservas.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.red_reservas.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
}

resource "aws_subnet" "subnet_reservas" {
  vpc_id = aws_vpc.red_reservas.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
}

resource "aws_route_table_association" "rt-subnet" {
  route_table_id = aws_route_table.rt.id
  subnet_id = aws_subnet.subnet_reservas.id
}

resource "aws_subnet" "subnet_2" {
  vpc_id = aws_vpc.red_reservas.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"
}

resource "aws_db_subnet_group" "grupo_db" {
  subnet_ids = [ 
    aws_subnet.subnet_reservas.id,
    aws_subnet.subnet_2.id
   ]
}
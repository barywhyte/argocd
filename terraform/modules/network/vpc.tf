
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "main"
  }
}

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "internet_gateway"
  }
}


resource "aws_subnet" "public_subnets" {
  #for_each = var.public_subnets
  count  = "${length(var.public_subnet_cidr)}"
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr[count.index]
  availability_zone = var.public_subnet_az
  map_public_ip_on_launch = var.public_subnet_map_ip
  tags = {
    Name = "public-subnet-${count.index}"
  }
}

resource "aws_subnet" "public_subnets_pu" {
  #for_each = var.public_subnets
  vpc_id     = aws_vpc.main.id
  cidr_block = "192.168.5.0/24"
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = var.public_subnet_map_ip
  tags = {
    Name = "public-subnet-pu"
  }
}

resource "aws_subnet" "private_subnets" {
  count  = "${length(var.private_subnet_cidr)}"
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr[count.index]
  availability_zone = var.private_subnet_az
  map_public_ip_on_launch = var.private_subnet_map_ip
  tags = {
    Name =  "private-subnet-${count.index}"
  }
}

resource "aws_route_table_association" "publicSubnet-publicRt" {
  #for_each = var.public_subnets
  count  = "${length(var.public_subnet_cidr)}"
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "publicSubnet-pu" {
  #for_each = var.public_subnets
  subnet_id      = aws_subnet.public_subnets_pu.id
  route_table_id = aws_route_table.public-route-table.id
}



resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }
  tags = {
    Name = "Public Route Table"
  }
}


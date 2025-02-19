resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_range

  tags = {
    Name = "vpc-${local.name}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw-${local.name}"
  }
}

resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr[count.index]
  availability_zone = local.all_availability_zones[count.index]

  tags = {
    Name = "public-${local.name}-${local.all_availability_zones[count.index]}"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = local.all_availability_zones[count.index]

  tags = {
    Name = "private-${local.name}-${local.all_availability_zones[count.index]}"
  }
}

resource "aws_subnet" "database" {
  count             = length(var.database_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.database_subnet_cidr[count.index]
  availability_zone = local.all_availability_zones[count.index]

  tags = {
    Name = "database-${local.name}-${local.all_availability_zones[count.index]}"
  }
}

resource "aws_eip" "ip" {
  domain = "vpc" # Always set domain = "vpc" when creating an Elastic IP for VPC-based resources like NAT Gateways,

  tags = {
    Name = "eip-${local.name}"
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ip.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "ngw-${local.name}"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id


  tags = {
    Name = "public-${local.name}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id


  tags = {
    Name = "private-${local.name}"
  }
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id


  tags = {
    Name = "database-${local.name}"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw.id
}

resource "aws_route" "database" {
  route_table_id         = aws_route_table.database.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw.id
}

resource "aws_db_subnet_group" "default" {
  name       = "${local.name}-subnet-group"
  subnet_ids = aws_subnet.database[*].id

  tags = {
    Name = "${local.name}-subnet-group"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidr)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
  count          = length(var.database_subnet_cidr)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}


resource "aws_vpc_peering_connection" "vpc_peer" {
  count       = var.is_peering_required ? 1 : 0 # handling the execution of resource
  peer_vpc_id = data.aws_vpc.default.id         #acceptor
  vpc_id      = aws_vpc.main.id                 #requestor
  auto_accept = true                            # if we are doing peering connection for same aws account and region, then we can use this argument else big no..
}

resource "aws_route" "public_to_acceptor_default" {
  count                     = var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peer[0].id
}

resource "aws_route" "private_to_acceptor_default" {
  count                     = var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peer[0].id
}

resource "aws_route" "database_to_acceptor_default" {
  count                     = var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peer[0].id
}


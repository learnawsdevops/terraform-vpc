output "all_availability_zones" {
  value = data.aws_availability_zones.us.names

}

output "default_vpc_id" {
  value = aws_vpc.main.id

}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "database_subnet_ids" {
  value = aws_subnet.database[*].id
}
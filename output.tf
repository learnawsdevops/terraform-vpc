output "all_availability_zones" {
  value = data.aws_availability_zones.us.names

}

output "default_vpc_id" {
  value = data.aws_vpc.default.id

}
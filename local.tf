locals {
  name                   = join("-", [var.project_name, var.env])
  all_availability_zones = slice(data.aws_availability_zones.us.names, 0, 2)
}
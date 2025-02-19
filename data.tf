data "aws_availability_zones" "us" {
  state = "available"

}

data "aws_vpc" "default" {
  default = true
}
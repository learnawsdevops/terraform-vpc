variable "project_name" {
  type = string
}
variable "env" {
  type = string
}
variable "vpc_cidr_range" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type        = list(string)
  description = "Please provide two valid cidr ranges for public subnets"
  validation {
    condition     = length(var.public_subnet_cidr) == 2
    error_message = "please provide 2 valid subnets cidr range"
  }
}

variable "private_subnet_cidr" {
  type        = list(string)
  description = "Please provide two valid cidr ranges for private subnets"
  validation {
    condition     = length(var.private_subnet_cidr) == 2
    error_message = "please provide 2 valid subnets cidr range"
  }
}

variable "database_subnet_cidr" {
  type        = list(string)
  description = "Please provide two valid cidr ranges for database subnets"
  validation {
    condition     = length(var.database_subnet_cidr) == 2
    error_message = "please provide 2 valid subnets cidr range"
  }
}

variable "is_peering_required" {
  type    = bool
  default = false
}
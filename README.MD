Best Practices for Routes, Route Tables, and Subnet Associations in Terraform
1. Use Separate Route Tables for Public and Private Subnets
• Public subnets: Routes through the Internet Gateway (IGW).
• Private subnets: Routes through the NAT Gateway (for outbound access) or VPN/Transit Gateway (for hybrid connectivity).
Example:

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "Private Route Table"
  }
}

2. Explicitly Associate Subnets with Route Tables
A subnet must be associated with a route table. If no explicit association is defined, AWS automatically assigns it to the default route table.
Example:

# Associate Public Subnet with Public Route Table
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Associate Private Subnet with Private Route Table
resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

3. Use for_each to Handle Multiple Subnets Dynamically
Instead of duplicating code, use for_each for associating multiple subnets dynamically.
Example:

# Associate multiple public subnets to the public route table
resource "aws_route_table_association" "public" {
  for_each       = { for subnet in aws_subnet.public : subnet.availability_zone => subnet.id }
  subnet_id      = each.value
  route_table_id = aws_route_table.public.id
}

# Associate multiple private subnets to the private route table
resource "aws_route_table_association" "private" {
  for_each       = { for subnet in aws_subnet.private : subnet.availability_zone => subnet.id }
  subnet_id      = each.value
  route_table_id = aws_route_table.private.id
}

4. Use aws_default_route_table for Default Configurations
Instead of manually modifying the default route table, use aws_default_route_table to ensure consistency across deployments.
Example:

resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Default Route Table"
  }
}

5. Use Variables for Dynamic Configurations
To make Terraform code reusable, define subnets and route tables dynamically using variables.
Example (variables.tf):

variable "subnet_cidr_blocks" {
  type = map(string)
  default = {
    "public1"  = "10.0.1.0/24"
    "public2"  = "10.0.2.0/24"
    "private1" = "10.0.3.0/24"
    "private2" = "10.0.4.0/24"
  }
}

Example (main.tf):

resource "aws_subnet" "subnets" {
  for_each   = var.subnet_cidr_blocks
  vpc_id     = aws_vpc.main.id
  cidr_block = each.value

  tags = {
    Name = "Subnet-${each.key}"
  }
}

6. Follow Naming Conventions
Use consistent naming conventions for easy filtering and debugging. Example:

tags = {
  Name        = "public-route-table"
  Environment = "dev"
  Project     = "my-app"
}

7. Use terraform fmt and terraform validate
Use the following Terraform commands to ensure clean and error-free configurations:

terraform fmt      # Formats code for readability
terraform validate # Checks for syntax errors and best practices

Final Summary

✅ Separate public and private route tables
✅ Explicitly associate subnets with route tables
✅ Use for_each for scalability
✅ Use aws_default_route_table for default VPC routing
✅ Follow consistent naming conventions
✅ Format and validate code with Terraform commands


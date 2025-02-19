#terraform fmt command will make indentation adjustments for better readability
module "roboshop" {
  source               = "../terraform-vpc"
  vpc_cidr_range       = var.vpc_cidr_range
  project_name         = var.project_name
  env                  = var.env
  public_subnet_cidr   = var.public_subnet_cidr
  private_subnet_cidr  = var.private_subnet_cidr
  database_subnet_cidr = var.database_subnet_cidr
  is_peering_required  = var.is_peering_required
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.86.1"
    }
  }
  backend "s3" {
    bucket         = "learnawsdevops"
    key            = "vpc-test"
    region         = "us-east-1"
    dynamodb_table = "learnawsdevops-locking"
  }
}

provider "aws" {
  region = "us-east-1"
}
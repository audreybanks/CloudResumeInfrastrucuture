terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.72"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-2"
  default_tags {
    tags = {
      Name = "Cloud Resume"
    }
  }
}

resource "aws_s3_bucket" "frontend" {
  bucket = "audrey-banks-cloud-resume-frontend"
}

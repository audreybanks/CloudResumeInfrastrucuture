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

provider "aws" {
  alias  = "east1"
  region = "us-east-1"
  default_tags {
    tags = {
      Name = "Cloud Resume"
    }
  }
}
